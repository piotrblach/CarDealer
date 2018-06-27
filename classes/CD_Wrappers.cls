
public with sharing class CD_Wrappers {
    public class CD_UploadImage{
        public String parentId {get; set;}
        public String fileName {get; set;}
        public String base64Data {get; set;}
        public String contentType {get; set;}
    }

    public class CD_CartItem{
        @AuraEnabled
        public Datetime meetingDate {get; set;}
        @AuraEnabled
        public Product2 car {get; set;}
        @AuraEnabled
        public PricebookEntry carLowestPrice {get; set;}
        @AuraEnabled
        public Decimal carStandardPrice {get; set;}


        public CD_CartItem(Product2 car, Datetime meetingDate){
            this.car = car;
            this.meetingDate = meetingDate;
        }

        public CD_CartItem(Product2 car, PricebookEntry carLowestPrice, Decimal carStandardPrice){
            this.car = car;
            this.carLowestPrice = carLowestPrice;
            this.carStandardPrice = carStandardPrice;
        }
    }

    public class CD_ProductMeeting{
        @AuraEnabled
        public Event productMeeting {get; set;}
        @AuraEnabled
        public Product2 car {get; set;}
        @AuraEnabled
        public User salesRep {get; set;}
        @AuraEnabled
        public PricebookEntry carLowestPrice {get; set;}

        public CD_ProductMeeting(Event productMeeting, Product2 car, PricebookEntry carLowestPrice){
            this.car = car;
            this.productMeeting = productMeeting;
            this.carLowestPrice = carLowestPrice;
        }

        public CD_ProductMeeting(Event productMeeting, Product2 car, User salesRep, PricebookEntry carLowestPrice){
            this.car = car;
            this.productMeeting = productMeeting;
            this.salesRep = salesRep;
            this.carLowestPrice = carLowestPrice;
        }
    }

    public class CD_PriceBookEntry{
        @AuraEnabled
        public PricebookEntry priceBookEntry {get; set;}
        @AuraEnabled
        public Product2 car {get; set;}

        public CD_PriceBookEntry(Product2 car, PricebookEntry priceBookEntry){
            this.car = car;
            this.priceBookEntry = priceBookEntry;
        }
    }

    public class CD_CarWithStandardPrice{
        @AuraEnabled
        public Product2 car {get; set;}
        @AuraEnabled
        public Decimal carStandardPrice {get; set;}

        public CD_CarWithStandardPrice(Product2 car, Decimal carStandardPrice){
            this.car = car;
            this.carStandardPrice = carStandardPrice;
        }
    }

    public class CD_CarToAddToDiscount{
        @AuraEnabled
        public String carId {get; set;}
        @AuraEnabled
        public Decimal discountPrice {get; set;}

        public CD_CarToAddToDiscount(String carId, Decimal discountPrice){
            this.carId = carId;
            this.discountPrice = discountPrice;
        }
    }

    public class CD_OrderProduct{
        @AuraEnabled
        public OrderItem orderItem {get; set;}
        @AuraEnabled
        public Product2 orderItemProduct {get; set;}

        public CD_OrderProduct(OrderItem orderItem, Product2 orderItemProduct){
            this.orderItem = orderItem;
            this.orderItemProduct = orderItemProduct;
        }
    }

    public class CD_EventQueryResult{
        @AuraEnabled
        public Decimal totalSize {get; set;}
        @AuraEnabled
        public Boolean done {get; set;}
        @AuraEnabled
        public List<Event> records {get; set;}
    }
}