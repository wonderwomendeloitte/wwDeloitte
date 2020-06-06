({
	 doInit: function (component) {
        var createRecordEvent = $A.get('e.force:createRecord');
        if ( createRecordEvent ) {
            createRecordEvent.setParams({
                'entityApiName': 'EventDetails__c',
                      });
            createRecordEvent.fire();
        } else {
            /* Create Record Event is not supported */
            alert("Account creation not supported");
        }
    }
})