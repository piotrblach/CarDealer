
public with sharing class CD_PriceBookController {
    @AuraEnabled
    public static List<Pricebook2> loadPriceBooks(){
        List<Pricebook2> priceBooks = [
                SELECT Id, Name, CD_ActiveEndDate__c, CD_ActiveStartDate__c, IsActive, IsStandard, CD_DiscountModel__c, CD_DiscountType__c, CD_DiscountValue__c, CD_ProductionEndDate__c, CD_ProductionStartDate__c
                FROM Pricebook2
        ];
        if(priceBooks != null){
            return priceBooks;
        }else{
            return new List<Pricebook2>();
        }
    }

    @AuraEnabled
    public static String saveNewPriceBook(String newPriceBookActiveStartDate, String newPriceBookActiveEndDate, String newPriceBookDiscountType, Decimal newPriceBookDiscountValue,
                                          String newPriceBookProductionStartDate, String newPriceBookProductionEndDate, String newPriceBookCarModel, String newPriceBookName){

        List<Product2> carsForDiscount = Database.query(generateQueryStringForProducts(newPriceBookProductionStartDate, newPriceBookProductionEndDate,newPriceBookCarModel));
        Map<Id, Product2> carsForDiscountMap = new Map<Id, Product2>(carsForDiscount);
        Pricebook2 standardPriceBook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true];
        List<PricebookEntry> carsForDiscountStandardPrices = [SELECT Id, UnitPrice, Product2Id FROM PricebookEntry WHERE Pricebook2Id =: standardPriceBook.Id];

        Map<Id, PricebookEntry> carsForDiscountStandardPricesMap = new Map<Id, PricebookEntry>();
        for(PricebookEntry priceBookEntry : carsForDiscountStandardPrices){
            carsForDiscountStandardPricesMap.put(priceBookEntry.Product2Id, priceBookEntry);
        }
        List<PricebookEntry> priceBookItems  = new List<PricebookEntry>();
        Pricebook2 newDiscount = createPriceBook(newPriceBookActiveStartDate, newPriceBookActiveEndDate, newPriceBookDiscountType, newPriceBookDiscountValue,
                newPriceBookProductionStartDate, newPriceBookProductionEndDate, newPriceBookCarModel, newPriceBookName
        );

        for(Product2 product : carsForDiscount){
            Double value = 0;
            if(newPriceBookDiscountType == 'percentage'){
                value = carsForDiscountStandardPricesMap.get(product.Id).UnitPrice*((100-newPriceBookDiscountValue)/100);
            }else{
                value = carsForDiscountStandardPricesMap.get(product.Id).UnitPrice-newPriceBookDiscountValue;
            }
            if(value > 0){
                priceBookItems.add(new PricebookEntry(Product2Id=product.Id, Pricebook2Id=newDiscount.Id, UnitPrice=value, IsActive=true));
            }
        }
        try{
            insert priceBookItems;
            return Label.CD_SUCCESS;
        }catch (DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                System.debug(e.getDmlMessage(i));
            }
            throw new AuraHandledException(Label.CD_Error_when_creating_discount);
        }
    }

    private static Pricebook2 createPriceBook(String newPriceBookActiveStartDate, String newPriceBookActiveEndDate, String newPriceBookDiscountType, Decimal newPriceBookDiscountValue,
                                              String newPriceBookProductionStartDate, String newPriceBookProductionEndDate, String newPriceBookCarModel, String newPriceBookName){
        Pricebook2 newDiscount = new Pricebook2(
                Name=newPriceBookName,
                CD_ActiveEndDate__c=Date.valueOf(newPriceBookActiveStartDate),
                CD_ActiveStartDate__c=Date.valueOf(newPriceBookActiveEndDate),
                CD_DiscountModel__c=newPriceBookCarModel,
                CD_DiscountType__c=newPriceBookDiscountType,
                CD_DiscountValue__c=newPriceBookDiscountValue,
                CD_ProductionEndDate__c= newPriceBookProductionEndDate != null ? Date.valueOf(newPriceBookProductionEndDate) : null,
                CD_ProductionStartDate__c= newPriceBookProductionStartDate != null ? Date.valueOf(newPriceBookProductionStartDate) : null,
                IsActive=true
        );
        try{
            insert newDiscount;
            return newDiscount;
        }catch (DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                System.debug(e.getDmlMessage(i));
            }
            throw new AuraHandledException(Label.CD_Error_when_creating_discount);
        }
    }

    @AuraEnabled
    public static List<String> getCarModels(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Product2.CD_Model__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry pleItem: ple) {
            options.add(pleItem.getLabel());
        }
        return options;
    }

    @AuraEnabled
    public static List<CD_Wrappers.CD_PriceBookEntry> loadPriceBookEntries(String priceBookId){
        List<PricebookEntry> pricebookEntries = [
                SELECT Id, UnitPrice, Product2Id
                FROM PricebookEntry
                WHERE Pricebook2Id =: priceBookId
        ];

        if(pricebookEntries != null){
            Set<Id> priceBookEntriesCarsIds = new Set<Id>();
            for(PricebookEntry pbe : pricebookEntries){
                priceBookEntriesCarsIds.add(pbe.Product2Id);
            }
            Map<Id, Product2> priceBookEntriesProductsMap = new Map<Id, Product2>([
                    SELECT Id, Name, CD_Model__c, CD_VIN__c, CD_Year__c
                    FROM Product2
                    WHERE Id IN: priceBookEntriesCarsIds
            ]);
            List<CD_Wrappers.CD_PriceBookEntry> priceBookEntriesWrappers = new List<CD_Wrappers.CD_PriceBookEntry>();
            for(PricebookEntry pbe : pricebookEntries){
                priceBookEntriesWrappers.add(new CD_Wrappers.CD_PriceBookEntry(priceBookEntriesProductsMap.get(pbe.Product2Id), pbe));
            }
            return priceBookEntriesWrappers;
        }else{
            throw new AuraHandledException(Label.CD_No_price_book_entries_found);
        }
    }

    @AuraEnabled
    public static String deletePriceBookEntry(String priceBookEntryId){
        List<PricebookEntry> pricebookEntries = [
                SELECT Id
                FROM PricebookEntry
                WHERE Id =: priceBookEntryId
        ];

        try {
            delete pricebookEntries;
            return Label.CD_SUCCESS;
        }catch (DmlException e){
            throw new AuraHandledException(Label.CD_Price_book_entry_not_found);
        }
    }

    @AuraEnabled
    public static String updatePriceBookEntry(String priceBookEntryId, Decimal priceBookEntryEditedPrice){
        List<PricebookEntry> pricebookEntries = [
                SELECT Id, UnitPrice
                FROM PricebookEntry
                WHERE Id =: priceBookEntryId
        ];

        try {
            pricebookEntries[0].UnitPrice = priceBookEntryEditedPrice;
            update pricebookEntries[0];
            return Label.CD_SUCCESS;
        }catch (DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                System.debug(e.getDmlMessage(i));
            }
            throw new AuraHandledException(Label.CD_Price_book_entry_not_found);
        }
    }

    @AuraEnabled
    public static String deletePriceBook(String priceBookId){
        List<Pricebook2> pricebook = [
                SELECT Id
                FROM Pricebook2
                WHERE Id =: priceBookId
        ];

        try {
            delete pricebook[0];
            return Label.CD_SUCCESS;
        }catch (DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                System.debug(e.getDmlMessage(i));
            }
            throw new AuraHandledException(Label.CD_Price_book_cannot_be_deleted);
        }
    }

    @AuraEnabled
    public static List<CD_Wrappers.CD_CarWithStandardPrice> getCarsWithStandardPriceAndNotInPriceBookBySearchParams(Product2 searchedCar, String priceBookId){
        List<PricebookEntry> carsInPriceBook = [SELECT Id, Product2Id FROM PricebookEntry WHERE Pricebook2Id=:priceBookId];
        Set<Id> carsInPriceBookIds = new Set<Id>();
        for(PricebookEntry item : carsInPriceBook){
            carsInPriceBookIds.add(item.Product2Id);
        }
        system.debug(carsInPriceBookIds);
        system.debug(searchedCar);
        List<Product2> cars;
        if(searchedCar == null){
            cars = [
                    SELECT Id, Name, CD_VIN__c, CD_Year__c, CD_Model__c, CD_LogoImageId__c
                    FROM Product2
                    WHERE CD_IsSavingCompleted__c = true AND Id NOT IN: carsInPriceBookIds
            ];
        }
        else{
            cars = Database.query(generateQueryStringForSearchedCars(searchedCar, carsInPriceBookIds));
        }
        Pricebook2 standardPriceBook = [SELECT Id FROM Pricebook2 WHERE IsStandard=true];
        Set<Id> carIds = new Set<Id>();
        for(Product2 car : cars){
            carIds.add(car.Id);
        }

        List<PricebookEntry> standardPrices = [
                SELECT Id, UnitPrice, Product2Id
                FROM PricebookEntry
                WHERE Product2Id IN: carIds AND Pricebook2Id=:standardPriceBook.Id
        ];

        Map<Id, PricebookEntry> carWithStandardPriceMap = new Map<Id, PricebookEntry>();
        for(PricebookEntry standardPrice : standardPrices){
            carWithStandardPriceMap.put(standardPrice.Product2Id, standardPrice);
        }
        List<CD_Wrappers.CD_CarWithStandardPrice> carsWithStandardPrice = new List<CD_Wrappers.CD_CarWithStandardPrice>();
        for(Product2 car : cars){
            carsWithStandardPrice.add(new CD_Wrappers.CD_CarWithStandardPrice(car, carWithStandardPriceMap.get(car.Id).UnitPrice));
        }
        return carsWithStandardPrice != null ? carsWithStandardPrice : new List<CD_Wrappers.CD_CarWithStandardPrice>();
    }

    @AuraEnabled
    public static String addCarsToPriceBook(String priceBookId, String discountItems){
        List<CD_Wrappers.CD_CarToAddToDiscount> discountItemsParam = (List<CD_Wrappers.CD_CarToAddToDiscount>)JSON.deserialize(discountItems, List<CD_Wrappers.CD_CarToAddToDiscount>.class);
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        for(CD_Wrappers.CD_CarToAddToDiscount item : discountItemsParam){
            pricebookEntries.add(new PricebookEntry(Product2Id=item.carId, Pricebook2Id=priceBookId, UnitPrice=item.discountPrice));
        }
        try{
            insert pricebookEntries;
            return Label.CD_SUCCESS;
        }catch (DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                System.debug(e.getDmlMessage(i));
            }
            throw new AuraHandledException(Label.CD_Error_when_adding_cars_to_discount);
        }
    }

    private static String generateQueryStringForSearchedCars(Product2 searchedCar, Set<Id> carsInPriceBookIds){
        String queryString;
        String conditionsSection = '';
        queryString = 'SELECT Id, Name, CD_VIN__c, CD_Year__c, CD_Model__c, CD_LogoImageId__c FROM Product2 ';
        queryString+=  (String.isBlank(searchedCar.Name) &&
                String.isBlank(searchedCar.CD_VIN__c) &&
                searchedCar.CD_Year__c == null &&
                String.isBlank(searchedCar.CD_Model__c)) ? '' : 'WHERE ';

        conditionsSection+= String.isBlank(searchedCar.Name) ? '' : 'Name LIKE \'%' + searchedCar.Name + '%\'';
        conditionsSection+= String.isNotBlank(conditionsSection) && String.isNotBlank(searchedCar.CD_VIN__c) ?  ' AND ' : '' ;
        conditionsSection+= String.isBlank(searchedCar.CD_VIN__c) ? '' : 'CD_VIN__c LIKE \'%' + searchedCar.CD_VIN__c + '%\'';
        conditionsSection+= String.isNotBlank(conditionsSection) && searchedCar.CD_Year__c != null ? ' AND ' : '' ;
        conditionsSection+= searchedCar.CD_Year__c == null ? '' : 'CD_Year__c LIKE \'%' + searchedCar.CD_Year__c + '%\'';
        conditionsSection+= String.isNotBlank(conditionsSection) && String.isNotBlank(searchedCar.CD_Model__c) ? ' AND ' : '' ;
        conditionsSection+= String.isBlank(searchedCar.CD_Model__c) ? '' : 'CD_Model__c = \'' + searchedCar.CD_Model__c + '\'';

        conditionsSection+= String.isNotBlank(conditionsSection) ? 'AND CD_IsSavingCompleted__c = true AND Id NOT IN: carsInPriceBookIds' : 'WHERE CD_IsSavingCompleted__c = true AND Id NOT IN: carsInPriceBookIds';

        queryString+= conditionsSection == null ? '' : conditionsSection;
        system.debug(queryString);
        return queryString;
    }

    private static String generateQueryStringForProducts(String newPriceBookProductionStartDate, String newPriceBookProductionEndDate, String newPriceBookCarModel){
        System.debug(newPriceBookCarModel);
        String queryString;
        String conditionsSection = '';
        queryString = 'SELECT Id FROM Product2 ';
        queryString+=  (newPriceBookProductionStartDate == null &&
                newPriceBookProductionEndDate == null &&
                String.isBlank(newPriceBookCarModel)) ? '' : 'WHERE ';

        conditionsSection+= newPriceBookProductionStartDate == null ? '' : 'CD_Year__c > ' +newPriceBookProductionStartDate;
        conditionsSection+= String.isNotBlank(conditionsSection) && newPriceBookProductionEndDate != null ?  ' AND ' : '';
        conditionsSection+= newPriceBookProductionEndDate == null ? '' : 'CD_Year__c < ' + newPriceBookProductionEndDate;
        conditionsSection+= String.isNotBlank(conditionsSection) && String.isNotBlank(newPriceBookCarModel) ? ' AND ' : '';
        conditionsSection+= String.isBlank(newPriceBookCarModel) ? '' : 'CD_Model__c = \''+newPriceBookCarModel+'\'';

        conditionsSection+= String.isNotBlank(conditionsSection) ? ' AND CD_IsSavingCompleted__c = true' : 'WHERE CD_IsSavingCompleted__c = true';

        queryString+= conditionsSection == null ? '' : conditionsSection;
        system.debug(queryString);
        return queryString;
    }

}