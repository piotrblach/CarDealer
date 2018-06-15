public with sharing class CD_CarsManagerController {
    @AuraEnabled
    public static String setImageAsPrimaryCarImage(String imageId, String carId){
        Product2 car = [SELECT Id, CD_LogoImageId__c FROM Product2 WHERE Id =: carId];
        car.CD_LogoImageId__c = imageId;
        ContentVersion cv = [SELECT Id from ContentVersion WHERE ContentDocumentId =: imageId];
        car.CD_ContentDocumentVersion__c = cv.Id;
        try {
            update car;
            return 'Success';
        }catch (DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                // Process exception here
                System.debug(e.getDmlMessage(i));
            }
            return 'Error';
        }
    }

    @AuraEnabled
    public static String removeCarImage(String imageId){
        ContentDocument image = [SELECT Id FROM ContentDocument WHERE Id =: imageId];
        try {
            delete image;
            return 'Success';
        }catch (DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                // Process exception here
                System.debug(e.getDmlMessage(i));
            }
            return 'Error';
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
    public static String addCarToUserCart(Product2 car){
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
        cartItems.add(new CD_Wrappers.CD_CartItem(car, null));
        Cache.Session.put('local.Cart.cartItems', cartItems);
        return 'Success';
    }

    @AuraEnabled
    public static List<CD_Wrappers.CD_CartItem> getCustomerCartItems(){
        List<CD_Wrappers.CD_CartItem> cartItems;

        if (Cache.Session.contains('local.Cart.cartItems')) {
            cartItems = (List<CD_Wrappers.CD_CartItem>)Cache.Session.get('local.Cart.cartItems');
        }else{
            cartItems = new List<CD_Wrappers.CD_CartItem>();
        }
        return cartItems;
    }

    @AuraEnabled
    public static String proceedToCheckout(){
        List<CD_Wrappers.CD_CartItem> cartItems;
        if (Cache.Session.contains('local.Cart.cartItems')) {
            cartItems = (List<CD_Wrappers.CD_CartItem>)Cache.Session.get('local.Cart.cartItems');
        }

        List<Event> productMeetings = new List<Event>();
        if(cartItems != null){
            for(Integer ii = 0; ii < cartItems.size(); ii++){
                Event productMeeting = new Event();
                productMeeting.StartDateTime = cartItems[ii].meetingDate;
                productMeeting.EndDateTime = cartItems[ii].meetingDate.addHours(1);
                productMeeting.WhatId = cartItems[ii].car.Id;
                productMeeting.Subject = Label.CD_New_product_meeting;
                productMeeting.OwnerId = UserInfo.getUserId();
                productMeetings.add(productMeeting);
            }
        }else{
            throw new AuraHandledException(Label.CD_Customer_cart_is_empty);
        }

        try{
            insert productMeetings;
            deleteAllCustomerCartItems();
        }catch (DmlException e){
            throw new AuraHandledException(Label.CD_Error_creating_product_meetings);
        }
        return String.valueOf(cartItems.size());
    }

    private static void deleteAllCustomerCartItems(){
        if (Cache.Session.contains('local.Cart.cartItems')) {
            Cache.Session.remove('local.Cart.cartItems');
        }
    }

    @AuraEnabled
    public static List<CD_Wrappers.CD_ProductMeeting> loadCustomerPurchases(){
        List<Event> productMeetingEvents = [
                SELECT Id, OwnerId, WhatId, CreatedById, StartDateTime
                FROM Event
                WHERE CreatedById =: UserInfo.getUserId()
        ];
        Set<Id> carIds = new Set<Id>();
        for(Event event : productMeetingEvents){
            carIds.add(event.WhatId);
        }
        Map<Id, Product2> productMeetingCarsMap = new Map<Id, Product2>([
                SELECT Id, Name, CD_VIN__c, CD_Year__c, CD_Model__c
                FROM Product2
                WHERE Id IN : carIds
        ]);

        List<CD_Wrappers.CD_ProductMeeting> productMeetings = new List<CD_Wrappers.CD_ProductMeeting>();
        for(Event event : productMeetingEvents){
            productMeetings.add(new CD_Wrappers.CD_ProductMeeting(event, productMeetingCarsMap.get(event.WhatId)));
        }
        return productMeetings.size() > 0 ? productMeetings : new List<CD_Wrappers.CD_ProductMeeting>();
    }

    @AuraEnabled
    public static String deleteCustomerCartItem(String[] carIdsToRemove){
        List<CD_Wrappers.CD_CartItem> cartItems;

        if (Cache.Session.contains('local.Cart.cartItems')) {
            cartItems = (List<CD_Wrappers.CD_CartItem>)Cache.Session.get('local.Cart.cartItems');
        }else{
            cartItems = new List<CD_Wrappers.CD_CartItem>();
        }

        if(cartItems != null){
            for(Integer ii = 0; ii < cartItems.size(); ii++){
                for(Integer jj = 0; jj < carIdsToRemove.size(); jj++){
                    if(cartItems[ii].car.Id == carIdsToRemove[jj]){
                        cartItems.remove(ii);
                    }
                }
            }
        }

        Cache.Session.put('local.Cart.cartItems', cartItems);
        return String.valueOf(cartItems.size());
    }

    @AuraEnabled
    public static String setCartItemMeetingDate(String[] carIdsToSetMeeting, String meetingDate){
        List<CD_Wrappers.CD_CartItem> cartItems;

        if (Cache.Session.contains('local.Cart.cartItems')) {
            cartItems = (List<CD_Wrappers.CD_CartItem>)Cache.Session.get('local.Cart.cartItems');
        }else{
            cartItems = new List<CD_Wrappers.CD_CartItem>();
        }
        if(cartItems != null){
            for(Integer ii = 0; ii < cartItems.size(); ii++){
                for(Integer jj = 0; jj < carIdsToSetMeeting.size(); jj++){
                    if(cartItems[ii].car.Id == carIdsToSetMeeting[jj]){
                        cartItems[ii].meetingDate = Datetime.valueOf(meetingDate.substringBeforeLast('.').replace('T',' '));
                    }
                }
            }
        }
        Cache.Session.put('local.Cart.cartItems', cartItems);
        return String.valueOf(cartItems.size());
    }

    @AuraEnabled
    public static List<ContentDocumentLink> getCarImages(String carId){
        return [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: carId];
    }

    private static String generateQueryStringForSearchedCars(Product2 searchedCar){
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

//    @AuraEnabled
//    public static String uploadImages(String images){
//        List<Map<String, String>> imagesList = (List<Map<String, String>>)JSON.deserialize(images, List<Map<String, String>>.class);
//        List<Attachment> attachments = new List<Attachment>();
//        for(Map<String, String> image : imagesList){
//            Attachment attachment = new Attachment();
//            attachment.parentId = image.get('parentId');
//            attachment.body = EncodingUtil.base64Decode(image.get('base64Data'));
//            attachment.name = image.get('fileName');
//            attachment.contentType = image.get('contentType');
//            attachments.add(attachment);
//        }
//
//        try {
//            insert attachments;
//            return 'Success';
//        }catch (DmlException e){
//            return 'Error';
//        }
//    }
//    @AuraEnabled
//    public static Product2 getCarDetails(String carId){
//        Product2 car = [
//            SELECT Id, Name, CD_VIN__c, CD_Year__c, CD_Model__c, CD_LogoImageId__c
//            FROM Product2
//            WHERE Id =: carId
//        ];
//        return car == null ? new Product2() : car;
//    }
//
//    @AuraEnabled
//    public static Product2 createCar(Product2 newCar){
//        try{
//            insert newCar;
//            return newCar;
//        }catch(DmlException e){
//            return null;
//        }
//    }
//
//    @AuraEnabled
//    public static String removeCar(Product2 carToDelete){
//        System.debug('delete');
//        if(carToDelete != null){
//            try{
//                delete carToDelete;
//                return 'SUCCESS';
//            }catch(DmlException e){
//                return 'ERROR';
//            }
//        }else{
//            return 'ERROR';
//        }
//    }
//
//    @AuraEnabled
//    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
//        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
//
//        Attachment a = new Attachment();
//        a.parentId = parentId;
//
//        a.Body = EncodingUtil.base64Decode(base64Data);
//        a.Name = fileName;
//        a.ContentType = contentType;
//
//        insert a;
//
//        return a.Id;
//    }
//
//    @AuraEnabled
//    public static Id saveTheChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
//        if (fileId == '') {
//            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
//        } else {
//            appendToFile(fileId, base64Data);
//        }
//
//        return Id.valueOf(fileId);
//    }
//
//    private static void appendToFile(Id fileId, String base64Data) {
//        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
//
//        Attachment a = [
//                SELECT Id, Body
//                FROM Attachment
//                WHERE Id = :fileId
//        ];
//
//        String existingBody = EncodingUtil.base64Encode(a.Body);
//        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
//
//        update a;
//    }
}