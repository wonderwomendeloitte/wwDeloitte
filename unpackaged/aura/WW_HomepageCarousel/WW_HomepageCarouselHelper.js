({
    transformSlide : function(component, event, slideDuration) {
        setTimeout(function slide(){
            var translateValue = component.get("v.translateValue");
            var lstImageDetails = component.get("v.lstImageDetails");
            var val=-100;
            var transValue = translateValue+val;
            component.set("v.translateValue", transValue);
            component.set("v.transValue", "translateX("+transValue+"%)");
            if(translateValue === (-100*(lstImageDetails.length-1))){
                component.set("v.translateValue", 0);
                component.set("v.transValue", "translateX(0%)")
            }
            setTimeout(slide,slideDuration);
        },slideDuration);
    },
    
    navigateToUrl : function(component, event, sUrl){
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": sUrl
        });
        urlEvent.fire();
    }
})