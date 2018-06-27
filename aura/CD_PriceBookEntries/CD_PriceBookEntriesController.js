
({
    priceBookIdChanged: function(component, event, helper){
        helper.loadPriceBookEntries(component);
    },
    doInit: function(component, event, helper){
        helper.loadPriceBookEntries(component);
    },
    goToProductPage: function (component, event, helper) {
        let carId = event.getSource().get("v.value");
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/lightning/n/Car_Details?id="+carId
        });
        urlEvent.fire();
    },
    showRemovalConfirmation: function(component, event){
        component.set("v.priceBookEntryIdForAction", event.getSource().get("v.value"));
        component.find("removalConfirmationModal").show();
    },
    hideRemovalConfirmation: function(component, event){
        component.find("removalConfirmationModal").hide();
    },
    showPriceBookEntryPriceUpdateModal: function(component, event){
        let index = event.getSource().get("v.value");
        let priceBookEntries = component.get("v.priceBookEntries");
        component.set("v.priceBookEntryIdForAction", priceBookEntries[index].priceBookEntry.Id);
        component.set("v.priceBookEntryEditedPrice", priceBookEntries[index].priceBookEntry.UnitPrice);
        component.find("priceBookEntryPriceEditModal").show();
    },
    hidePriceBookEntryPriceUpdateModal: function(component, event){
        component.find("priceBookEntryPriceEditModal").hide();
    },
    onDeletePriceBookEntry: function(component, event, helper){
        helper.deletePriceBookEntry(component);
        component.find("removalConfirmationModal").hide();
    },
    onUpdatePriceBookEntry: function(component, event, helper){
        helper.updatePriceBookEntry(component);
        component.find("priceBookEntryPriceEditModal").hide();
    },
    onShowAddCarsToDiscountModal: function(component, event, helper){
        component.set("v.displayAddCarsToDiscountModal", true);
    },
    onNewPriceBookEntryCreated: function(component, event, helper){
        helper.loadPriceBookEntries(component);
    },
})