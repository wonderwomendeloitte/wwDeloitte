({
	doInit : function(component, event, helper) {
		var action = component.get("c.getAllEventDetails");
        action.setCallback(this, function(response){
           var state = response.getState();
            console.log("State:"+state);
            if(state === "SUCCESS"){
                console.log("Ret Val: "+response.getReturnValue());
                var retVal = response.getReturnValue();
                component.set("v.lstUpcomingEvents", JSON.parse(retVal[0]));
                component.set("v.lstRegisteredEvents", JSON.parse(retVal[1]));
            }
        });
        $A.enqueueAction(action);
	}
})