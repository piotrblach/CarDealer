
({
    onSearchCarsFormSubmit: function(component, event, helper){
        let searchParams = event.getParam("searchParams");
        helper.loadCars(component, searchParams);
    },
    toggleSelected: function(component, event, helper){
        let selectedCarsIds = component.get("v.selectedCarsIds");
        let carId = event.getSource().get("v.value");
        let checked = event.getSource().get("v.checked");
        if(!checked){
            for(var ii=0; ii<selectedCarsIds.length; ii++){
                if(selectedCarsIds[ii] == carId){
                    selectedCarsIds.splice(ii, 1);
                    break;
                }
            }
        }else{
            selectedCarsIds.push(carId);
        }
        component.set("v.selectedCarsIds", selectedCarsIds);
        console.log(selectedCarsIds)
    },
    addSelectedCarsToDiscount: function(component, event, helper){
        helper.addCarsToDiscount(component);
    },
    hideAddCarsToDiscountModal: function(component, event, helper){
        component.set("v.displayModal", false);
        component.set("v.cars", []);
    },
})
