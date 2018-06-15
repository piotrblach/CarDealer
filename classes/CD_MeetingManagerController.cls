
public with sharing class CD_MeetingManagerController {

    @AuraEnabled
    public static List<CD_Wrappers.CD_ProductMeeting> loadMeetingsWaitingToAssign(){
        List<Event> meetingsWaitingToAssign = [
            SELECT Id, OwnerId, WhatId, CreatedById, StartDateTime, EndDateTime
            FROM Event
            WHERE OwnerId =: UserInfo.getUserId() AND CD_AssignedToSalesRep__c = false
        ];
        Set<Id> carIds = new Set<Id>();
        for(Event event : meetingsWaitingToAssign){
            carIds.add(event.WhatId);
        }
        Map<Id, Product2> productMeetingCarsMap = new Map<Id, Product2>([
                SELECT Id, Name, CD_VIN__c, CD_Year__c, CD_Model__c
                FROM Product2
                WHERE Id IN : carIds
        ]);

        List<CD_Wrappers.CD_ProductMeeting> productMeetings = new List<CD_Wrappers.CD_ProductMeeting>();
        for(Event event : meetingsWaitingToAssign){
            productMeetings.add(new CD_Wrappers.CD_ProductMeeting(event, productMeetingCarsMap.get(event.WhatId)));
        }
        return productMeetings.size() > 0 ? productMeetings : new List<CD_Wrappers.CD_ProductMeeting>();
    }

    @AuraEnabled
    public static List<CD_Wrappers.CD_ProductMeeting> loadAssignedToSubordinaries(){
        List<Event> assignedMeetings = [
                SELECT Id, OwnerId, WhatId, CreatedById, StartDateTime, EndDateTime
                FROM Event
                WHERE CD_AssignedToSalesRep__c = true
        ];
        Set<Id> carIds = new Set<Id>();
        Set<Id> salesRepsIds = new Set<Id>();
        for(Event event : assignedMeetings){
            carIds.add(event.WhatId);
            salesRepsIds.add(event.OwnerId);
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

        List<CD_Wrappers.CD_ProductMeeting> productMeetings = new List<CD_Wrappers.CD_ProductMeeting>();
        for(Event event : assignedMeetings){
            productMeetings.add(new CD_Wrappers.CD_ProductMeeting(event, productMeetingCarsMap.get(event.WhatId), productMeetingSalesRepsMap.get(event.OwnerId)));
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
            return 'Success';
        }catch (DmlException e){
            System.debug(Label.CD_Error_assigning_meetings_to_sales_rep + e.getMessage());
            throw new AuraHandledException(Label.CD_Error_assigning_meetings_to_sales_rep);
        }
    }
}