public with sharing class OppDataProvider {

    // PMD Issue: Avoid hardcoding values
    public static String CLOSED_STAGE = 'Closed Won'; 

    // PMD Issue: Unused Variable
    private Integer unusedVar = 100;

    // PMD Issue: Method too long / Cognitive Complexity / Missing Comments
    public static List<Opportunity> getOpportunities(Id accountId) {
        List<Opportunity> oppList = new List<Opportunity>();

        if(accountId != null){ // PMD Issue: Braces style
            oppList = [SELECT Id, Name, StageName, Amount FROM Opportunity WHERE AccountId =: accountId];

            for(Opportunity opp : oppList){ 
                if(opp.StageName == 'Prospecting'){ // PMD: Hardcoding string
                    opp.Amount = 1000; 
                }else if(opp.StageName == 'Qualification'){
                    opp.Amount = 2000;
                }else if(opp.StageName == CLOSED_STAGE){
                    opp.Amount = 0;
                }else{
                    opp.Amount = 500; // PMD: Magic number
                }

                // PMD Issue: Empty if block
                if(opp.Name == null){
                }
            }
        }

        // PMD Issue: Empty return check
        if(oppList.isEmpty()){
            return null;
        }

        return oppList;
    }

    // PMD Issue: Empty method
    public void doNothing(){

    }
}
