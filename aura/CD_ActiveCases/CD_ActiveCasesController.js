
({
    doInit: function(component, event, helper){
        helper.loadActiveCases(component);
    },
    onNewCaseCreated: function(component, event, helper){
        helper.loadActiveCases(component);
    },
    goToCaseDetailPage: function(component, event, helper){
        let caseId = event.currentTarget.dataset.caseid;
        let navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
          "recordId": caseId,
          "slideDevName": "related"
        });
        navEvt.fire();
    },
})