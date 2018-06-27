
({
    loadSolvedCases: function(component){
        let action = component.get('c.loadSolvedCases');

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let solvedCases = component.get("v.solvedCases");
                solvedCases = response.getReturnValue();
                component.set("v.solvedCases", solvedCases);
            }else{
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Error when loading solved cases');
                }else{
                    resultsToast.setParams({
                        "type": "error",
                        "title": "Error",
                        "message": "Error when loading solved cases"
                    });
                    resultsToast.fire();
                }
            }
        });
        $A.enqueueAction(action);
    },
})