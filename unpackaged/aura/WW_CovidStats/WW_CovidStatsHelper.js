({
	getAccounts : function(component, event) {
         component.set('v.columns', [    
            {label: 'Operation', type: 'text'},
            {label: 'Application',  type: 'text'},
             {label: 'Status', type: 'text'},
               {label: 'LogLength', type: 'number'},
               {label: 'Request', type: 'text'},
               {label: 'StartTime', type: 'datetime'}        
        ]); 
        var action = component.get("c.getCovidStats");
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set('v.wrapperList', response.getReturnValue());
                console.log(component.get('v.wrapperList')); 
            }
        });
        $A.enqueueAction(action);
    }
})