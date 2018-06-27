
({
    loadActiveCases: function(component){
        let action = component.get('c.loadActiveCases');

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let activeCases = component.get("v.activeCases");
                activeCases = response.getReturnValue();
                component.set("v.activeCases", activeCases);
            }else{
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Error when loading active cases');
                }else{
                    resultsToast.setParams({
                        "type": "error",
                        "title": "Error",
                        "message": "Error when loading active cases"
                    });
                    resultsToast.fire();
                }
            }
        });
        $A.enqueueAction(action);
    },
})