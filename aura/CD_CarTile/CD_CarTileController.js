
({
    doInit: function(component, event, helper){
        helper.loadCarStandardPrice(component);
        helper.loadCarLowestPrice(component);
    },
    onCarClicked: function(component, event, helper){
        let envType = component.get("v.environmentType");
        if(envType === 'Community'){
            let urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
              "url": "/car-details/"+'?id='+component.get("v.carId")
            });
            urlEvent.fire();
        }else{
            let carClickedEvent = component.getEvent("CarClicked");
            let selectedCarId = component.get('v.carId');
            carClickedEvent.setParams({
                "carId": selectedCarId
            });
            carClickedEvent.fire();
        }
    },
    onDeleteCar: function(component, event, helper){
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
                message = 'Problem deleting record, error: ' +JSON.stringify(deleteResult.error);
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
        }));

        component.find("removalConfirmationModal").hide();
    },
    showRemovalConfirmation: function(component, event){
        component.find("removalConfirmationModal").show();
    },
    hideRemovalConfirmation: function(component, event){
        component.find("removalConfirmationModal").hide();
    },
    onCarUpdated: function(component, event){
        let carIdEvent = event.getParam("carId");
        let carId = component.get("v.carId");
        if(carId == carIdEvent){
            component.find('recordRemover').reloadRecord(true);
            component.set("v.showCarTile", false);
            component.set("v.showCarTile", true);
        }
    },
    addToCart: function(component, event, helper){
        let car = component.get("v.carToDisplay");
        helper.addToCart(component, car);
    }
})
