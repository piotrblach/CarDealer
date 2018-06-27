
({
    showCreateNewCaseModal: function(component, event, helper){
        component.find("createNewCaseModal").show();
    },
    hideCreateNewCaseModal: function(component, event, helper){
        component.find("createNewCaseModal").hide();
    },
    doInit: function(component, event, helper){
        helper.loadCaseTypeOptions(component);
        helper.loadCaseReasonOptions(component);
        helper.loadCaseProductOptions(component);
    },
    onCreateCase: function(component, event, helper){
        helper.createCase(component);
    },

})