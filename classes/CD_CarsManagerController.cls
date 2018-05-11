/**
 * Created by BRITENET on 09.05.2018.
 */

public with sharing class CD_CarsManagerController {
    @AuraEnabled
    public static List<Product2> getCarsList(Product2 searchedCar){
        return Database.query(generateQueryStringForSearchedCars(searchedCar));
    }

    @AuraEnabled
    public static Product2 createCar(Product2 newCar){
        try{
            insert newCar;
            return newCar;
        }catch(DmlException e){
            return null;
        }
    }

    private static String generateQueryStringForSearchedCars(Product2 searchedCar){
        String queryString;
        String conditionsSection = '';
        queryString = 'SELECT Id, Name, CD_VIN__c, CD_Year__c, CD_Model__c FROM Product2 ';
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


        queryString+= conditionsSection == null ? '' : conditionsSection;
        system.debug(queryString);
        return queryString;
    }
}