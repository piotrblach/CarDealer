({
    searchAutohouses: function(component, event, helper) {
        var searchedAutohouse = component.get("v.searchedAutohouse");
        helper.getAutohouses(component, searchedAutohouse);
        helper.showAutohouseDetails(component, '');
    },
    clearForm: function(component, event, helper) {
        var searchedAutohouse = component.get("v.searchedAutohouse");
        searchedAutohouse.Name = '';
        component.set("v.searchedAutohouse", searchedAutohouse);
    }  
})