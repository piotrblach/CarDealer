/**
 * Created by BRITENET on 25.04.2018.
 */
({
    getAutohouses: function(component, searchedAutohouse) {
        var action = component.get("c.getAutohousesList");
        action.setParams({
            "searchedAutohouse": searchedAutohouse
        });

        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.foundAutohouses", response.getReturnValue());

                window.setTimeout($A.getCallback(function() {
                    var event = $A.get("e.c:AutohousesLoaded");
                    event.setParams({"autohouses": response.getReturnValue()});
                    event.fire();
                }), 500);
            }
        });
        $A.enqueueAction(action);
    }, 
    showAutohouseDetails: function(component, autohouseId) {
        let eventShowDetails = $A.get("e.c:CD_AutohouseSelectedOnList");
        eventShowDetails.setParams({"autohouseId": autohouseId});
        eventShowDetails.fire();
    },
    removeHighlightFromAllRows: function() {
        console.log('remove helper form')
        let removeHighlightFromAllRowsEvt = $A.get("e.c:CD_RemoveHighlightFromAllRowsEvent");
        removeHighlightFromAllRowsEvt.fire();
    }
})