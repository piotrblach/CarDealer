
({
    onCarIdChanged: function(component, event, helper){
        let envType = component.get("v.environmentType");
        if(envType === 'Community'){
            let sPageURL = decodeURIComponent(window.location.search.substring(1));
            let carId = sPageURL.substring(3);
            component.set("v.carId", carId);
        }
        component.find("carDetail").reloadRecord();
        component.set("v.editorVisible", true);
        component.set("v.editorVisible", false);
    },
    setEditMode: function(component){
        component.set("v.editorVisible", true);
    },
    setViewMode: function(component){
        component.set("v.editorVisible", false);
    },
    onEditorVisibleChange: function(component){
        component.find("carDetail").reloadRecord(true);
    },
    deleteCar: function(component, event, helper){
        helper.removeCar(component);
    },
    showRemovalConfirmation: function(component, event){
        component.find("removalConfirmationModal").show();
    },
    hideRemovalConfirmation: function(component, event){
        component.find("removalConfirmationModal").hide();
    },


})