
public with sharing class CD_CasesController {
    @AuraEnabled
    public static List<Case> loadActiveCases(){
        User currentUser = CD_Utils.getCurrentUserDetails();
        List<Case> activeCases = [
                SELECT Id, Subject, Description, Status, CreatedDate, CaseNumber, CD_Car__r.Name
                FROM Case
                WHERE ContactId =: currentUser.ContactId AND Status != 'Closed'
        ];
        return activeCases;
    }

    @AuraEnabled
    public static List<Case> loadSolvedCases(){
        User currentUser = CD_Utils.getCurrentUserDetails();
        List<Case> activeCases = [
                SELECT Id, Subject, Description, Status, CreatedDate, CaseNumber, ClosedDate, CD_Car__r.Name
                FROM Case
                WHERE ContactId =: currentUser.ContactId AND Status = 'Closed'
        ];
        return activeCases;
    }

    @AuraEnabled
    public static List<String> getCaseTypePicklistValues(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Case.Type.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry pleItem: ple) {
            options.add(pleItem.getLabel());
        }
        return options;
    }

    @AuraEnabled
    public static List<String> getCaseReasonPicklistValues(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Case.Reason.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry pleItem: ple) {
            options.add(pleItem.getLabel());
        }
        return options;
    }

    @AuraEnabled
    public static String createCase(Case newCase){
        User currentUser = CD_Utils.getCurrentUserDetails();
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.UseDefaultRule = true;
        newCase.setOptions(dmlOpts);

        newCase.Status = 'New';
        newCase.Priority = 'Medium';
        newCase.Origin = 'Web';
        newCase.ContactId = currentUser.ContactId;
        newCase.AccountId = currentUser.AccountId;
        try{
            insert newCase;
            return Label.CD_SUCCESS;
        }catch (DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                System.debug(e.getDmlMessage(i));
            }
            throw new AuraHandledException(Label.CD_Error_when_creating_new_case);
        }
    }

    @AuraEnabled
    public static List<Product2> getCustomerOwnedProducts(){
        User currentUser = CD_Utils.getCurrentUserDetails();
        List<OrderItem> orderItems = [
                SELECT Product2Id
                FROM OrderItem
                WHERE Order.Opportunity.CD_Contact__c =: currentUser.ContactId
        ];
        Set<Id> carIds = new Set<Id>();
        for(OrderItem orderItem : orderItems){
            carIds.add(orderItem.Product2Id);
        }
        List<Product2> customerOwnedProducts = [
                SELECT Id, Name, CD_VIN__c
                FROM Product2
                WHERE Id IN: carIds
        ];
        return customerOwnedProducts != null ? customerOwnedProducts : new List<Product2>();
    }
}