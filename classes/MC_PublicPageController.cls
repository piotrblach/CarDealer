/**
 * Created by BRITENET on 09.04.2018.
 */

public with sharing class MC_PublicPageController {
    public List<MC_Mechanic__c> allMechanics {get; set;}

    public MC_PublicPageController(ApexPages.StandardController controller){
        allMechanics = getRandomMechanics(5);
    }

    public List<MC_Mechanic__c> getRandomMechanics(Integer numberOfRandomMechanics){
        List<MC_Mechanic__c> mechanicsToReturn = new List<MC_Mechanic__c>();
        AggregateResult aggregateResult = [SELECT Count(Id) NumberOfMechanics FROM MC_Mechanic__c];
        Integer numberOfAllRecords = (Integer)aggregateResult.get('NumberOfMechanics');
        if(numberOfRandomMechanics <= numberOfAllRecords){
            List<Integer> mechanicsIndexes = new List<Integer>(MC_RandomNumbersGenerator.getSetOfRandomIntegers(1, numberOfAllRecords, numberOfRandomMechanics));
            for(Integer ii=0; ii< numberOfRandomMechanics; ii++){
                mechanicsToReturn.add([SELECT Id, Name, MC_FirstName__c, MC_LastName__c, MC_City__c, MC_Country__c
                    FROM MC_Mechanic__c
                    LIMIT 1
                    OFFSET : mechanicsIndexes[ii]-1
                ]);
            }
        }
        return mechanicsToReturn;
    }
}