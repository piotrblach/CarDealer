
({
    loadCustomerCartItems: function (component, event, helper) {
        component.find("loadingSpinner").show();
        let action = component.get('c.getCustomerCartItems');

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let customerCartItems = component.get("v.customerCartItems");
                customerCartItems = response.getReturnValue();
                console.log(JSON.stringify(response.getReturnValue()));
                component.set("v.customerCartItems", customerCartItems);
            }else{
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Error when loading cart items');
                }else{
                    resultsToast.setParams({
                        "type": "error",
                        "title": "Error",
                        "message": "Error when loading cart items"
                    });
                    resultsToast.fire();
                }
            }
        });
        $A.enqueueAction(action);
        component.find("loadingSpinner").hide();
    },
    removeCartItem: function (component, carIdsToRemove) {
        let action = component.get('c.deleteCustomerCartItem');

        action.setParams({
            "carIdsToRemove": carIdsToRemove
        });

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                this.loadCustomerCartItems(component);

                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Item deleted from cart');
                }else{
                    resultsToast.setParams({
                        "type": "success",
                        "title": "Success",
                        "message": "Item deleted from cart"
                    });
                    resultsToast.fire();
                }
            }else{
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Error when deleting cart item');
                }else{
                    resultsToast.setParams({
                        "type": "error",
                        "title": "Error",
                        "message": "Error when deleting cart item"
                    });
                    resultsToast.fire();
                }
            }
        });
        $A.enqueueAction(action);
    },
    setMeetingDate: function (component, carIdsToSetMeeting, meetingDate) {
        let action = component.get('c.setCartItemMeetingDate');

        action.setParams({
            "carIdsToSetMeeting": carIdsToSetMeeting,
            "meetingDate": meetingDate
        });

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                this.loadCustomerCartItems(component);
                component.set("v.meetingDate", null);
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Item meeting date was set');
                }else{
                    resultsToast.setParams({
                        "type": "success",
                        "title": "Success",
                        "message": "Item meeting date was set"
                    });
                    resultsToast.fire();
                }
            }else{
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Error when setting meeting date');
                }else{
                    resultsToast.setParams({
                        "type": "error",
                        "title": "Error",
                        "message": "Error when setting meeting date"
                    });
                    resultsToast.fire();
                }
            }
        });
        $A.enqueueAction(action);
        component.find("meetingDatePicker").hide();
    },
    goToOffer: function (component, carId) {
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/car-details/"+'?id='+carId
        });
        urlEvent.fire();
    },
    validateCheckout: function (component) {
        let cartItems = component.get("v.customerCartItems");
        if(this.isCheckoutValid(component)){
            this.checkout(component);
        }else{
            let resultsToast = $A.get("e.force:showToast");
            if ($A.util.isUndefined(resultsToast)){
                alert('All items in cart must have meeting date assigned');
            }else{
                resultsToast.setParams({
                    "type": "error",
                    "title": "Error",
                    "message": "All items in cart must have meeting date assigned"
                });
                resultsToast.fire();
            }
        }
    },
    checkout: function (component) {
        let action = component.get('c.proceedToCheckout');

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                this.loadCustomerCartItems(component);
                component.set("v.meetingDate", null);
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Your items meeting requests were delivered to sales representatives');
                }else{
                    resultsToast.setParams({
                        "type": "success",
                        "title": "Success",
                        "message": "Your items meeting requests were delivered to sales representatives"
                    });
                    resultsToast.fire();
                }
            }else{
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Your items meeting requests couldnt be delivered to sales representatives');
                }else{
                    resultsToast.setParams({
                        "type": "error",
                        "title": "Error",
                        "message": "Your items meeting requests couldn't be delivered to sales representatives"
                    });
                    resultsToast.fire();
                }
            }
        });
        $A.enqueueAction(action);
        component.find("meetingDatePicker").hide();
    },
    isCheckoutValid: function (component) {
        let cartItems = component.get("v.customerCartItems");
        var isValid = true;
        cartItems.forEach(function(cartItem){
            if(typeof cartItem.meetingDate == "undefined" || cartItem.meetingDate == null){
                isValid = false;
            }
        })
        return isValid;
    },
})