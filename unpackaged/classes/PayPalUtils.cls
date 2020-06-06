/*
    Name        : PayPalUtils
    Author Name : Amit Singh
    Create Date : May 22, 2019
    Version No  : Initial version Created
    Description : Class is responsible for Preparing the Various API Request and Authentication Process
    
    **************************************** Modified Histrtory ****************************************************
    **SR.No******* Modified By *********** Modified Date ************* Version No ********* Description       ******
    ****************************************************************************************************************
    
    **  01 ******* Amit Singh  *********** May 22, 2019  ************* V 1.0      ********* Initial version Created* 
 
    ****************************************************************************************************************
*/
global with sharing class PayPalUtils{

    public static List<Paypal_API__mdt> apiDetails(){
    
        String env = System.Label.PayPal_Environment;
        
        List<Paypal_API__mdt> paypalCred = new List<Paypal_API__mdt>();
        paypalCred = [Select Id, MasterLabel, Client_ID__c, Client_Secret__c, 
                      Token_URL__c, grant_type__c, Content_Type__c, Method__c From Paypal_API__mdt
                          Where MasterLabel =:env Limit 1];
        return paypalCred;
        
    }
    
    public static void generateCredentials(){
    
        String env = System.Label.PayPal_Environment;
        
        List<Paypal_API__mdt> paypalCred = apiDetails();
                          
        If(paypalCred != null && paypalCred.size() > 0){
            
            String clientId     = paypalCred.get(0).Client_ID__c;
            String clientSecret = paypalCred.get(0).Client_Secret__c;
            String tokenURL     = paypalCred.get(0).Token_URL__c;
            String grantType    = paypalCred.get(0).grant_type__c;
            String contentType  = paypalCred.get(0).Content_Type__c;
            String method       = paypalCred.get(0).Method__c;
            
            /* Prepare Http Request to Get the Paypal Token Credentials */
            
            String dataToEncode = clientId+':'+clientSecret;
            Blob blobValue = Blob.valueOf(dataToEncode);
            String encodedData = EncodingUtil.base64Encode(blobValue);
            
            /*System.debug(' #### encodedData '+encodedData);*/
            
            String body = 'grant_type='+grantType;
            
            /* Prepare a Var for Error */
            String errorMessage = '';
            
            HttpRequest HttpReq = new HttpRequest();
            HttpResponse httpRes = new HttpResponse();
            
            HttpReq.setEndPoint(tokenURL);
            httpReq.setMethod(method);
            httpReq.setHeader('Authorization', 'Basic '+encodedData);
            httpReq.setHeader('Content-Type' ,  contentType);
            httpReq.setBody(body);
            httpReq.setTimeOut(120000);
            
            try{
                httpRes = (new Http()).send(httpReq);
                Integer statusCode = httpRes.getStatusCode();
                String responseBody = httpRes.getBody();
                if(statusCode == 200){
                    /*System.debug(' responseBody '+responseBody);*/
                    Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(responseBody);
                    String scope = (String)responseMap.get('scope');
                    String access_token = (String)responseMap.get('access_token');
                    String token_type = (String)responseMap.get('token_type');
                    String app_id = (String)responseMap.get('app_id');
                    Integer expires_in = (Integer)responseMap.get('expires_in');
                    String nonce = (String)responseMap.get('nonce');
                    DateTime experiesInTime = System.now().addSeconds(expires_in);
                    
                    /* Create the Metadata for the Token */
                    String fullName = 'PayPal_TokenInfo.'+env;
                    Map<String, Object> fieldValueMap = new Map<String, Object>();
                    fieldValueMap.put('access_token__c', access_token);
                    fieldValueMap.put('app_id__c', app_id);
                    fieldValueMap.put('expires_in_seconds__c', expires_in);
                    fieldValueMap.put('expires_in_time__c', experiesInTime);
                    fieldValueMap.put('nonce__c', nonce);
                    fieldValueMap.put('scope__c', scope);
                    fieldValueMap.put('token_type__c', token_type);
                    
                    /* Create/Update the Metadata Record */
                    CreateUpdateMetadataUtils.createUpdateMetadata(fullName, env, fieldValueMap);
                    
                }else{
                    System.debug(' Error Occured '+responseBody);
                    errorMessage = 'Unexpected Error while communicating with PayPal API. '
                                        +'Status '+httpRes.getStatus()+' and Status Code '+httpRes.getStatuscode();
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
                }
            }catch(System.Exception e){
                System.debug('#### Exception Excuted '+e.getStackTraceString()+'  '+e.getMessage());
                if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
                    errorMessage =  'Unauthorize endpoint: An Administer must go to Setup -> Administer -> Security Control ->'
                                        +' Remote Site Setting and add '+' '+ tokenURL+' Endpoint';
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
                }else{
                    errorMessage = 'Unexpected Error while communicating with PayPal API. '
                                        +'Status '+httpRes.getStatus()+' and Status Code '+httpRes.getStatuscode();
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
                }
            }
        }
    }
    
    public static String errorMessage(System.Exception e, HttpResponse httpRes){
        String errorMessage = '';
        System.debug('#### Exception Excuted '+e.getStackTraceString()+'  '+e.getMessage());
        if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
            errorMessage =  'Unauthorize endpoint: An Administer must go to Setup -> Administer -> Security Control ->'
                                +' Remote Site Setting and add '+' API Endpoint';
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
        }else{
            errorMessage = 'Unexpected Error while communicating with PayPal API. '
                                +'Status '+httpRes.getStatus()+' and Status Code '+httpRes.getStatuscode();
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
        }
        return errorMessage;
    }
    
    public static PayPal_TokenInfo__mdt tokenDetails(){
        String env = System.Label.PayPal_Environment;
        PayPal_TokenInfo__mdt token = [Select Id, MasterLabel,expires_in_time__c,
                                       access_token__c 
                                       From PayPal_TokenInfo__mdt Where DeveloperName =: env];
        
        return token;
    }
    
    public static PayPal_EndPoint__mdt apiEndPoints(){
        PayPal_EndPoint__mdt endPoints = [Select Id, MasterLabel,
                                          Make_Payment__c, Create_Order__c,
                                          Refund_URL__c, Create_Product__c,
                                          Create_Plans__c, Create_Subscriptions__c,
                                          Create_draft_invoice__c,
                                          Remind_Invoice__c, Generate_Token__c
                                          From 
                                          PayPal_EndPoint__mdt Where MasterLabel =: System.Label.PayPal_Endpoints];
        return endPoints;
    }
    
    public static String getenerateCardToken(String url , String Method, String reqBody){
        
        HttpRequest httpReq = PayPalUtils.prepareRequest(url, Method);    
        httpReq.setBody(reqBody);
        String errorMessage = '';
        String tokenId = '';
        HttpResponse httpRes = new HttpResponse();
        Try{
            httpRes = (new Http()).send(httpReq);
            String response = httpRes.getBody();
            Integer statusCode = httpRes.getStatusCode();
            if( statusCode == 200 || statusCode == 201){
                Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUnTyped(response);
                //System.debug(' #### responseMap '+responseMap);
                tokenId = (String) responseMap.get('id');
                //System.debug(' #### token '+tokenId);
            }else{
                //System.debug(' #### Error Occured '+response);
                errorMessage = 'Unexpected Error while communicating with PayPal API. '
                                    +'Status '+httpRes.getStatus()+' and Status Code '+httpRes.getStatuscode();
                tokenId = errorMessage;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
                
            }
        }Catch(System.Exception e){
            errorMessage = PayPalUtils.errorMessage(e, httpRes);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
            return null;
        }
        return tokenId;
    }
    
    public static HttpRequest prepareRequest(String url , String Method){
        
        PayPal_TokenInfo__mdt token = tokenDetails();
        
        List<Paypal_API__mdt> paypalCred = apiDetails();
        
        String clientId     = paypalCred.get(0).Client_ID__c;
        String clientSecret = paypalCred.get(0).Client_Secret__c;
        
        /* Prepare Http Request to Get the Paypal Token Credentials */
        
        String dataToEncode = clientId+':'+clientSecret;
        Blob blobValue = Blob.valueOf(dataToEncode);
        String encodedData = EncodingUtil.base64Encode(blobValue);
        String authToken = '';
        
        if(token.expires_in_time__c < System.now()){
            authToken = 'Basic '+encodedData;
        }else{
            authToken = 'Bearer '+token.access_token__c;
        }
        
        //System.debug(' #### authToken '+authToken);
        
        HttpRequest HttpReq = new HttpRequest();
        httpReq.setMethod(Method);
        httpReq.setEndPoint(url);
        httpReq.setHeader('Content-Type','application/json');
        httpReq.setHeader('Authorization', authToken);
        return httpReq;
    }
}