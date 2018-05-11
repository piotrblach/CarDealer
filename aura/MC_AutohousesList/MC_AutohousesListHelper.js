({
    showAutohouseLocalizationOnMap: function(component, index) {
        let eventShowLocalization = $A.get("e.c:ShowAutohouseLocalizationEvent");
        let autohouse = component.get("v.autohouses")[index];
        eventShowLocalization.setParams({"autohouse": autohouse});
        eventShowLocalization.fire();
    },
    showAutohouseDetails: function(component, autohouseId) {
        let eventShowDetails = $A.get("e.c:CD_AutohouseSelectedOnList");
        eventShowDetails.setParams({"autohouseId": autohouseId});
        eventShowDetails.fire();
    },
    removeHighlightFromAllRows: function(component) {
        console.log('remove list helper');

        let rows = component.find("row")
        for(var ii=0; ii< rows.length; ii++){
            $A.util.removeClass(rows[ii], "row-highlighted");
        }
    }
})