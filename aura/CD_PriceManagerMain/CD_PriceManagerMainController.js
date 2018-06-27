
({
    showDiscountCreationModal: function(component, event){
        component.find("discountCreationComponent").showCreateNewPriceBookForm();
    },
    hideDiscountCreationModal: function(component, event){
        component.find("createNewPricebookModal").hide();
    },
    hideDetailsSectionAction: function(component, event){
        component.set("v.displayDetailSection", false);
    },
    onPriceBookListItemClicked: function(component, event){
        let priceBookId = event.getParam("priceBookId");
        component.set("v.clickedPriceBookId", priceBookId);
        component.set("v.displayDetailSection", true);
    },
    showAddCarsToDiscountModal: function(component, event){
        component.find("addPriceBookItemsModal").showAddCarsToDiscountModal();
    },
})