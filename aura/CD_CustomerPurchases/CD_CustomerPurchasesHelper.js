
({
    loadCustomerPurchases: function (component) {
        component.find("loadingSpinner").show();
        let action = component.get('c.loadCustomerPurchases');

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let customerPurchases = component.get("v.customerPurchases");
                customerPurchases = response.getReturnValue();
                component.set("v.customerPurchases", customerPurchases);
            }else{
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Error when loading purchases');
                }else{
                    resultsToast.setParams({
                        "type": "error",
                        "title": "Error",
                        "message": "Error when loading purchases"
                    });
                    resultsToast.fire();
                }
            }
        });
        $A.enqueueAction(action);
        component.find("loadingSpinner").hide();
    },
})