/**
 * Created by BRITENET on 08.06.2018.
 */

trigger CD_ContentDocumentLinkTrigger on ContentDocumentLink (before insert) {
    for(ContentDocumentLink cdl : Trigger.new) {
        cdl.Visibility = 'AllUsers';
    }
}