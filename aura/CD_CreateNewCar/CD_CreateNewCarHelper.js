
({
    initializeNewRecord: function(component){
        component.find("carCreator").getNewRecord(
            "Product2",
            null,
            false,
            $A.getCallback(function() {
                let rec = component.get("v.car");
                let error = component.get("v.recordError");
                if(error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                    let resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "type": "error",
                        "title": "Error",
                        "message": "Error initializing record template: " + error
                    });
                    resultsToast.fire();
                }
                else {
                    rec.fields.CD_IsSavingCompleted__c.value = false;
                    component.set("v.car", rec);
                }
            })
        );
        this.loadCarModelOptions(component);
    },
    loadCarModelOptions: function(component){
        let action = component.get("c.getCarModels");
        let carModelInputSelect = component.find("addCarModelInputSelect");
        let carModelOptions=[];
        action.setCallback(this, function(response) {
            let modelOptions = response.getReturnValue();
            for(var i=0;i< modelOptions.length;i++){
                carModelOptions.push({"class": "optionClass", label: modelOptions[i], value: modelOptions[i]});
            }
            carModelInputSelect.set("v.options", carModelOptions);
        });
        $A.enqueueAction(action);
    },
    validateNewCarForm: function(component) {
        var validCar = true;
        return(validCar);
	},
    createNewCar: function(component) {
        var helper = this;
        component.find("carCreator").saveRecord(function(saveResult) {
            let message;
            let title;
            let type;
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                helper.initializeNewRecord(component);
                component.set("v.carId", saveResult.recordId);
                component.find("recordRemover").reloadRecord(true);
                component.set("v.step", 'images');
            } else if (saveResult.state === "INCOMPLETE") {
                type = "error";
                title = 'Problem';
                message = "User is offline, device doesn't support drafts.";
            } else if (saveResult.state === "ERROR") {
                type = "error";
                title = 'Problem saving car';
                message = 'Problem saving car, error: ' + JSON.stringify(saveResult.error);
            } else {
                type = "error";
                title = 'Unknown problem';
                message = 'Unknown problem, state: ' + saveResult.state +', error: ' + JSON.stringify(saveResult.error);
            }
            if(message != null){
                let resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "type": type,
                    "title": title,
                    "message": message
                });
                resultsToast.fire();
            }
            component.find("loadingSpinner").hide();
        });
	},
    completeCarCreation: function(component) {
        component.find("recordRemover").saveRecord(function(saveResult) {
            let message;
            let title;
            let type;
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                type = "success";
                title =  "Saved";
                message = "The record was saved.";
            } else if (saveResult.state === "INCOMPLETE") {
                type = "error";
                title = 'Problem';
                message = "User is offline, device doesn't support drafts.";
            } else if (saveResult.state === "ERROR") {
                type = "error";
                title = 'Problem saving car';
                message = 'Problem saving car, error: ' + JSON.stringify(saveResult.error);
            } else {
                type = "error";
                title = 'Unknown problem';
                message = 'Unknown problem, state: ' + saveResult.state +', error: ' + JSON.stringify(saveResult.error);
            }
            let resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "type": type,
                "title": title,
                "message": message
            });
            resultsToast.fire();
            component.find("loadingSpinner").hide();
        });
	},
    setAsPrimaryImage: function(component, imageId, carId){
        let action = component.get('c.setImageAsPrimaryCarImage');

        action.setParams({
            imageId: imageId,
            carId: carId
        })

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let carClickedEvent = component.getEvent("CarClicked");
                carClickedEvent.setParams({
                    "carId": component.get("v.carId")
                });
                carClickedEvent.fire();
            }else{
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Error when setting primary image');
                }else{
                    resultsToast.setParams({
                        "type": "error",
                        "title": "Error",
                        "message": "IError when setting primary image"
                    });
                    resultsToast.fire();
                }
            }
        });
        $A.enqueueAction(action);
    },
})