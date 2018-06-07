
({
    doInit: function(component, event, helper){
        helper.initializeNewRecord(component);
    },
    handleCreateRecord: function(component, event, helper) {
        component.find("loadingSpinner").show();
        if(helper.validateNewCarForm(component)) {
            helper.createNewCar(component);
        }
    },
    handleUploadFinished : function(component, event, helper){
        let uploadedFiles = event.getParam("files");
        let carId = component.get("v.carId");
        let rec = component.get("v.carToDelete");
        rec.fields.CD_IsSavingCompleted__c.value = true;
        component.set("v.carToDelete", rec);
        helper.completeCarCreation(component);
        helper.setAsPrimaryImage(component, uploadedFiles[0].documentId, carId);
        component.set("v.step", 'details');
    },
    cancelCarCreation: function(component, event, helper){
        component.find("recordRemover").deleteRecord($A.getCallback(function(deleteResult) {
            let message;
            let title;
            let type;

            if (deleteResult.state === "SUCCESS" || deleteResult.state === "DRAFT") {
                message = "Car deleted.";
                title = "Deleted";
                type = "success";
                let carRemovedEvent = $A.get("e.c:CD_CarRemovedEvent");
                let carId =  component.get("v.carId");
                carRemovedEvent.setParams({"carId": carId});
                carRemovedEvent.fire();
            }
            else if (deleteResult.state === "INCOMPLETE") {
                message = "User is offline, device doesn't support drafts.";
                title = "Error";
                type = "error";
            }
            else if (deleteResult.state === "ERROR") {
                message = 'Problem deleting record, error: ' + JSON.stringify(deleteResult.error);
                title = "Error";
                type = "error";
            }
            else {
                message = 'Unknown problem, state: ' + deleteResult.state + ', error: ' + JSON.stringify(deleteResult.error);
                title = "Error";
                type = "error";
            }
            let resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "type": type,
                "title": title,
                "message": message
            });
            resultsToast.fire();

            component.set("v.step", 'details');
        }));

    },
})