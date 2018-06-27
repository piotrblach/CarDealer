
({
    loadOrderProducts: function(component){
        let action = component.get('c.loadOrderProducts');
        let orderId = component.get("v.orderId");
        action.setParams({
           orderId: orderId
        });

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let orderProducts = component.get("v.orderProducts");
                orderProducts = response.getReturnValue();
                component.set("v.orderProducts", orderProducts);
            }else{
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Error when loading purchased cars');
                }else{
                    resultsToast.setParams({
                        "type": "error",
                        "title": "Error",
                        "message": "Error when loading purchased cars"
                    });
                    resultsToast.fire();
                }
            }
        });
        $A.enqueueAction(action);
    },
})