
({
    loadCars: function(component, searchParams){
        component.find("loadingSpinner").show();

        let action = component.get('c.getCarsBySearchParams');
        action.setParams({
            searchedCar: searchParams
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
    }
})