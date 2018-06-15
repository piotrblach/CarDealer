/**
 * Created by BRITENET on 29.05.2018.
 */

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

        public CD_CartItem(Product2 car, Datetime meetingDate){
            this.car = car;
            this.meetingDate = meetingDate;
        }

        public CD_CartItem(Product2 car){
            this.car = car;
        }
    }

    public class CD_ProductMeeting{
        @AuraEnabled
        public Event productMeeting {get; set;}
        @AuraEnabled
        public Product2 car {get; set;}
        @AuraEnabled
        public User salesRep {get; set;}

        public CD_ProductMeeting(Event productMeeting, Product2 car){
            this.car = car;
            this.productMeeting = productMeeting;
        }

        public CD_ProductMeeting(Event productMeeting, Product2 car, User salesRep){
            this.car = car;
            this.productMeeting = productMeeting;
            this.salesRep = salesRep;
        }
    }
}