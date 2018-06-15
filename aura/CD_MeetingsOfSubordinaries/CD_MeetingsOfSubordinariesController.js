
({
    doInit: function(component, event, helper){
        helper.loadAssignedMeetings(component);
    },
    onChangeAssignment: function(component, event, helper){
        helper.changeAssignment(component);
    },
    openChangeAssignmentModal: function(component, event, helper){
        let eventId = event.getSource().get("v.value");
        component.set("v.meetingToChangeAssignmentId", eventId);
        helper.loadAvailableSalesReps(component);
        component.find("assignMeetingModal").show();
    },
    closeChangeAssignmentModal: function(component, event){
        component.find("assignMeetingModal").hide();
    },
})