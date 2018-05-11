/**
 * Created by BRITENET on 30.04.2018.
 */

public with sharing class CD_RegisterWebLeadController {
    public Lead newLead {get; set;}

    public CD_RegisterWebLeadController(){
        newLead = new Lead();
    }

    public void saveNewLead(){
        newLead.LeadSource = 'Web';
        try{
            insert newLead;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'U were registered in our company'));
            newLead = new Lead();
        }catch (DmlException e){
            System.debug(e.getMessage());
        }
    }
}