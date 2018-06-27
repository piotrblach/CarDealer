
({
    doInit: function(component, event, helper){
        if(component.get("v.orderId") != null){
            helper.loadOrderProducts(component);
        }
    },
    orderIdChanged: function(component, event, helper){
        helper.loadOrderProducts(component);
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