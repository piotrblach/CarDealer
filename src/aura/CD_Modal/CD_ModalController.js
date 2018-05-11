/**
 * Created by BRITENET on 10.05.2018.
 */
({
	show : function(component, event, helper) {
		component.set("v.visible", true);
	},

	hide : function(component, event, helper) {
		component.set("v.visible", false);
//		$A.get("e.force:closeQuickAction").fire();
	},
	closeModal : function(component, event, helper) {
		component.set("v.visible", false);
//		$A.get("e.force:closeQuickAction").fire();
//		var closeModalEvent = component.getEvent("closeModalEvent");
//		closeModalEvent.fire();
	}
})