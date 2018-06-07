public with sharing class CD_AutohousesController {
    @AuraEnabled
    public static List<Account> getAutohousesList(Account searchedAutohouse){
        return Database.query(generateQueryStringForSearchedAutohouse(searchedAutohouse));
    }

    @AuraEnabled
    public static Account getAutohouseDetailsById(String autohouseId){
        return [SELECT Id, Name, Phone, Website, BillingCity FROM Account WHERE Id =: autohouseId];
    }

    private static String generateQueryStringForSearchedAutohouse(Account searchedAutohouse){
        String queryString = 'SELECT Id, Name, Location__Latitude__s, Location__Longitude__s FROM Account ';
        queryString+=  (String.isBlank(searchedAutohouse.Name)) ? '' : 'WHERE ';
        String conditionsSection = String.isBlank(searchedAutohouse.Name) ? '' : 'Name LIKE \'%' + searchedAutohouse.Name + '%\'';
        queryString += conditionsSection;
        return queryString;
    }
}