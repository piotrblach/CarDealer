
({
    onCarIdChanged: function(component, event, helper){
        component.find("loadingSpinner").show();
        let envType = component.get("v.environmentType");
        if(envType === 'Community' || envType === 'Standalone'){
            let sPageURL = decodeURIComponent(window.location.search.substring(1));
            let carId = sPageURL.substring(3);
            component.set("v.carId", carId);
        }else{
            if(envType === 'CommunityStandardPage'){
                let sPageURL = decodeURIComponent(window.location.pathname);
                let tempPath = sPageURL.substring(0, sPageURL.lastIndexOf('/'));
                let carId = tempPath.substring(tempPath.lastIndexOf('/')+1);
                component.set("v.carId", carId);
            }
        }
        component.find("carDetail").reloadRecord();
        helper.loadCarStandardPrice(component)
        helper.loadCarLowestPrice(component)
        component.set("v.editorVisible", true);
        component.set("v.editorVisible", false);
        component.find("loadingSpinner").hide();
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