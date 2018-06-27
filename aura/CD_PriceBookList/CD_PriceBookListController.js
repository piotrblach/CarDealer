
({
    doInit: function(component, event, helper){
        helper.loadPriceBooks(component);
    },
    goToPriceBook: function(component, event){
        let priceBookId = event.getSource().get("v.value");
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/"+priceBookId
        });
        urlEvent.fire();
    },
    displayPriceBookEntries: function(component, event){
        let priceBookId = event.getSource().get("v.value");
        let priceBookClickedEvent = component.getEvent("PriceBookListItemClicked");
        priceBookClickedEvent.setParams({
            "priceBookId": priceBookId
        });
        priceBookClickedEvent.fire();
    },
    onNewDiscountCreatedAction: function(component, event, helper){
        helper.loadPriceBooks(component);
    },
    showRemovalConfirmation: function(component, event){
        let priceBookId =  event.getSource().get("v.value");
        component.set("v.priceBookIdForAction", priceBookId);
        component.find("removalConfirmationModal").show();
    },
    hideRemovalConfirmation: function(component, event){
        component.find("removalConfirmationModal").hide();
    },
    onDeletePriceBook: function(component, event, helper){
        helper.deletePriceBook(component);
        component.find("removalConfirmationModal").hide();
    },
})