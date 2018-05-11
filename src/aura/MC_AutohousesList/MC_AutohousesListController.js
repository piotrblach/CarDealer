({
    tableRowClicked: function(component, event, helper) {
        let autohouseId = event.currentTarget.dataset.id;
        let index = event.currentTarget.dataset.index;
        let selectedRowIndex = component.get("v.selectedRowIndex");

        if(!$A.util.isUndefinedOrNull(selectedRowIndex)){
            helper.removeHighlightFromAllRows(component);
        }
        let rows = component.find("row")
        $A.util.addClass(rows[index], "row-highlighted");
        component.set("v.selectedRowIndex", index);

        helper.showAutohouseLocalizationOnMap(component, index);
        helper.showAutohouseDetails(component, autohouseId);
    },
    removeHighlightFromAllRowsEventAction: function(component, event, helper) {
        console.log('remove list controler');
        helper.removeHighlightFromAllRows(component);
    }
})