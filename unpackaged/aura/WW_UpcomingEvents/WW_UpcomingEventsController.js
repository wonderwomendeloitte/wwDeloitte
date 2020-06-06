({
	doInit : function(component, event, helper) {
		var action  = component.get("c.getUpcomingEventDetails");
         action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var lstRetVal = response.getReturnValue();
                console.log("Response: "+JSON.stringify(lstRetVal));
                if(lstRetVal){
                    component.set("v.upcomingEvents", lstRetVal);
                }
            }
        });
        $A.enqueueAction(action);
	},
    
    registerPeople: function(component, event, handler){
        var val = event.currentTarget.getAttribute("data-id");
        component.set("v.selectedEventId", val);
        console.log("val: "+ val);
        component.set("v.bShowRegistrationModal", true);
    }
})