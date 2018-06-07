
({
    onCarIdChanged: function(component, event, helper){
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