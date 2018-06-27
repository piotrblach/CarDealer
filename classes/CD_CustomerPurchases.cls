

public with sharing class CD_CustomerPurchases {
    @AuraEnabled
    public static List<CD_Wrappers.CD_ProductMeeting> loadCustomerPurchases(){
        User currentUser = CD_Utils.getCurrentUserDetails();
        List<Event> productMeetingEvents = getCustomerPurchasesEvents();

        Set<Id> carIds = new Set<Id>();
        Set<Id> priceBookEntriesIds = new Set<Id>();
        for(Event event : productMeetingEvents){
            carIds.add(event.CD_Car__c);
            priceBookEntriesIds.add(event.CD_PriceBookEntry__c);
        }
        Map<Id, Product2> productMeetingCarsMap = new Map<Id, Product2>([
                SELECT Id, Name, CD_VIN__c, CD_Year__c, CD_Model__c
                FROM Product2
                WHERE Id IN : carIds
        ]);
        Map<Id, PricebookEntry> productMeetingPriceBookEntriesMap = new Map<Id, PricebookEntry>([
                SELECT Id, UnitPrice, Product2Id, Pricebook2Id
                FROM PricebookEntry
                WHERE Id IN : priceBookEntriesIds
        ]);

        List<CD_Wrappers.CD_ProductMeeting> productMeetings = new List<CD_Wrappers.CD_ProductMeeting>();
        for(Event event : productMeetingEvents){
            productMeetings.add(new CD_Wrappers.CD_ProductMeeting(event, productMeetingCarsMap.get(event.CD_Car__c), productMeetingPriceBookEntriesMap.get(event.CD_PriceBookEntry__c)));
        }
        return productMeetings.size() > 0 ? productMeetings : new List<CD_Wrappers.CD_ProductMeeting>();
    }

    private static List<Event> getCustomerPurchasesEvents(){
        User currentUser = CD_Utils.getCurrentUserDetails();
        String adminToken = CD_Utils.getAdminAccessToken();
        String urlBase = CD_Utils.getRestQueryBaseUrl();
        Http http = new Http();qu
        HttpRequest request = new HttpRequest();
        request.setEndpoint(urlBase+'query?q=SELECT+Id,+OwnerId,+WhatId,+CreatedById,+StartDateTime,+CD_PriceBookEntry__c,+CD_Car__c+from+Event+WHERE+CD_Contact__c=\''+currentUser.ContactId+'\'');
        request.setMethod('GET');
        request.setheader('Authorization' ,'Bearer '+adminToken);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            CD_Wrappers.CD_EventQueryResult eqr = (CD_Wrappers.CD_EventQueryResult)JSON.deserialize(response.getBody(), CD_Wrappers.CD_EventQueryResult.class);
            return eqr.records;
        }
        return new List<Event>();
    }
}