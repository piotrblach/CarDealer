
({
	show : function(component, event, helper) {
		component.set("v.visible", true);
	},

	hide : function(component, event, helper) {
		component.set("v.visible", false);
	},
	closeModal : function(component, event, helper) {
		component.set("v.visible", false);
	}
})