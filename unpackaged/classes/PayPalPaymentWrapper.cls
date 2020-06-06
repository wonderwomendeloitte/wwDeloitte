public class PayPalPaymentWrapper{
    public String id;   
    public String intent;   
    public String state;    
    public Payer payer;
    public List<Transactions> transactions;
    public String note_to_payer;
    public String create_time;  
    public List<Links> links;
    
    public class Payer {
        public String payment_method;   
    }
    public class Transactions {
        public Amount amount;
        public String description;  
        public String custom;   
        public String invoice_number;   
        public String soft_descriptor;  
        public Payment_options payment_options;
        public Item_list item_list;
        public cls_related_resources[] related_resources;
    }
    public class Amount {
        public String total;    
        public String currencyCode; 
        public cls_details details;
    }
    public class cls_details {
        public String subtotal; 
        public String tax;  
        public String shipping; 
        public String insurance;    
        public String handling_fee; 
        public String shipping_discount;    
    }
    public class Payment_options {
        public String allowed_payment_method;   
        public boolean recurring_flag;
        public boolean skip_fmf;
    }
    public class Item_list {
        public Items[] items;
        public cls_shipping_address shipping_address;
    }
    public class Items {
        public String name; 
        public String sku;  
        public String description;  
        public String price;    
        public String currencyCode; 
        public Integer quantity;    
    }
    public class cls_shipping_address {
        public String recipient_name;   
        public String line1;    
        public String line2;    
        public String city; 
        public String state;    
        public String postal_code;  
        public String country_code; 
        public String phone;    
    }
    public class cls_related_resources {
    }
    public class Links {
        public String href;
        public String rel;  
        public String method;   
    }
}