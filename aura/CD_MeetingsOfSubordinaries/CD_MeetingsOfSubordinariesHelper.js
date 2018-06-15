
({
    loadAssignedMeetings: function(component){
        component.find("loadingSpinner").show();
        let action = component.get('c.loadAssignedToSubordinaries');

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let assignedMeetings = component.get("v.assignedMeetings");
                assignedMeetings = response.getReturnValue();
                component.set("v.assignedMeetings", assignedMeetings);
            }else{
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Error when loading meetings');
                }else{
                    resultsToast.setParams({
                        "type": "error",
                        "title": "Error",
                        "message": "Error when loading meetings"
                    });
                    resultsToast.fire();
                }
            }
        });
        $A.enqueueAction(action);
        component.find("loadingSpinner").hide();
    },
    changeAssignment: function(component){
        component.find("loadingSpinner").show();
        let eventId = [];
        eventId.push(component.get("v.meetingToChangeAssignmentId"));
        let selectedSalesRepId = component.get("v.selectedSalesRepId");
        let action = component.get('c.assignSelectedMeetingsToSalesReps');
        action.setParams({
            selectedMeetingsIds: eventId,
            selectedSalesRepId: selectedSalesRepId
        });

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                this.loadAssignedMeetings(component);
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Assignment was changed');
                }else{
                    resultsToast.setParams({
                        "type": "success",
                        "title": "Success",
                        "message": "Assignment was changed"
                    });
                    resultsToast.fire();
                }
            }else{
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Error when changing meeting assignment');
                }else{
                    resultsToast.setParams({
                        "type": "error",
                        "title": "Error",
                        "message": "Error when changing meeting assignment"
                    });
                    resultsToast.fire();
                }
            }
        });
        $A.enqueueAction(action);
        component.find("loadingSpinner").hide();
        component.find("assignMeetingModal").hide();
    },
    loadAvailableSalesReps: function(component){
        component.find("loadingSpinner").show();
        let action = component.get('c.loadAvailableSalesRepresentatives');

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let availableSalesReps = component.get("v.availableSalesReps");
                availableSalesReps = response.getReturnValue();
                component.set("v.availableSalesReps", availableSalesReps);
                if(availableSalesReps.length > 0){
                    component.set("v.selectedSalesRepId", availableSalesReps[0].Id);
                }
            }else{
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Error when loading sales reps');
                }else{
                    resultsToast.setParams({
                        "type": "error",
                        "title": "Error",
                        "message": "Error when sales reps"
                    });
                    resultsToast.fire();
                }
            }
        });
        $A.enqueueAction(action);
        component.find("loadingSpinner").hide();
    },
})