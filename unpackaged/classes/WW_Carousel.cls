public class WW_Carousel {
    @auraEnabled
    public static List<String> getImageDetails(String sFolderName){
        List<String> lstRetVal = new List<String>();
        String sfdcBaseURL = URL.getOrgDomainUrl().toExternalForm();
        String orgId = UserInfo.getOrganizationId();
        system.debug('baseurl: '+sfdcBaseURL);
        lstRetVal.add(sfdcBaseURL);
        lstRetVal.add(orgId);
        List<DocumentWrapper> lstDocWrapper = new List<DocumentWrapper>();
        List<Document> lstImages = [SELECT id, name, Description, Keywords FROM Document
                                    WHERE Folder.Name=: sFolderName];
        for( Document objDoc : lstImages){
            lstDocWrapper.add(new DocumentWrapper(objDoc));
        }
        lstRetVal.add(JSON.serialize(lstDocWrapper));
        return lstRetVal;
    }
    
    public class DocumentWrapper{
        @AuraEnabled
        public String sId;
        @AuraEnabled
        public String sName;
        @AuraEnabled
        public String sDescription;
        @AuraEnabled
        public String sLink;
        
        public DocumentWrapper(Document objDoc){
            this.sId = objDoc.id;
            this.sName = objDoc.Name;
            this.sDescription = objDoc.Description;
            this.sLink = objDoc.Keywords;
        }
    }
}