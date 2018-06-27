
({
    loadCars: function(component, searchParams){
        component.find("loadingSpinner").show();
        let priceBookId = component.get("v.priceBookId");
        let action = component.get('c.getCarsWithStandardPriceAndNotInPriceBookBySearchParams');
        action.setParams({
            searchedCar: searchParams,
            priceBookId: priceBookId
        })

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let cars = response.getReturnValue();
                console.log(cars)
                component.set("v.cars", cars);
            }else{
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Error when loading cars');
                }else{
                    resultsToast.setParams({
                        "title": "Error",
                        "message": "Error when loading cars"
                    });
                    resultsToast.fire();
                }
            }
            component.find("loadingSpinner").hide();

        });
        $A.enqueueAction(action);
    },
    addCarsToDiscount: function(component){
        component.find("loadingSpinner").show();
        let carIds = component.get("v.selectedCarsIds");
        let cars = component.get("v.cars");
        let discountItems =[];
        carIds.forEach(function(carId){
            cars.forEach(function(car){
                if(car.car.Id == carId && typeof(car.newDiscountPrice) !== 'undefined'){
                    discountItems.push({
                        carId: carId,
                        discountPrice: car.newDiscountPrice
                    })
                }
            })
        })
        let priceBookId = component.get("v.priceBookId");
        let action = component.get('c.addCarsToPriceBook');
        action.setParams({
            priceBookId: priceBookId,
            discountItems: JSON.stringify(discountItems)
        })

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                component.set("v.displayModal", false);
                let newPriceBookEntryCreated = component.getEvent("NewPriceBookEntryCreated");
                newPriceBookEntryCreated.fire();
                component.set("v.cars", []);
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Car added to discount');
                }else{
                    resultsToast.setParams({
                        "type": "success",
                        "title": "Success",
                        "message": "Car added to discount"
                    });
                    resultsToast.fire();
                }
            }else{
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Error when loading cars');
                }else{
                    resultsToast.setParams({
                        "title": "Error",
                        "message": "Error when loading cars"
                    });
                    resultsToast.fire();
                }
            }
            component.find("loadingSpinner").hide();

        });
        $A.enqueueAction(action);
    }
})