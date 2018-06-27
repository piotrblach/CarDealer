public with sharing class CD_CarsManagerController {
    @AuraEnabled
    public static String setImageAsPrimaryCarImage(String imageId, String carId){
        Product2 car = [SELECT Id, CD_LogoImageId__c FROM Product2 WHERE Id =: carId];
        car.CD_LogoImageId__c = imageId;
        ContentVersion cv = [SELECT Id from ContentVersion WHERE ContentDocumentId =: imageId];
        car.CD_ContentDocumentVersion__c = cv.Id;
        try {
            update car;
            return Label.CD_SUCCESS;
        }catch (DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                System.debug(e.getDmlMessage(i));
            }
            return Label.CD_ERROR;
        }
    }

    @AuraEnabled
    public static String removeCarImage(String imageId){
        ContentDocument image = [SELECT Id FROM ContentDocument WHERE Id =: imageId];
        try {
            delete image;
            return Label.CD_SUCCESS;
        }catch (DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                System.debug(e.getDmlMessage(i));
            }
            return Label.CD_ERROR;
        }
    }

    @AuraEnabled
    public static String setCarStandardPrice(String carId, String price){
        Pricebook2 standardPriceBook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true];
        PricebookEntry newCarStandardPrice = new PricebookEntry(Pricebook2Id = standardPriceBook.Id, Product2Id  = carId, UnitPrice = Double.valueOf(price), IsActive = true);
        try {
            insert newCarStandardPrice;
            return Label.CD_SUCCESS;
        }catch (DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                System.debug(e.getDmlMessage(i));
            }
            throw new AuraHandledException(Label.CD_Error_when_setting_standard_car_price);
        }
    }

    @AuraEnabled
    public static List<Product2> getCarsBySearchParams(Product2 searchedCar){
        if(searchedCar == null){
            return [
                    SELECT Id, Name, CD_VIN__c, CD_Year__c, CD_Model__c, CD_LogoImageId__c
                    FROM Product2
                    WHERE CD_IsSavingCompleted__c = true
            ];
        }else{
            return Database.query(generateQueryStringForSearchedCars(searchedCar));
        }
    }

    @AuraEnabled
    public static String getCarStandardPrice(String carId){
        Pricebook2 standardPriceBook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true];
        if(carId != null){
            PricebookEntry carPrice = [SELECT UnitPrice FROM PricebookEntry WHERE Pricebook2Id =: standardPriceBook.Id AND Product2Id =: carId];
            return String.valueOf(carPrice.UnitPrice);
        }else{
            throw new AuraHandledException(Label.CD_Standard_price_for_this_car_was_not_found);
        }
    }

    @AuraEnabled
    public static PricebookEntry getCarLowestPrice(String carId){
        if(carId != null){
            AggregateResult carPrice = [
                SELECT MIN(UnitPrice) Min_Price, Product2Id
                FROM PricebookEntry
                WHERE Product2Id =: carId
                GROUP BY Product2Id
            ];
            Decimal minPrice = Decimal.valueOf(String.valueOf(carPrice.get('Min_Price')));
            List<PricebookEntry> carLowestPrice = [SELECT Id, UnitPrice, Product2Id, Pricebook2Id FROM PricebookEntry WHERE UnitPrice =: minPrice];
            return carLowestPrice[0];
        }else{
            throw new AuraHandledException(Label.CD_Standard_price_for_this_car_was_not_found);
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
    public static String addCarToUserCart(Product2 car, PricebookEntry carLowestPrice, String carStandardPrice){
        List<CD_Wrappers.CD_CartItem> cartItems;
        if (Cache.Session.contains('local.Cart.cartItems')) {
            cartItems = (List<CD_Wrappers.CD_CartItem>)Cache.Session.get('local.Cart.cartItems');
            if(cartItems != null){
                for(Integer ii = 0; ii < cartItems.size(); ii++){
                    if(cartItems[ii].car.Id == car.Id){
                        throw new AuraHandledException(Label.CD_Item_already_in_cart);
                    }
                }
            }
        }else{
            cartItems = new List<CD_Wrappers.CD_CartItem>();
        }
        cartItems.add(new CD_Wrappers.CD_CartItem(car, carLowestPrice, Decimal.valueOf(carStandardPrice)));
        Cache.Session.put('local.Cart.cartItems', cartItems);
        return Label.CD_SUCCESS;
    }

    @AuraEnabled
    public static List<ContentDocumentLink> getCarImages(String carId){

        return [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: carId];
    }

    private static String generateQueryStringForSearchedCars(Product2 searchedCar){
        system.debug(searchedCar.CD_Year__c);

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

        conditionsSection+= String.isNotBlank(conditionsSection) ? 'AND CD_IsSavingCompleted__c = true' : 'WHERE CD_IsSavingCompleted__c = true';

        queryString+= conditionsSection == null ? '' : conditionsSection;
        system.debug(queryString);
        return queryString;
    }

}