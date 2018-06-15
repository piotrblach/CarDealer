
({
    goToCart: function(component, event){
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/my-cart/"+id
        });
        urlEvent.fire();
    }
})