
({
    loadWaitingToAssign: function(component){
        component.find("loadingSpinner").show();
        let action = component.get('c.loadMeetingsWaitingToAssign');

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let meetingsToAssign = component.get("v.meetingsToAssign");
                meetingsToAssign = response.getReturnValue();
                component.set("v.meetingsToAssign", meetingsToAssign);
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
    assignSelectedMeetings: function(component){
        component.find("loadingSpinner").show();
        let action = component.get('c.assignSelectedMeetingsToSalesReps');
        action.setParams({
            "selectedMeetingsIds": component.get("v.selectedMeetingsIds"),
            "selectedSalesRepId": component.get("v.selectedSalesRepId")
        })
        console.log(component.get("v.selectedMeetingsIds"),'salesRepId: ', component.get("v.selectedSalesRepId"))
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let availableSalesReps = component.get("v.availableSalesReps");
                availableSalesReps = response.getReturnValue();
                component.set("v.availableSalesReps", availableSalesReps);
                this.loadWaitingToAssign(component);
                let selectedMeetingsIds = component.get("v.selectedMeetingsIds");
                selectedMeetingsIds =[];
                component.set("v.selectedMeetingsIds", selectedMeetingsIds);
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Meetings assignes successfully');
                }else{
                    resultsToast.setParams({
                        "type": "success",
                        "title": "Success",
                        "message": "Meetings assignes successfully"
                    });
                    resultsToast.fire();
                }
            }else{
                let resultsToast = $A.get("e.force:showToast");
                if ($A.util.isUndefined(resultsToast)){
                    alert('Error when assigning meetings');
                }else{
                    resultsToast.setParams({
                        "type": "error",
                        "title": "Error",
                        "message": "Error when assigning meetings"
                    });
                    resultsToast.fire();
                }
            }
        });
        $A.enqueueAction(action);
        component.find("assignMeetingModal").hide();
        component.find("loadingSpinner").hide();
    }
})