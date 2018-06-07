
({
    removeCar: function(component){
        component.find("carDetail").deleteRecord($A.getCallback(function(deleteResult) {
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
                component.set("v.carId", null);
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
            component.find("removalConfirmationModal").hide();
        }));
    }
})