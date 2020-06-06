public class WW_HomePageController {
    
    @AuraEnabled
    public static void createAccount(String vFName, String vEmail){
        Id recordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Volunteer').getRecordTypeId();
        Account acc = new Account();
        acc.Name = vFName;
        acc.WW_Email__c = vEmail;
        acc.RecordTypeId = recordTypeId;
        acc.WW_Send_Code__c = true;
        insert acc;
        
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.Email = vEmail;
        con.LastName = vFName;
        con.WW_ConSend_Code__c = true;
        insert con;
        
        
    }
    
    @AuraEnabled 
    public static void registerPeople(Account accObj, List<Contact> contactsList, String eventId){
        Id recordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Account acc = new Account();
        acc.Name = accObj.Name;
        acc.RecordTypeId = recordTypeId;
        acc.WW_Email__c = accObj.WW_Email__c;
        acc.WW_Number_of_People__c = accObj.WW_Number_of_People__c;
        insert acc;        
        Id parentAccId = acc.Id;   
        List<Contact> peopleList = new List<Contact>();
        for(Contact c: contactsList){
            Contact peopleC = new Contact();
            peopleC.LastName = c.LastName;
            peopleC.WW_Age__c = c.WW_Age__c;
            peopleC.Phone= c.Phone;
            peopleC.AccountId = parentAccId;
            peopleList.add(peopleC);
        }
        insert peopleList;
        WW_EventDetails__c objEventDetail = new WW_EventDetails__c();
        objEventDetail.Event__c = eventId;
        objEventDetail.Volunteer__c = parentAccId;
        insert objEventDetail;
    }
    
    @AuraEnabled
    public static String login(String username, String otp) {
        // String userName = vEmail;
        Account accObj = [SELECT Id,WW_Verification_Code__c, WW_Email__c 
                          FROM Account WHERE WW_Email__c =: username LIMIT 1];
        system.debug('AccObj: '+accObj);
        String volId;
        /* User u = new User();
u.Username = userName;
u.Email = username;
u.FirstName = username;
u.LastName = username;
u.EmailEncodingKey = 'UTF-8';

insert u;
String userId;
try{
// userId = Site.createExternalUser(u, accObj.Id, 'June@2020');
}
catch(Site.ExternalUserCreateException ex) {
List<String> errors = ex.getDisplayMessages();
for (String error : errors)  {
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
}
}*/
        
        if(otp.equals(accObj.WW_Verification_Code__c)) {
            
            volId = accObj.Id;
            
        }
        
        
        return 'success';
    }
}