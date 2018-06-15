
({
    init: function (component, event, helper) {
        helper.loadCustomerPurchases(component);
    },
    goToProductPage: function (component, event, helper) {
        let carId = event.currentTarget.dataset.carid;
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/car-details/"+'?id='+carId
        });
        urlEvent.fire();
    },
})