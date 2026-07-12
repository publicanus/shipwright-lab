@isTest
private class TestPropertyController {
    private final static String MOCK_PICTURE_NAME = 'MockPictureName';

    public static void createProperties(Integer amount) {
        List<Property__c> properties = new List<Property__c>();
        for (Integer i = 0; i < amount; i++) {
            properties.add(
                new Property__c(
                    Name = 'Name ' + i,
                    Price__c = 20000,
                    Beds__c = 3,
                    Baths__c = 3
                )
            );
        }
        insert properties;
    }

    /**
     * getPagedPropertyList runs WITH USER_MODE, so exercising it needs a user carrying
     * the 'dreamhouse' permission set's field access — the running test user alone isn't
     * enough (mirrors the FLS the LWC's own users get via that permission set).
     * @return a newly inserted Standard-profile user assigned the 'dreamhouse' permission set
     */
    private static User createDreamhouseTestUser() {
        Profile standardUserProfile = [
            SELECT Name, Id
            FROM Profile
            WHERE
                UserType = 'Standard'
                AND PermissionsPrivacyDataAccess = FALSE
                AND PermissionsSubmitMacrosAllowed = TRUE
                AND PermissionsMassInlineEdit = TRUE
            LIMIT 1
        ];
        User testUser = new User(
            Alias = 'standt',
            Email = 'standarduser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = standardUserProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'standarduser' +
                Crypto.getRandomInteger() +
                '@dreamhouse-testorg.com'
        );
        insert testUser;
        PermissionSet ps = [
            SELECT Id
            FROM PermissionSet
            WHERE Name = 'dreamhouse'
        ];
        insert new PermissionSetAssignment(
            AssigneeId = testUser.Id,
            PermissionSetId = ps.Id
        );
        return testUser;
    }

    @isTest
    static void testGetPagedPropertyList() {
        User testUser = createDreamhouseTestUser();

        // Insert test properties as admin
        System.runAs(new User(Id = UserInfo.getUserId())) {
            TestPropertyController.createProperties(5);
        }
        // Read properties as test user
        System.runAs(testUser) {
            Test.startTest();
            PagedResult result = PropertyController.getPagedPropertyList(
                '',
                999999,
                0,
                0,
                10,
                1,
                null
            );
            Test.stopTest();
            Assert.areEqual(5, result.records.size());
        }
    }

    @isTest
    static void testGetPagedPropertyListDefaultSortIsByPrice() {
        User testUser = createDreamhouseTestUser();

        System.runAs(new User(Id = UserInfo.getUserId())) {
            insert new List<Property__c>{
                new Property__c(
                    Name = 'Cheaper',
                    Price__c = 100000,
                    Beds__c = 2,
                    Baths__c = 1,
                    Living_Area__c = 50
                ),
                new Property__c(
                    Name = 'Pricier',
                    Price__c = 500000,
                    Beds__c = 2,
                    Baths__c = 1,
                    Living_Area__c = 50
                )
            };
        }

        System.runAs(testUser) {
            Test.startTest();
            PagedResult result = PropertyController.getPagedPropertyList(
                '',
                999999,
                0,
                0,
                10,
                1,
                null
            );
            Test.stopTest();

            List<Property__c> records = (List<Property__c>) result.records;
            Assert.areEqual(2, records.size());
            Assert.areEqual('Cheaper', records[0].Name);
            Assert.areEqual('Pricier', records[1].Name);
        }
    }

    @isTest
    static void testGetPagedPropertyListSortsByPricePerSqmWithNullAreaLast() {
        User testUser = createDreamhouseTestUser();

        System.runAs(new User(Id = UserInfo.getUserId())) {
            insert new List<Property__c>{
                new Property__c(
                    Name = 'No area',
                    Price__c = 100000,
                    Beds__c = 2,
                    Baths__c = 1
                ),
                new Property__c(
                    Name = 'Expensive per sqm',
                    Price__c = 600000,
                    Beds__c = 2,
                    Baths__c = 1,
                    Living_Area__c = 60
                ),
                new Property__c(
                    Name = 'Cheap per sqm',
                    Price__c = 200000,
                    Beds__c = 2,
                    Baths__c = 1,
                    Living_Area__c = 100
                )
            };
        }

        System.runAs(testUser) {
            Test.startTest();
            PagedResult result = PropertyController.getPagedPropertyList(
                '',
                999999,
                0,
                0,
                10,
                1,
                'pricePerSqm'
            );
            Test.stopTest();

            List<Property__c> records = (List<Property__c>) result.records;
            Assert.areEqual(3, records.size());
            Assert.areEqual('Cheap per sqm', records[0].Name);
            Assert.areEqual('Expensive per sqm', records[1].Name);
            Assert.areEqual('No area', records[2].Name);
            Assert.areEqual(2000, records[0].Price_Per_Sqm__c);
            Assert.areEqual(10000, records[1].Price_Per_Sqm__c);
            Assert.isNull(records[2].Price_Per_Sqm__c);
        }
    }

    @isTest
    static void testGetPagedPropertyListRejectsInvalidSortBy() {
        User testUser = createDreamhouseTestUser();

        System.runAs(testUser) {
            Boolean threw = false;
            try {
                PropertyController.getPagedPropertyList(
                    '',
                    999999,
                    0,
                    0,
                    10,
                    1,
                    'notAValidSort'
                );
            } catch (AuraHandledException e) {
                threw = true;
            }
            Assert.isTrue(threw, 'An invalid sortBy value should throw');
        }
    }

    @isTest
    static void testGetPicturesNoResults() {
        Property__c property = new Property__c(Name = 'Name');
        insert property;

        Test.startTest();
        List<ContentVersion> items = PropertyController.getPictures(
            property.Id
        );
        Test.stopTest();

        Assert.isNull(items);
    }

    @isTest
    static void testGetPicturesWithResults() {
        Property__c property = new Property__c(Name = 'Name');
        insert property;

        // Insert mock picture
        ContentVersion picture = new Contentversion();
        picture.Title = MOCK_PICTURE_NAME;
        picture.PathOnClient = 'picture.png';
        picture.Versiondata = EncodingUtil.base64Decode('MockValue');
        insert picture;

        // Link picture to property record
        List<ContentDocument> documents = [
            SELECT Id, Title, LatestPublishedVersionId
            FROM ContentDocument
            LIMIT 1
        ];
        ContentDocumentLink link = new ContentDocumentLink();
        link.LinkedEntityId = property.Id;
        link.ContentDocumentId = documents[0].Id;
        link.shareType = 'V';
        insert link;

        Test.startTest();
        List<ContentVersion> items = PropertyController.getPictures(
            property.Id
        );
        Test.stopTest();

        Assert.areEqual(1, items.size());
        Assert.areEqual(MOCK_PICTURE_NAME, items[0].Title);
    }
}
