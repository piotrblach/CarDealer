
({
    doInit: function(component, event, helper){
        helper.loadWaitingToAssign(component);
    },
    toggleSelected: function(component, event, helper){
        let selectedMeetingsIds = component.get("v.selectedMeetingsIds");
        let eventId = event.getSource().get("v.value");
        let checked = event.getSource().get("v.checked");
        if(!checked){
            for(var ii=0; ii<selectedMeetingsIds.length; ii++){
                if(selectedMeetingsIds[ii] == eventId){
                    selectedMeetingsIds.splice(ii, 1);
                    break;
                }
            }
        }else{
            selectedMeetingsIds.push(eventId);
        }
        component.set("v.selectedMeetingsIds", selectedMeetingsIds);
        console.log(selectedMeetingsIds)
    },
    openAssignMeetingModal: function(component, event, helper){
        helper.loadAvailableSalesReps(component);
        component.find("assignMeetingModal").show();
    },
    closeAssignMeetingModal: function(component, event){
        component.find("assignMeetingModal").hide();
    },
    assignMeetings: function(component, event, helper){
        helper.assignSelectedMeetings(component);
    },
})