public class WW_EventsController {
	@auraEnabled
    public static List<WW_Event__c> getUpcomingEventDetails(){
        List<WW_Event__c> lstUpcomingEvents = new List<WW_Event__c>();
        lstUpcomingEvents = [Select id, name, WW_Event_Date__c, Address_1__c, 
                             Address_2__c, Address_3__c, City__c, State__c 
                             From WW_Event__c where WW_Event_Date__c > TODAY];
        return lstUpcomingEvents;
    }
    
    @auraEnabled
    public static List<String> getAllEventDetails(){
        String volunteerId = '0014S000002fZ4pQAE';
        List<WW_EventDetails__c> lstEventDetails = [Select id, name, Event__c, Volunteer__c From 
                                                   WW_EventDetails__c Where Volunteer__c =: volunteerId];
        Set<String> idEventDetails = new Set<String>();
        List<WW_Event__c> lstRegisteredEvents;
        List<WW_Event__c> lstUpcomingEvents = getUpcomingEventDetails();
        List<String> retVal = new List<String>();
        if(lstEventDetails != null && !lstEventDetails.isEmpty()){
            for(WW_EventDetails__c eventDetail : lstEventDetails){
                idEventDetails.add(eventDetail.Event__c);
            }
            lstRegisteredEvents = [Select id, name, WW_Event_Date__c, Address_1__c, 
                             Address_2__c, Address_3__c, City__c, State__c 
                             From WW_Event__c where id IN: idEventDetails];
        }
        retVal.add(JSON.serialize(lstUpcomingEvents));
        retVal.add(JSON.serialize(lstRegisteredEvents));
        return retVal;
    }
}