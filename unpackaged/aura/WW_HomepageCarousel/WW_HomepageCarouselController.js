({
    doInit: function(component, event, helper){
        var slideDuration = component.get("v.duration");
        var action = component.get("c.getImageDetails");
        action.setParams({
            "sFolderName" : component.get("v.sFolderName")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var lstRetVal = response.getReturnValue();
                console.log("Response: "+JSON.stringify(lstRetVal));
                component.set("v.orgBaseUrl", lstRetVal[0]);
                component.set("v.sOrgId", lstRetVal[1]);
                console.log('Org Id: '+ lstRetVal[1]);
                component.set("v.lstImageDetails", JSON.parse(lstRetVal[2]));
            }
        });
        $A.enqueueAction(action);
        helper.transformSlide(component, event, slideDuration);
    },
    
    goToLink : function(component, event, helper){
        var sUrl = event.getSource().get("v.name");
        helper.navigateToUrl(component, event, sUrl);
    },
    
    changeImage : function(component, event){
        var sourceClick = event.currentTarget.id;
        var translateValue = component.get("v.translateValue");
        var val=-100;
        var transValue = sourceClick*val;
        component.set("v.translateValue", transValue);
        component.set("v.transValue", "translateX("+transValue+"%)");
    }
})