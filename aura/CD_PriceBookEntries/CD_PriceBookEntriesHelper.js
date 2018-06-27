
({
    loadPriceBookEntries: function(component){
        let action = component.get('c.loadPriceBookEntries');
        let priceBookId = component.get("v.priceBookId");
        action.setParams({
            priceBookId: priceBookId
        })

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let priceBookEntries = component.get("v.priceBookEntries");
                priceBookEntries = response.getReturnValue();
                component.set("v.priceBookEntries", priceBookEntries);
            }else{
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Error when loading price book items');
                }else{
                    resultsToast.setParams({
                        "type": "error",
                        "title": "Error",
                        "message": "Error when loading price book items"
                    });
                    resultsToast.fire();
                }
            }
        });
        $A.enqueueAction(action);
    },
    deletePriceBookEntry: function(component){
        let action = component.get('c.deletePriceBookEntry');
        let priceBookEntryId = component.get("v.priceBookEntryIdForAction");
        action.setParams({
            priceBookEntryId: priceBookEntryId
        })

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                this.loadPriceBookEntries(component);
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Price book entry deleted');
                }else{
                    resultsToast.setParams({
                        "type": "success",
                        "title": "Success",
                        "message": "Price book entry deleted"
                    });
                    resultsToast.fire();
                }
            }else{
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Error when deleting price book entry');
                }else{
                    resultsToast.setParams({
                        "type": "error",
                        "title": "Error",
                        "message": "Error when deleting price book entry"
                    });
                    resultsToast.fire();
                }
            }
        });
        $A.enqueueAction(action);
    },
    updatePriceBookEntry: function(component){
        let action = component.get('c.updatePriceBookEntry');
        let priceBookEntryId = component.get("v.priceBookEntryIdForAction");
        let priceBookEntryEditedPrice = component.get("v.priceBookEntryEditedPrice");
        action.setParams({
            priceBookEntryId: priceBookEntryId,
            priceBookEntryEditedPrice: priceBookEntryEditedPrice
        })

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                this.loadPriceBookEntries(component);
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Price book entry updated');
                }else{
                    resultsToast.setParams({
                        "type": "success",
                        "title": "Success",
                        "message": "Price book entry updated"
                    });
                    resultsToast.fire();
                }
            }else{
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Error when updating price book entry');
                }else{
                    resultsToast.setParams({
                        "type": "error",
                        "title": "Error",
                        "message": "Error when updating price book entry"
                    });
                    resultsToast.fire();
                }
            }
        });
        $A.enqueueAction(action);
    },
})