
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