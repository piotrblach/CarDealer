
public with sharing class CD_CartManagerController {
    @AuraEnabled
    public static List<CD_Wrappers.CD_CartItem> getCustomerCartItems(){
        List<CD_Wrappers.CD_CartItem> cartItems;

        if (Cache.Session.contains('local.Cart.cartItems')) {
            cartItems = (List<CD_Wrappers.CD_CartItem>)Cache.Session.get('local.Cart.cartItems');
        }else{
            cartItems = new List<CD_Wrappers.CD_CartItem>();
        }
        return cartItems;
    }

    @AuraEnabled
    public static String deleteCustomerCartItem(String[] carIdsToRemove){
        List<CD_Wrappers.CD_CartItem> cartItems;

        if (Cache.Session.contains('local.Cart.cartItems')) {
            cartItems = (List<CD_Wrappers.CD_CartItem>)Cache.Session.get('local.Cart.cartItems');
        }else{
            cartItems = new List<CD_Wrappers.CD_CartItem>();
        }

        if(cartItems != null){
            for(Integer ii = 0; ii < cartItems.size(); ii++){
                for(Integer jj = 0; jj < carIdsToRemove.size(); jj++){
                    if(cartItems[ii].car.Id == carIdsToRemove[jj]){
                        cartItems.remove(ii);
                    }
                }
            }
        }

        Cache.Session.put('local.Cart.cartItems', cartItems);
        return String.valueOf(cartItems.size());
    }

    @AuraEnabled
    public static String setCartItemMeetingDate(String[] carIdsToSetMeeting, String meetingDate){
        List<CD_Wrappers.CD_CartItem> cartItems;

        if (Cache.Session.contains('local.Cart.cartItems')) {
            cartItems = (List<CD_Wrappers.CD_CartItem>)Cache.Session.get('local.Cart.cartItems');
        }else{
            cartItems = new List<CD_Wrappers.CD_CartItem>();
        }
        if(cartItems != null){
            for(Integer ii = 0; ii < cartItems.size(); ii++){
                for(Integer jj = 0; jj < carIdsToSetMeeting.size(); jj++){
                    if(cartItems[ii].car.Id == carIdsToSetMeeting[jj]){
                        cartItems[ii].meetingDate = Datetime.valueOf(meetingDate.substringBeforeLast('.').replace('T',' '));
                    }
                }
            }
        }
        Cache.Session.put('local.Cart.cartItems', cartItems);
        return String.valueOf(cartItems.size());
    }

    @AuraEnabled
    public static String proceedToCheckout(){
        List<CD_Wrappers.CD_CartItem> cartItems;
        if (Cache.Session.contains('local.Cart.cartItems')) {
            cartItems = (List<CD_Wrappers.CD_CartItem>)Cache.Session.get('local.Cart.cartItems');
        }
        List<Event> productMeetings = new List<Event>();
        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
        Opportunity opportunity = createOpportunityFromCheckout();
        if(cartItems != null){
            for(Integer ii = 0; ii < cartItems.size(); ii++){
                productMeetings.add(createMeetingEventForCheckout(cartItems[ii]));
                opportunityLineItems.add(createOpportunityLineItemForCheckout(cartItems[ii], opportunity.Id, cartItems[ii].carStandardPrice));
            }
        }else{
            throw new AuraHandledException(Label.CD_Customer_cart_is_empty);
        }

        try{
            insert productMeetings;
            insert opportunityLineItems;
            deleteAllCustomerCartItems();
        }catch (DmlException e){
            throw new AuraHandledException(Label.CD_Error_creating_product_meetings);
        }
        return Label.CD_SUCCESS;
    }

    private static OpportunityLineItem createOpportunityLineItemForCheckout(CD_Wrappers.CD_CartItem cartItem, String opportunityId, Decimal carStandardPrice){
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.Product2Id = cartItem.car.Id;
        oli.OpportunityId = opportunityId;
        oli.Quantity = 1;
        oli.UnitPrice = cartItem.carLowestPrice.UnitPrice;
        return  oli;
    }

    private static Event createMeetingEventForCheckout(CD_Wrappers.CD_CartItem cartItem){
        User currentUser = CD_Utils.getCurrentUserDetails();
        Event productMeeting = new Event();
        productMeeting.StartDateTime = cartItem.meetingDate;
        productMeeting.EndDateTime = cartItem.meetingDate.addHours(1);
        productMeeting.CD_Car__c = cartItem.car.Id;
        productMeeting.Subject = Label.CD_New_product_meeting;
        productMeeting.OwnerId = CD_Utils.getDefaultSalesManagerId();
        productMeeting.WhatId = currentUser.AccountId;
        productMeeting.CD_Contact__c = currentUser.ContactId;
        productMeeting.CD_PriceBookEntry__c = cartItem.carLowestPrice.Id;
        return productMeeting;
    }

    private static Opportunity createOpportunityFromCheckout(){
        Pricebook2 standardPriceBook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true];
        User currentUser = CD_Utils.getCurrentUserDetails();
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Opportunity';
        opportunity.StageName = 'Prospecting';
        opportunity.CloseDate = Date.today().addDays(7);
        opportunity.Pricebook2Id = standardPriceBook.Id;
        opportunity.AccountId = currentUser.AccountId;
        opportunity.OwnerId = CD_Utils.getDefaultSalesManagerId();
        opportunity.CD_Contact__c = currentUser.ContactId;
        try{
            insert opportunity;
            return opportunity;
        }catch (DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                System.debug(e.getDmlMessage(i));
            }
            throw new AuraHandledException(Label.CD_Error_when_creating_opportunity);
        }
    }

    private static void deleteAllCustomerCartItems(){
        if (Cache.Session.contains('local.Cart.cartItems')) {
            Cache.Session.remove('local.Cart.cartItems');
        }
    }

}

