
({
    onCarIdChanged: function(component, event, helper){
        helper.loadCarImages(component);
    },
    handleAfterUpload: function(component, event, helper){
        let resultsToast = $A.get("e.force:showToast");
        if ($A.util.isUndefined(resultsToast)){
            alert('Images uploaded');
        }else{
            resultsToast.setParams({
                "type": "success",
                "title": "Success",
                "message": "Images uploaded"
            });
            resultsToast.fire();
        }
        helper.loadCarImages(component);
    },
    setAsPrimaryCarImage : function(component, event, helper){
        let imageId = event.getSource().get("v.value");
        let carId = component.get("v.carId");
        helper.setAsPrimaryImage(component, imageId, carId);
    },
    deleteImage : function(component, event, helper){
        let imageId = event.getSource().get("v.value");
        helper.deleteCarImage(component, imageId);
    }
})