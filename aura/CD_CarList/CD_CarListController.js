
({
    doInit: function(component, event, helper){
        helper.loadCars(component, null);
    },
    searchCarsByParams: function(component, event, helper){
        let searchParams = event.getParams("searchParams");
        helper.loadCars(component, searchParams);
    },
    onCarRemoved: function(component, event, helper){
        let removedCarId = event.getParam("carId");
        let cars = component.get("v.cars");
        for(var ii=0; ii<cars.length; ii++){
            if(cars[ii].Id == removedCarId){
                cars.splice(ii, 1);
                component.set("v.cars", cars);
                break;
            }
        }
    },
    onSearchCarsFormSubmit: function(component, event, helper){
        let searchParams = event.getParam("searchParams");
        helper.loadCars(component, searchParams);
    },
})