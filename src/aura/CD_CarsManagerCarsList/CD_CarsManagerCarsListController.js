/**
 * Created by BRITENET on 09.05.2018.
 */
({
    searchCars: function(component, event, helper) {
        var searchedCar = component.get("v.searchedCar");
        console.log('111 ',searchedCar)
        helper.getCars(component, searchedCar);
    },
    editCar: function(component, event, helper) {
        let id = event.getSource().get("v.value");
    },
    openEditCarModal: function(component, event, helper) {
        let id = event.getSource().get("v.value");
        let carId = component.get("v.editedCarId");

        console.log('id ',id)
        console.log('id attr ', carId);
        carId = id;
        console.log('id attr ', carId);

        component.set("v.editedCarId", carId);
        component.find("editCarModal").show();
    },
    deleteCar: function(component, event, helper) {
        console.log('deleteCar ',event.getSource().get("v.value"))
        helper.deleteCar(component, event.getSource().get("v.value"));
    },
    openCreateCarModal: function(component, event, helper) {
        component.find("createModal").show();
    },
    createCar: function(component, event, helper) {
        let newCar = component.get("v.newCar");
        helper.createCar(component, newCar);
    },
    clearForm: function(component, event, helper) {
        var searchedCar = component.get("v.searchedCar");
        searchedCar.Name = '';
        searchedCar.CD_VIN__c = '';
        searchedCar.CD_Model__c = '';
        searchedCar.CD_Year__c = '';
        component.set("v.searchedCar", searchedCar);
    },
    clearCreateCarForm: function(component, event, helper) {
        var searchedCar = component.get("v.searchedCar");
        searchedCar.Name = '';
        searchedCar.CD_VIN__c = '';
        searchedCar.CD_Model__c = '';
        searchedCar.CD_Year__c = '';
        component.set("v.searchedCar", searchedCar);
    },
    cancelCarCreation: function(component, event, helper) {
        component.find("createModal").hide();
    },
    carCreationSuccessCallback: function(component, event, helper) {
        var searchedCar = component.get("v.searchedCar");
        console.log('created')
        helper.getCars(component, searchedCar);
        component.find("createModal").hide();
    },
    carCreationErrorCallback: function(component, event, helper) {
//        var searchedCar = component.get("v.searchedCar");
        console.log('error ')
        var payload = event.getParam("error");
        console.log(payload);
//        helper.getCars(component, searchedCar);
        component.find("createModal").hide();
    }
})