/**
 * Created by BRITENET on 14.05.2018.
 */
({
	show : function(component, event, helper) {
		component.set("v.visible", true);
	},
	hide : function(component, event, helper) {
		component.set("v.visible", false);
	}
})