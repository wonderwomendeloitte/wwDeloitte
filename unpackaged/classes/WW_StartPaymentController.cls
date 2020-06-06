public class WW_StartPaymentController {
    public WW_EventDetails__c eventDetail                { get; set; }
    public String paymentOption                          { get; set; }
    public decimal salesTax                              { get; set; }
    public decimal shippingTax                           { get; set; }
    public decimal insuranceTax                          { get; set; }
    public decimal handlingTax                           { get; set; }
    
    public WW_StartPaymentController(ApexPages.StandardController controller) {
        this.eventDetail = (WW_EventDetails__c)controller.getRecord(); 
        this.paymentOption = 'Paypal';
        this.salesTax = 00.00;
        this.shippingTax = 00.00;
        this.insuranceTax = 00.00;
        this.handlingTax =00.00;

    }


    public PageReference startPayment() {
        return null;
    }
    
    
    /* Properties */
    
    public Opportunity opp                               { get; set; }
    public List<OpportunityLineItem> lineItems           { get; set; }
    public Decimal Quantity                              { get; set; }
    public Decimal UnitPrice                             { get; set; }
    public String creditCardOption                       { get; set; }
    
    /****
        Credit Cart Information to be Stored in transient variable Starts
    ****/
    
    public transient String cardNumber                   { get; set; }
    public transient Integer expMonth                    { get; set; }
    public transient Integer expYear                     { get; set; }
    public transient String cvv                          { get; set; }
    
    /****
        Credit Cart Information to be Stored in transient variable End
    ****/
    
    public String firstName                              { get; set; }
    public String lastName                               { get; set; }
    

    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('paypal','PayPal')); 
        options.add(new SelectOption('credit_card','Credit Card')); 
        return options; 
    }
    public List<SelectOption> getCreditCards() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('visa','VISA')); 
        options.add(new SelectOption('amex','Amex'));
        options.add(new SelectOption('discover','Discover'));
        options.add(new SelectOption('mastercard','MasterCard')); 
        return options; 
    }
    
    public String getenerateCardToken(String url , String Method, String reqBody){
    
        String tokenId = PayPalUtils.getenerateCardToken(url , Method, reqBody);
        if(tokenId.contains('Error')){
           tokenId = ''; 
        }
        return tokenId;
    }
    
    public PageReference makePayment(){
        if( paymentOption == null || paymentOption == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please Select Payment Method'));
            return null;
        }else{
            String errorMessage = '';
            /* Generating the Dynamic Invoice Number */
            Integer len = 8;
            final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
            String randStr = '';
            while (randStr.length() < len) {
               Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
               randStr += chars.substring(idx, idx+1);
            }
            
            PayPal_EndPoint__mdt endPoints = PayPalUtils.apiEndPoints();
            HttpRequest httpReq = PayPalUtils.prepareRequest(endPoints.Make_Payment__c,'POST');
            
          /*  String itemsJson = generateItems(lineItems);
            if(itemsJson.endsWith(',')){
                itemsJson = itemsJson.subString(0,itemsJson.length() -1);
            } */
            String finalJson = '{';
            
            
            String paymentMethod = '  "intent": "sale",'+
                                   '  "payer": {'+
                                   '  "payment_method": "'+paymentOption+'"';
                                   
                                   
            if( paymentOption == 'credit_card'){
            
                String reqBody =        '{'+
                            '  "number": "'+cardNumber+'",'+
                            '  "type": "'+creditCardOption+'",'+
                            '  "expire_month": '+expMonth+','+
                            '  "expire_year": '+expYear+','+
                            '  "cvv2": "'+cvv+'",'+
                            '  "first_name": "'+firstName+'",'+
                            '  "last_name": "'+lastName+'"'+
                            '}';
                            
                String tokenId = getenerateCardToken( endPoints.Generate_Token__c, 'POST', reqBody);
                
                if( creditCardOption == null)
                    creditCardOption = 'visa';
                    
                 String funding_instrument = '  "funding_instruments": ['+
                            '    {'+
                            '      "credit_card_token": {'+
                            '        "credit_card_id": "'+tokenId+'"'+
                            '      }'+
                            '    }'+
                            '  ]';
                            
                /*String funding_instrument = '"funding_instruments" : ['+
                                            '{'+
                                                '"credit_card" : {'+
                                                    '"number" : "'+cardNumber+'",'+
                                                    '"type" : "'+creditCardOption+'",'+
                                                    '"expire_month" :'+expMonth+','+
                                                    '"expire_year" : '+expYear+','+
                                                    '"cvv2" :"'+cvv+'"'+
                                                '}'+
                                            '}'+
                                         ']';*/
                                         
                paymentMethod += ','+funding_instrument;
            }
            paymentMethod += '  },';
            
            String paymentDescription = 'Making Donation ';
            
        /*    If( opp.Description != null){
                paymentDescription = opp.Description.replace('\r\n', ' ');
                paymentDescription = paymentDescription.replace('\n', ' ');
                paymentDescription = paymentDescription.replace('\r', ' ');
            } */
            
            String amount = String.ValueOf(eventDetail.WW_Amount__c);
            String transactionInfo = '"transactions": ['+
                                    '    {'+
                                    '      "amount": {'+
                                    '        "total": "'+(0.07+0.03+1.00+0.01+eventDetail.WW_Amount__c)+'",'+
                                    '        "currency": "USD",'+
                                    '        "details": {'+
                                    '          "subtotal": "'+eventDetail.WW_Amount__c+'",'+
                                    '          "tax": "'+0.07+'",'+
                                    '          "shipping": "'+0.03+'",'+
                                    '          "handling_fee": "'+1.00+'",'+
                                    '          "shipping_discount": "-1.00",'+
                                    '          "insurance": "'+0.01+'"'+
                                    '        }'+
                                    '      },'+
                                    '      "description": "'+paymentDescription+'",'+
                                    '      "custom": "EBAY_EMS_900486300244357364",'+
                                    '      "invoice_number": "'+randStr+'",'+
                                    '      "payment_options": {'+
                                    '        "allowed_payment_method": "INSTANT_FUNDING_SOURCE"'+
                                    '      },'+
                                    '      "soft_descriptor": "ECHI5786786",'+
                                    '      "item_list": {'+
                                    '        "items": [],'+
                                    '        "shipping_address": {'+
                                    '          "recipient_name": "Brian Robinson",'+
                                    '          "line1": "4th Floor",'+
                                    '          "line2": "Unit #34",'+
                                    '          "city": "San Jose",'+
                                    '          "country_code": "US",'+
                                    '          "postal_code": "95131",'+
                                    '          "phone": "011862212345678",'+
                                    '          "state": "CA"'+
                                    '        }'+
                                    '      }'+
                                    '    }'+
                                    '  ],';
            
          
            
            String additional_info = '  "note_to_payer": "Contact us for any questions on your order.",'+
                                     '  "redirect_urls": {'+
                                     '    "return_url": "'+System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/WW_Payment",'+
                                     '    "cancel_url": "'+System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/CancelPayment"'+
                                     '  }'+
                                     '}';
            finalJson += paymentMethod + transactionInfo + additional_info;
            httpReq.setBody(finalJson);
            System.debug('#### finalJson '+finalJson);
            
            HttpResponse httpRes = new HttpResponse();
            Try{
                httpRes = (new Http()).send(httpReq);
                String response = httpRes.getBody();
                Integer statusCode = httpRes.getStatusCode();
                if( statusCode == 200 || statusCode == 201){
                    String redirectURL = '';
                    If( paymentOption == 'paypal'){
                        PayPalPaymentWrapper wrapper = (PayPalPaymentWrapper)System.JSON.deserialize(response, PayPalPaymentWrapper.class);
                        List<PayPalPaymentWrapper.Links> paymentLinks = wrapper.Links;
                        For(PayPalPaymentWrapper.Links link : paymentLinks){
                            if( link.rel == 'approval_url'){
                                redirectURL = link.href;
                            }
                        }
                        PageReference pageRef = new PageReference(redirectURL);
                        pageRef.setRedirect(true);
                        return pageRef;
                    }else{
                       /* PaymentWrapper wrapper = (PaymentWrapper)System.JSON.deserialize(response, PaymentWrapper.class);
                        Opportunity_Payment__c payment = createPayment(opp.Id, wrapper);
                        insert payment;
                        PageReference pageRef = new PageReference('/'+payment.id);
                        pageRef.setRedirect(true);
                        return pageRef; */
                    }
                }else{
                    //System.debug(' #### Error Occured '+response);
                    errorMessage = 'Unexpected Error while communicating with PayPal API. '
                                        +'Status '+httpRes.getStatus()+' and Error '+httpRes.getBody();
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
                }
            }Catch(System.Exception e){
                errorMessage = PayPalUtils.errorMessage(e, httpRes);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
                return null;
            }
            
            return null;
        }
    }
    
    public static String generateItems(List<OpportunityLineItem> lineItems){
        String lineItemsData = '';
        For(OpportunityLineItem item : lineItems){
                    lineItemsData +='{'+
                                '"name":"'+item.Product2.Name+ '",'+
                                '"description": "'+item.Description+'",'+
                                '"quantity": "'+Integer.valueOf(item.Quantity)+'",'+
                                '"price": "'+item.UnitPrice+'",'+
                                //'"tax": "1",'+
                                '"sku": "'+item.Product2.ProductCode+'",'+
                                '"currency": "USD"'+
                           '},';
        }
        
        return lineItemsData;
    }
    
   /* public void createPayment(String oppId, PaymentWrapper wrapper){
        Map<String, RecordTypeInfo> recodTypeInfoByDevName = 
                                    SObjectType.Opportunity_Payment__c.getRecordTypeInfosByDeveloperName();
                                    
        String payPalRecordTypeId = recodTypeInfoByDevName.get('Credit_Card').getRecordTypeId();
        
        Opportunity_Payment__c payment = new Opportunity_Payment__c();
        payment.RecordTypeId = payPalRecordTypeId;
        payment.Opportunity__c = oppId;
        payment.Payment_Id__c = wrapper.id;
        payment.Status__c = wrapper.state;
        payment.payment_method__c = wrapper.Payer.payment_method;
        
        PaymentWrapper.Transactions trans = wrapper.transactions[0];
        payment.total__c = Decimal.valueOf(trans.amount.total);
        payment.Subtotal__c = opp.Amount;
        payment.invoice_number__c = trans.invoice_number;
        payment.Description__c = trans.description;
        payment.Custom_Message__c = trans.description;
        
        
        payment.tax__c = salesTax;
        payment.Shipping_tax__c = shippingTax;
        payment.Insurance_tax__c = insuranceTax;
        payment.handling_fee__c = handlingTax;
        payment.shipping_discount__c = -1.00;
        
        PaymentWrapper.Related_resources resources = trans.related_resources[0];
        PaymentWrapper.Sale saleRecord = resources.sale;
        payment.Refund_Id__c = saleRecord.id;
        
        List<PaymentWrapper.Links> linkList = saleRecord.Links;
        
        For(PaymentWrapper.Links link : linkList){
            if(link.rel == 'refund'){
                payment.Refund_URL__c = link.href;
            }
            if(link.rel == 'parent_payment'){
                payment.Payment_URL__c = link.href;
            }
        }
        
        return payment;
    } */

}