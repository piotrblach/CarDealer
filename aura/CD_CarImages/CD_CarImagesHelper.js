
({
    loadCarImages: function(component){
        component.find("loadingSpinner").show();
        let carId = component.get("v.carId");
        if(carId != null){
            let action = component.get('c.getCarImages');

            action.setParams({
                carId: carId
            })

            action.setCallback(this, function(response){
                let state = response.getState();
                if (state === "SUCCESS")
                {
                    let images = response.getReturnValue();
                    component.set("v.images", images);
                    component.find("recordImages").reloadRecord(true);
                }else{
                    let resultsToast = $A.get("e.force:showToast");
                    if ($A.util.isUndefined(resultsToast)){
                        alert('Error when loading car images');
                    }else{
                        resultsToast.setParams({
                            "type": "error",
                            "title": "Error",
                            "message": "Error when loading car images"
                        });
                        resultsToast.fire();
                    }
                }
                component.find("loadingSpinner").hide();
            });
            $A.enqueueAction(action);
        }
    },
    setAsPrimaryImage: function(component, imageId, carId){
        component.find("loadingSpinner").show();
        let action = component.get('c.setImageAsPrimaryCarImage');

        action.setParams({
            imageId: imageId,
            carId: carId
        })

        action.setCallback(this, function(response){
            let state = response.getState();
            let message;
            let title;
            let type;

            if (state === "SUCCESS")
            {
                component.find('recordImages').reloadRecord(true);
                let carUpdatedEvent = $A.get("e.c:CD_CarUpdated");
                carUpdatedEvent.setParams({
                    "carId" : carId
                });
                carUpdatedEvent.fire();
                message = "Image set as primary";
                title = "Success";
                type = "success";
                component.set("v.visible", true);
                component.set("v.visible", false);
            }else{
                message = "Image couldn't be set as primary";
                title = "Error";
                type = "error";
            }
            let resultsToast = $A.get("e.force:showToast");
            if ($A.util.isUndefined(resultsToast)){
                alert(message);
            }else{
                resultsToast.setParams({
                    "type": type,
                    "title": title,
                    "message": message
                });
                resultsToast.fire();
            }
            component.find("loadingSpinner").hide();
        });
        $A.enqueueAction(action);
    },
    deleteCarImage: function(component, imageId){
        component.find("loadingSpinner").show();
        let action = component.get('c.removeCarImage');

        action.setParams({
            imageId: imageId,
        })

        action.setCallback(this, function(response){
            let state = response.getState();
            let message;
            let title;
            let type;

            if (state === "SUCCESS")
            {
                this.loadCarImages(component);
                message = "Image deleted";
                title = "Success";
                type = "success";
            }else{
                message = "Image couldn't be deleted";
                title = "Error";
                type = "error";
            }
            let resultsToast = $A.get("e.force:showToast");
            if ($A.util.isUndefined(resultsToast)){
                alert(message);
            }else{
                resultsToast.setParams({
                    "type": type,
                    "title": title,
                    "message": message
                });
                resultsToast.fire();
            }
            component.find("loadingSpinner").hide();
        });
        $A.enqueueAction(action);
    },
})