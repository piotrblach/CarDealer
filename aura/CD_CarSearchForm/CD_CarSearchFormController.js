
({
    doInit: function(component, event, helper){
        helper.loadCarModelOptions(component);
    },
    clearForm: function(component, event, helper){
        let searchedCar = component.get("v.searchedCar");
        searchedCar.Name = '';
        searchedCar.CD_VIN__c = '';
        searchedCar.CD_Model__c = '';
        searchedCar.CD_Year__c = '';
        component.set("v.searchedCar", searchedCar);
    },
    searchCars: function(component){
        let SearchCarsFormSubmitEvent = $A.get("e.c:CD_SearchCarsFormSubmitEvent");
        let searchedCar = component.get("v.searchedCar");
        SearchCarsFormSubmitEvent.setParams({'searchParams': searchedCar});
        SearchCarsFormSubmitEvent.fire();
    }
})