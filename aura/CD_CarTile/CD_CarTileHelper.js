
({
    addToCart: function(component, car){
        let action = component.get('c.addCarToUserCart');
        let carLowestPrice = component.get("v.carLowestPrice");
        let carStandardPrice = component.get("v.carStandardPrice");
        action.setParams({
            car: car,
            carLowestPrice: carLowestPrice,
            carStandardPrice: carStandardPrice
        })

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Item added to cart');
                }else{
                    resultsToast.setParams({
                        "type": "success",
                        "title": "Success",
                        "message": "Item added to cart"
                    });
                    resultsToast.fire();
                }
            }else{
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Error when adding cart item');
                }else{
                    resultsToast.setParams({
                        "type": "error",
                        "title": "Error",
                        "message": response.getError()[0].message
                    });
                    resultsToast.fire();
                }
            }
        });
        $A.enqueueAction(action);
    },
    loadCarStandardPrice: function(component){
        let action = component.get('c.getCarStandardPrice');

        action.setParams({
            carId: component.get("v.carId")
        })

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                component.set("v.carStandardPrice", response.getReturnValue());
            }else{
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Error when loading car price');
                }else{
                    resultsToast.setParams({
                        "type": "error",
                        "title": "Error",
                        "message": response.getError()[0].message
                    });
                    resultsToast.fire();
                }
            }
        });
        $A.enqueueAction(action);
    },
    loadCarLowestPrice: function(component){
        let action = component.get('c.getCarLowestPrice');

        action.setParams({
            carId: component.get("v.carId")
        })

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let carLowestPrice = component.get("v.carLowestPrice");
                carLowestPrice = response.getReturnValue();
                component.set("v.carLowestPrice", carLowestPrice);
            }else{
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Error when loading car price');
                }else{
                    resultsToast.setParams({
                        "type": "error",
                        "title": "Error",
                        "message": response.getError()[0].message
                    });
                    resultsToast.fire();
                }
            }
        });
        $A.enqueueAction(action);
    }
})