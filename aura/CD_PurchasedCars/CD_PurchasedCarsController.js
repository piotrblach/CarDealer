
({
    doInit: function(component, event, helper){
        helper.loadOrders(component);
    },
    orderClicked: function(component, event, helper){
        let orderId = event.currentTarget.dataset.orderid;
        component.set("v.displayDetailSection", true);
        component.set("v.selectedOrderId", orderId);
    },
})