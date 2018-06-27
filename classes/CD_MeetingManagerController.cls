
public with sharing class CD_MeetingManagerController {

    @AuraEnabled
    public static List<CD_Wrappers.CD_ProductMeeting> loadMeetingsWaitingToAssign(){
        List<Event> meetingsWaitingToAssign = [
            SELECT Id, OwnerId, WhatId, CreatedById, StartDateTime, EndDateTime, CD_PriceBookEntry__c, CD_Car__c
            FROM Event
            WHERE OwnerId =: UserInfo.getUserId() AND CD_AssignedToSalesRep__c = false
        ];
        Set<Id> carIds = new Set<Id>();
        Set<Id> priceBookEntriesIds = new Set<Id>();
        for(Event event : meetingsWaitingToAssign){
            carIds.add(event.CD_Car__c);
            priceBookEntriesIds.add(event.CD_PriceBookEntry__c);
        }
        Map<Id, Product2> productMeetingCarsMap = new Map<Id, Product2>([
                SELECT Id, Name, CD_VIN__c, CD_Year__c, CD_Model__c
                FROM Product2
                WHERE Id IN : carIds
        ]);
        Map<Id, PricebookEntry> productMeetingPriceBookEntriesMap = new Map<Id, PricebookEntry>([
                SELECT Id, UnitPrice
                FROM PricebookEntry
                WHERE Id IN : priceBookEntriesIds
        ]);

        List<CD_Wrappers.CD_ProductMeeting> productMeetings = new List<CD_Wrappers.CD_ProductMeeting>();
        for(Event event : meetingsWaitingToAssign){
            productMeetings.add(new CD_Wrappers.CD_ProductMeeting(event, productMeetingCarsMap.get(event.CD_Car__c), productMeetingPriceBookEntriesMap.get(event.CD_PriceBookEntry__c)));
        }
        return productMeetings.size() > 0 ? productMeetings : new List<CD_Wrappers.CD_ProductMeeting>();
    }

    @AuraEnabled
    public static List<CD_Wrappers.CD_ProductMeeting> loadAssignedToSubordinaries(){
        List<Event> assignedMeetings = [
                SELECT Id, OwnerId, WhatId, CreatedById, StartDateTime, EndDateTime, CD_PriceBookEntry__c, CD_Car__c
                FROM Event
                WHERE CD_AssignedToSalesRep__c = true
        ];
        Set<Id> carIds = new Set<Id>();
        Set<Id> salesRepsIds = new Set<Id>();
        Set<Id> priceBookEntriesIds = new Set<Id>();

        for(Event event : assignedMeetings){
            carIds.add(event.CD_Car__c);
            salesRepsIds.add(event.OwnerId);
            priceBookEntriesIds.add(event.CD_PriceBookEntry__c);
        }
        Map<Id, Product2> productMeetingCarsMap = new Map<Id, Product2>([
                SELECT Id, Name, CD_VIN__c, CD_Year__c, CD_Model__c
                FROM Product2
                WHERE Id IN : carIds
        ]);
        Map<Id, User> productMeetingSalesRepsMap = new Map<Id, User>([
                SELECT Id, Name
                FROM User
                WHERE Id IN : salesRepsIds
        ]);
        Map<Id, PricebookEntry> productMeetingPriceBookEntriesMap = new Map<Id, PricebookEntry>([
                SELECT Id, UnitPrice
                FROM PricebookEntry
                WHERE Id IN : priceBookEntriesIds
        ]);

        List<CD_Wrappers.CD_ProductMeeting> productMeetings = new List<CD_Wrappers.CD_ProductMeeting>();
        for(Event event : assignedMeetings){
            productMeetings.add(new CD_Wrappers.CD_ProductMeeting(event, productMeetingCarsMap.get(event.WhatId), productMeetingSalesRepsMap.get(event.OwnerId), productMeetingPriceBookEntriesMap.get(event.CD_PriceBookEntry__c)));
        }
        return productMeetings.size() > 0 ? productMeetings : new List<CD_Wrappers.CD_ProductMeeting>();
    }

    @AuraEnabled
    public static List<User> loadAvailableSalesRepresentatives(){
        List<Profile> profile = [SELECT Id FROM Profile WHERE Name='CD_SalesRep'];
        List<User> salesReps = [
                SELECT Id, Name
                FROM User
                WHERE ProfileId =: profile[0].Id
        ];
        return salesReps.size() > 0 ? salesReps : new List<User>();
    }

    @AuraEnabled
    public static String assignSelectedMeetingsToSalesReps(List<String> selectedMeetingsIds, String selectedSalesRepId){
        List<Event> meetingsWaitingToAssign = [
                SELECT Id, OwnerId
                FROM Event
                WHERE Id IN : selectedMeetingsIds
        ];

        for(Event event : meetingsWaitingToAssign){
            event.OwnerId = selectedSalesRepId;
            event.CD_AssignedToSalesRep__c = true;
        }

        try{
            update meetingsWaitingToAssign;
            return Label.CD_SUCCESS;
        }catch (DmlException e){
            System.debug(Label.CD_Error_assigning_meetings_to_sales_rep + e.getMessage());
            throw new AuraHandledException(Label.CD_Error_assigning_meetings_to_sales_rep);
        }
    }
}