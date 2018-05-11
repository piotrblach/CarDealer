/**
 * Created by BRITENET on 09.05.2018.
 */
({
    getCars: function(component, searchedCar) {
        var action = component.get("c.getCarsList");
        action.setParams({
            "searchedCar": searchedCar
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.cars", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    deleteCar: function(component, carToDelete) {
        var action = component.get("c.deleteCar");
        action.setParams({
            "carToDelete": carToDelete
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            let searchedCar = component.get("v.searchedCar");
            if (state === "SUCCESS") {
                getCars(component, searchedCar);
            }
        });
        $A.enqueueAction(action);
    },
    createCar: function(component, newCar) {
        var action = component.get("c.createCar");
        action.setParams({
            "newCar": newCar
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            let searchedCar = component.get("v.searchedCar");
            if (state === "SUCCESS") {
                this.getCars(component, searchedCar);
            }
        });
        $A.enqueueAction(action);
    },
})