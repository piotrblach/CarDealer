
({
    doInit: function(component, event, helper){
        helper.loadCarModelOptions(component);
    },
    showCreateNewPriceBookForm: function(component, event){
        component.find("createNewPricebookModal").show();
    },
    hideDiscountCreationModal: function(component, event){
        component.find("createNewPricebookModal").hide();
    },
    onCreatePriceBook: function(component, event, helper){
        helper.createNewPriceBook(component);
    },
})