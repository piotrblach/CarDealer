
public with sharing class CD_OrdersController {
    @AuraEnabled
    public static List<Order> loadOrders(){
        User currentUser = CD_Utils.getCurrentUserDetails();
        List<Order> orders = [
                SELECT Id, CreatedDate, OrderNumber, TotalAmount, Opportunity.CD_Contact__c, (SELECT Id, UnitPrice FROM OrderItems)
                FROM Order
                WHERE AccountId =: currentUser.AccountId
                AND Opportunity.CD_Contact__c =: currentUser.ContactId
        ];
        return orders;
    }

    @AuraEnabled
    public static List<CD_Wrappers.CD_OrderProduct> loadOrderProducts(String orderId){
        List<OrderItem> orderProducts = [
                SELECT Id, UnitPrice, ListPrice, Product2Id
                FROM OrderItem
                WHERE OrderId =: orderId
        ];

        Set<Id> carIds = new Set<Id>();
        for(OrderItem orderItem : orderProducts){
            carIds.add(orderItem.Product2Id);
        }
        Map<Id, Product2> orderItemsProductsMap = new Map<Id, Product2>([
                SELECT Id, CD_Year__c, CD_VIN__c, CD_Model__c, Name
                FROM Product2
                WHERE Id IN: carIds
        ]);
        List<CD_Wrappers.CD_OrderProduct> orderProductsWrappers = new List<CD_Wrappers.CD_OrderProduct>();
        for(OrderItem orderItem : orderProducts){
            orderProductsWrappers.add(new CD_Wrappers.CD_OrderProduct(orderItem, orderItemsProductsMap.get(orderItem.Product2Id)));
        }
        return orderProductsWrappers;
    }
}