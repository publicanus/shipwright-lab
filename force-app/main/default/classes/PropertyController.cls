public with sharing class PropertyController {
    private static final Decimal DEFAULT_MAX_PRICE = 9999999;
    private static final Integer DEFAULT_PAGE_SIZE = 9;
    private static final String SORT_PRICE = 'price';
    private static final String SORT_PRICE_PER_SQM = 'pricePerSqm';

    /**
     * Endpoint that retrieves a paged and filtered list of properties
     * @param searchKey String used for searching on property title, city and tags
     * @param maxPrice Maximum price
     * @param minBedrooms Minimum number of bedrooms
     * @param minBathrooms Minimum number of bathrooms
     * @param pageSize Number of properties per page
     * @param pageNumber Page number
     * @param sortBy Sort choice: 'price' (default) or 'pricePerSqm'
     * @return PagedResult object holding the paged and filtered list of properties
     */
    @AuraEnabled(cacheable=true scope='global')
    public static PagedResult getPagedPropertyList(
        String searchKey,
        Decimal maxPrice,
        Integer minBedrooms,
        Integer minBathrooms,
        Integer pageSize,
        Integer pageNumber,
        String sortBy
    ) {
        // Normalize inputs
        Decimal safeMaxPrice = maxPrice ?? DEFAULT_MAX_PRICE;
        Integer safeMinBedrooms = minBedrooms ?? 0;
        Integer safeMinBathrooms = minBathrooms ?? 0;
        Integer safePageSize = pageSize ?? DEFAULT_PAGE_SIZE;
        Integer safePageNumber = pageNumber ?? 1;
        String safeSortBy = normalizeSortBy(sortBy);

        String searchPattern = '%' + searchKey + '%';
        Integer offset = (safePageNumber - 1) * safePageSize;

        PagedResult result = new PagedResult();
        result.pageSize = safePageSize;
        result.pageNumber = safePageNumber;
        result.totalItemCount = [
            SELECT COUNT()
            FROM Property__c
            WHERE
                (Name LIKE :searchPattern
                OR City__c LIKE :searchPattern
                OR Tags__c LIKE :searchPattern)
                AND Price__c <= :safeMaxPrice
                AND Beds__c >= :safeMinBedrooms
                AND Baths__c >= :safeMinBathrooms
        ];

        // ORDER BY can't be bound like a normal value, so the clause is picked from a
        // fixed whitelist of two literals (never from raw user input) and spliced into
        // the query text; the rest of the query stays a single shared definition.
        String orderByClause = (safeSortBy == SORT_PRICE_PER_SQM)
            ? 'ORDER BY Price_Per_Sqm__c ASC NULLS LAST'
            : 'ORDER BY Price__c';
        String query =
            'SELECT Id, Name, Address__c, City__c, State__c, Description__c, ' +
            'Price__c, Baths__c, Beds__c, Thumbnail__c, Location__Latitude__s, ' +
            'Location__Longitude__s, Price_Per_Sqm__c ' +
            'FROM Property__c ' +
            'WHERE (Name LIKE :searchPattern OR City__c LIKE :searchPattern OR Tags__c LIKE :searchPattern) ' +
            'AND Price__c <= :safeMaxPrice ' +
            'AND Beds__c >= :safeMinBedrooms ' +
            'AND Baths__c >= :safeMinBathrooms ' +
            orderByClause +
            ' ' +
            'LIMIT :safePageSize OFFSET :offset';
        result.records = Database.query(query, AccessLevel.USER_MODE);
        return result;
    }

    /**
     * Validates the requested sort choice against the two supported values.
     * A missing/blank value defaults to sorting by price; any other value is rejected
     * rather than silently defaulted, since it can only originate from a malformed call.
     */
    private static String normalizeSortBy(String sortBy) {
        if (String.isBlank(sortBy)) {
            return SORT_PRICE;
        }
        if (sortBy == SORT_PRICE || sortBy == SORT_PRICE_PER_SQM) {
            return sortBy;
        }
        AuraHandledException ex = new AuraHandledException(
            'Invalid sortBy value: ' + sortBy
        );
        ex.setMessage('Invalid sortBy value: ' + sortBy);
        throw ex;
    }

    /**
     * Endpoint that retrieves pictures associated with a property
     * @param propertyId Property Id
     * @return List of ContentVersion holding the pictures
     */
    @AuraEnabled(cacheable=true scope='global')
    public static List<ContentVersion> getPictures(Id propertyId) {
        List<ContentDocumentLink> links = [
            SELECT Id, LinkedEntityId, ContentDocument.Title
            FROM ContentDocumentLink
            WHERE
                LinkedEntityId = :propertyId
                AND ContentDocument.FileType IN ('PNG', 'JPG', 'GIF')
            WITH USER_MODE
        ];

        if (links.isEmpty()) {
            return null;
        }

        Set<Id> contentIds = new Set<Id>();

        for (ContentDocumentLink link : links) {
            contentIds.add(link.ContentDocumentId);
        }

        return [
            SELECT Id, Title
            FROM ContentVersion
            WHERE ContentDocumentId IN :contentIds AND IsLatest = TRUE
            WITH USER_MODE
            ORDER BY CreatedDate
        ];
    }
}
