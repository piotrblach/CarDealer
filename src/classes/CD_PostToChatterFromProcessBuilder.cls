public with sharing class CD_PostToChatterFromProcessBuilder {
    @InvocableMethod
    public static void createNewChatterPost(List<String> leadId){
        List<CollaborationGroup> publicGroups = [SELECT id,name FROM CollaborationGroup WHERE name='SalesRepsChatterGroup'];
        String groupId = publicGroups[0].Id;
        String instanceUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        List<Lead> givenLeads = [SELECT id,Name,CreatedBy.Name, company,status,CreatedDate, LeadSource FROM Lead WHERE id IN :leadId];
        List<FeedItem> postsItems = new List<FeedItem>();
        for(Lead eachLead : givenLeads){
            String createDate = String.valueOf(eachLead.CreatedDate.date());
            String postBody = setPostBody(eachLead.Status, eachLead.Name, eachLead.Company, eachLead.CreatedBy.Name, createDate, eachLead.LeadSource);
            String postLinkUrl = instanceUrl+'/one/one.app#/sObject/'+eachLead.Id+'/view';
            postsItems.add(new FeedItem(
                    body=postBody,
                    type='LinkPost',
                    LinkUrl=postLinkUrl,
                    ParentId=groupId,
                    Title = 'Go to Lead'
            ));
        }
        upsert postsItems;
    }

    private static String setPostBody(String leadStatus, String leadName, String leadCompany, String cratedBy, String leadCreateDate, String leadSource){
        String postBody = '';

        if (leadStatus == 'New' && leadSource != 'Web'){
            postBody = 'New Lead '+leadName+' was created at '+leadCreateDate+' by '+cratedBy;
            return postBody;
        }
        else if (leadSource == 'Web'){
            postBody = 'New Lead '+leadName+' was created at '+leadCreateDate+' by Web-to-Lead';
            return postBody;
        }
        else if (leadStatus == 'Offer'){
            postBody = 'An Offer was send to '+leadName+'\r\nCompany: '+leadCompany;
            return postBody;
        }
        else return null;
    }


}