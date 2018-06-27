
({
    loadCarModelOptions: function(component){
        let action = component.get("c.getCarModels");
        let carModelInputSelect = component.find("carModelInputSelect");
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
    createNewPriceBook: function(component, event, helper){
        component.find("loadingSpinner").show();
        let action = component.get('c.saveNewPriceBook');
        action.setParams({
            newPriceBookActiveStartDate: component.get("v.newPriceBookActiveStartDate"),
            newPriceBookActiveEndDate: component.get("v.newPriceBookActiveEndDate"),
            newPriceBookDiscountType: component.get("v.newPriceBookDiscountType"),
            newPriceBookDiscountValue: component.get("v.newPriceBookDiscountValue"),
            newPriceBookProductionStartDate: component.get("v.newPriceBookProductionStartDate"),
            newPriceBookProductionEndDate: component.get("v.newPriceBookProductionEndDate"),
            newPriceBookCarModel: component.get("v.newPriceBookCarModel"),
            newPriceBookName: component.get("v.newPriceBookName")
        })

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('New discount was created');
                }else{
                    resultsToast.setParams({
                        "type": "success",
                        "title": "Success",
                        "message": "New discount was created"
                    });
                    resultsToast.fire();
                }
                let newDiscountCreatedEvent = $A.get("e.c:CD_NewDiscountCreatedEvent");
                newDiscountCreatedEvent.fire();
                component.find("createNewPricebookModal").hide();
            }else{
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Error when loading cart items');
                }else{
                    resultsToast.setParams({
                        "type": "error",
                        "title": "Error",
                        "message": "Cannot create discount"
                    });
                    resultsToast.fire();
                }
            }
        });
        $A.enqueueAction(action);
        component.find("createNewPricebookModal").hide();
        component.find("loadingSpinner").hide();
    }
})