public class PaymentWrapper{
    public String id;   
    public String create_time;  
    public String update_time;  
    public String state;    
    public String intent;   
    public Payer payer;
    public List<Transactions> transactions;
    public Links[] links;
    public class Payer {
        public String payment_method;   
        public List<Funding_instruments> funding_instruments;
    }
    public class Funding_instruments {
        public Credit_card credit_card;
    }
    public class Credit_card {
        public String type; 
        public String Cardnumber;   
        public String expire_month;
        public String expire_year;  
    }
    public class Transactions {
        public cls_amount amount;
        public String description;  
        public String custom;   
        public String invoice_number;
        public Item_list item_list;
        public Related_resources[] related_resources;
    }
    public class cls_amount {
        public String total;
        public String currencyCode;
    }
    public class Details {
        public String subtotal;
        public String tax;  
        public String shipping;
        public String handling_fee;
        public String insurance;
        public String shipping_discount;
    }
    public class Item_list {
        public List<Items> items;
        public Shipping_address shipping_address;
    }
    public class Items {
        public String name;
        public String sku;
        public String price;
        public String currencyCode;
        public String quantity;
        public String description;
    }
    public class Shipping_address {
        public String recipient_name;   
        public String line1;    
        public String line2;    
        public String city; 
        public String state;    
        public String postal_code;
        public String country_code;
        public String phone;
    }
    public class Related_resources {
        public Sale sale;
    }
    public class Sale {
        public String id;   
        public String create_time;  
        public String update_time;  
        public cls_amount amount;
        public String state;    
        public String parent_payment;   
        public Links[] links;
        public cls_fmf_details fmf_details;
        public cls_processor_response processor_response;
    }
    public class Links {
        public String href; 
        public String rel;  
        public String method;   
    }
    public class cls_fmf_details {
    }
    public class cls_processor_response {
        public String avs_code; 
        public String cvv_code; 
    }
}