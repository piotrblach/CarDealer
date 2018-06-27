
({
    loadCaseTypeOptions: function(component){
        let action = component.get("c.getCaseTypePicklistValues");
        let caseTypeInputSelect = component.find("caseTypeInputSelect");
        let caseTypeOptions=[];
        action.setCallback(this, function(response) {
            let options = response.getReturnValue();
            for(var i=0;i< options.length;i++){
                caseTypeOptions.push({"class": "optionClass", label: options[i], value: options[i]});
            }
            caseTypeInputSelect.set("v.options", caseTypeOptions);
        });
        $A.enqueueAction(action);
    },
    loadCaseReasonOptions: function(component){
        let action = component.get("c.getCaseReasonPicklistValues");
        let caseReasonInputSelect = component.find("caseReasonInputSelect");
        let caseReasonOptions=[];
        action.setCallback(this, function(response) {
            let options = response.getReturnValue();
            for(var i=0;i< options.length;i++){
                caseReasonOptions.push({"class": "optionClass", label: options[i], value: options[i]});
            }
            caseReasonInputSelect.set("v.options", caseReasonOptions);
        });
        $A.enqueueAction(action);
    },
    loadCaseProductOptions: function(component){
        let action = component.get("c.getCustomerOwnedProducts");
        let caseProductInputSelect = component.find("caseProductInputSelect");
        let caseProductOptions=[];
        action.setCallback(this, function(response) {
            let options = response.getReturnValue();
            component.set("v.availableProducts", options);
            for(var i=0;i< options.length;i++){
                caseProductOptions.push({"class": "optionClass", label: options[i].Name+' - '+options[i].CD_VIN__c, value: options[i].Id});
            }
            caseProductInputSelect.set("v.options", caseProductOptions);
        });
        $A.enqueueAction(action);
    },
    createCase: function(component){
        let action = component.get('c.createCase');
        let newCase = component.get("v.newCase");

        action.setParams({
            newCase: newCase
        })

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let newCaseCreatedEvent = $A.get("e.c:CD_NewCaseCreated")
                newCaseCreatedEvent.fire();
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Error when creating case');
                }else{
                    resultsToast.setParams({
                        "type": "success",
                        "title": "Success",
                        "message": "Your case was created successfully"
                    });
                    resultsToast.fire();
                }
                component.find("createNewCaseModal").hide();
            }else{
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Error when creating case');
                }else{
                    resultsToast.setParams({
                        "type": "error",
                        "title": "Error",
                        "message": "Error when creating case"
                    });
                    resultsToast.fire();
                }
            }
        });
        $A.enqueueAction(action);
    }
})