
public with sharing class CD_Utils {
    public static String getCurrentUserAccountId(){
        String userId = UserInfo.getUserId();
        User user = [SELECT AccountId FROM User WHERE Id =: userId];
        return user.AccountId;
    }

    public static User getCurrentUserDetails(){
        String userId = UserInfo.getUserId();
        User user = [SELECT Id, Name, AccountId, ContactId FROM User WHERE Id =: userId];
        return user;
    }

    public static String getDefaultSalesManagerId(){
        CD_SalesManager__c salesManager = CD_SalesManager__c.getInstance('Default Manager');
        return salesManager.CD_Id__c;
    }

    public static String getRestQueryBaseUrl(){
        CD_RestQueryBaseUrl__c restQueryBaseUrl = CD_RestQueryBaseUrl__c.getInstance('MyOrg');
        return restQueryBaseUrl.CD_Url__c;
    }

    public static String getAdminAccessToken(){
        MC_OrgLukaszaOAuth2Credentials__c myOrgCredentials = MC_OrgLukaszaOAuth2Credentials__c.getInstance('MyOrgLogin');
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(myOrgCredentials.loginUri__c);
        req.setBody('grant_type=' + myOrgCredentials.grant_type__c+
                '&client_id=' + myOrgCredentials.client_id__c +
                '&client_secret=' + myOrgCredentials.client_secret__c +
                '&redirect_uri='+ myOrgCredentials.redirect_uri__c +
                '&username=' + myOrgCredentials.username__c +
                '&password=' + myOrgCredentials.password__c);

        Http http = new Http();
        HTTPResponse res = http.send(req);

        MC_LoginResponseBodyWrapper loginResponseBody = (MC_LoginResponseBodyWrapper)JSON.deserialize(res.getBody(), MC_LoginResponseBodyWrapper.class);
        return loginResponseBody.access_token;
    }
}