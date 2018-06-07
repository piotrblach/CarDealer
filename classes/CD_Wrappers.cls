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
}