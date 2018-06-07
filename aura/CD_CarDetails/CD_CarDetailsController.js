
({
    onCarIdChanged: function(component, event, helper){
        component.set("v.selectedTabId", 'carDetailTab')
    },
    onCarRemoved: function(component, event, helper){
        component.set("v.carId", null);
        component.set("v.selectedTabId", 'addNewCarTab');
    },
})