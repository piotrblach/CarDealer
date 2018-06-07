
({
    onCarIdChanged: function(component, event, helper){
        let carId = component.get("v.carId");
        if(carId != null){
            component.find("carEditor").reloadRecord();
        }
    },
    recordUpdated: function(component, event, helper) {
        let changeType = event.getParams().changeType;

        switch(changeType){
            case "LOADED":
                if(!component.get("v.isRecordLoaded")){
                    component.set("v.isRecordLoaded", true);
                    helper.loadCarModelOptions(component);
                }
                break;
            case "CHANGED":
                component.find("carEditor").reloadRecord();
                break;
            default:
        }
    },
    handleUpdateRecord: function(component, event, helper) {
        component.find("loadingSpinner").show();
        component.find("carEditor").saveRecord($A.getCallback(function(saveResult) {
            let message;
            let type;
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                type = "success";
                message = "Save completed successfully.";
                component.set("v.visible", false);
            } else if (saveResult.state === "INCOMPLETE") {
                type = "error";
                message = "User is offline, device doesn't support drafts.";
            } else if (saveResult.state === "ERROR") {
                type = "error";
                message = 'Problem saving record, error: ' +
                           JSON.stringify(saveResult.error);
            } else {
                type = "error";
                message = 'Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error);
            }
            component.find("loadingSpinner").hide();
            let resultsToast = $A.get("e.force:showToast");
            if ($A.util.isUndefined(resultsToast)){
                alert(message);
            }else{
                resultsToast.setParams({
                    "type": type,
                    "title": "Info",
                    "message": message
                });
                resultsToast.fire();
            }
        }));
    },
    cancelUpdate: function(component, event, helper) {
        component.set("v.visible", false);
    },
})