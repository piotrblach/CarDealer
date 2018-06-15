
({
    init: function (component, event, helper) {
        helper.loadCustomerCartItems(component);
        let meetingDate = new Date();
        component.set("v.meetingDate", meetingDate.toISOString());
    },
    deleteCartItem: function (component, event, helper) {
        let carIdsToRemove = [];
        let customerCartItems = component.get("v.customerCartItems");
        customerCartItems.forEach(function(cartItem){
            if(typeof cartItem.selected != "undefined" && cartItem.selected == true){
                carIdsToRemove.push(cartItem.car.Id);
            }
        })
        if(carIdsToRemove.length == 0){
            carIdsToRemove.push(event.getSource().get("v.value"));
        }
        helper.removeCartItem(component, carIdsToRemove);
    },
    redirectToOffer: function (component, event, helper) {
        let carId = event.getSource().get("v.value");
        helper.goToOffer(component, carId);
    },
    openSetMeetingDateModal: function(component, event){
        component.set("v.meetingDatePickerVisible", false);
        component.set("v.meetingDatePickerVisible", true);

        let carId = event.getSource().get("v.value");
        component.set("v.carIdToSetMeetingDate", carId);
        component.find("meetingDatePicker").show();
    },
    closeSetMeetingDateModal: function(component, event){
        component.find("meetingDatePicker").hide();
    },
    saveMeetingDate: function(component, event, helper){
        let carIdsToSetMeeting = [];
        let customerCartItems = component.get("v.customerCartItems");
        customerCartItems.forEach(function(cartItem){
            if(typeof cartItem.selected != "undefined" && cartItem.selected == true){
                carIdsToSetMeeting.push(cartItem.car.Id);
            }
        })
        if(carIdsToSetMeeting.length == 0){
            carIdsToSetMeeting.push(component.get("v.carIdToSetMeetingDate"));
        }
        let meetingDate = component.get("v.meetingDate");
        helper.setMeetingDate(component, carIdsToSetMeeting, meetingDate);
    },
    onCheckout: function(component, event, helper){
        helper.validateCheckout(component);
    },
})