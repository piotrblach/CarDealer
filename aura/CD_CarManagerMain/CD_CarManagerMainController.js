
({
    onCarClicked: function(component, event){
        let selectedCarId = event.getParam("carId");
        component.set("v.selectedCarId", selectedCarId);
    },
})