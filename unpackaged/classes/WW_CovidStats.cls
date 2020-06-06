public class WW_CovidStats {
    
    @AuraEnabled
    public static wrapperClass getCovidStats(){
           wrapperClass returnwrapperClass = new  wrapperClass (); 
        WW_CovidWrapper wrapperL;
        try {
            Http h = new Http();
            HttpRequest webReq = new HttpRequest();
            webReq.setMethod('GET');
            webReq.setEndpoint('https://corona-virus-stats.herokuapp.com/api/v1/cases/countries-search');			
            System.debug('Hitting the API');
            HttpResponse res;
            String strResponse;
            if(!Test.isRunningTest()){
                res = h.send(webReq);
                strResponse = res.getbody();
            }else{
                
            }
            wrapperL = (WW_CovidWrapper) JSON.deserialize(strResponse, WW_CovidWrapper.CLASS);
            system.debug('wrapD'+wrapperL.data.rows);
                
        returnwrapperClass.lstContact  = [SELECT firstName, LastName, Department,LeadSource from contact Limit 25];
        } catch(Exception excep) {
            
            
        }
        return  returnwrapperClass;
    }
     public class wrapperClass{
        @AuraEnabled public List<contact> lstContact{get;set;}
     }
}