({
    doInit: function(component, event, helper){
        var objAccount = {};
        objAccount.name = "";
        objAccount.noOfPeople = 0;
        objAccount.accEmail = "";
        component.set("v.objAccount", objAccount);
    },
    
    openVolunteerModal : function(component, event, helper) {
        component.set("v.bShowVolunteerModal", true);
    },
    
    openRegistrationModal : function(component, event, helper){
        component.set("v.bShowRegistrationModal", true);
    },
    
    closeModal : function(component, event, helper){
        var source = event.getSource().getLocalId();
        if (source === "volunteer"){
            component.set("v.bShowVolunteerModal", false);
        }
        else if (source === "registration"){
            component.set("v.bShowRegistrationModal", false);
        }
            else{
                component.set("v.showErrorSuccess", false);
            }
    },
    disableButton: function(component, event){
        var val = event.getSource().get("v.value");
        if(component.get("v.lstContacts").length == val){
            component.set("v.bDisableButton", true)
        }
        else{
            component.set("v.bDisableButton", false);
        }
    },
    
    addRow: function(component, event, helper){
        var numberOfPeople = component.get("v.objAccount.noOfPeople");
        var lstContact = component.get("v.lstContacts");
        var objContact = {};
        objContact.firstName = "";
        objContact.lastName = "";
        objContact.age = 0;
        lstContact.push(objContact);
        component.set("v.lstContacts", lstContact);
        if(lstContact.length == numberOfPeople){
            component.set("v.bDisableButton", true)
        }
        else{
            component.set("v.bDisableButton", false);
        }
    },
    
    saveRegistrationData: function(component, event, helper){
        var acc = component.get("v.objAccount");
        var con = component.get("v.lstContacts");
        var action=component.get('c.registerPeople');
        action.setParams({
            accObj : acc,
            contactsList : con,
            eventId: component.get("v.selectedEventId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                component.set("v.bShowRegistrationModal", false);
                component.set("v.showErrorSuccess", true);
                component.set("v.state", "success");
                component.set("v.stateMsg", "Registration successful.");
            }
            else{
                component.set("v.bShowRegistrationModal", false)
                component.set("v.showErrorSuccess", true);
                component.set("v.state", "error");
                component.set("v.stateMsg", "Please try later. Sorry for the Inconvenience");
            }
        });
        $A.enqueueAction(action);
    },
    
    requestForOtp : function(component, event, helper){
        var name = component.get('v.volunteerName');
        var email = component.get('v.volunteerEmail');
        var action=component.get('c.createAccount');
        action.setParams({
            vFName : name ,
            vEmail :  email
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                component.set("v.showErrorSuccess", true);
                component.set("v.state", "success");
                component.set("v.stateMsg", "OTP has been sent to your email address.");
            }
        });
        $A.enqueueAction(action);
    },
    userLogin: function(component, event, helper){
        var accEmail = component.get("v.volunteerEmail");
        var otp = component.get("v.otp");
        var action=component.get('c.login');
        action.setParams({
            username:accEmail,  
            otp: otp  
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.showErrorSuccess", true);
                component.set("v.state", "success");
                component.set("v.stateMsg", "OTP Verified.");
                window.location = 'https://ww-deloitte-developer-edition.na135.force.com/WW_VolunteerPage?isdtp=vw';
            }
            else{
                console.log("Error: "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
})