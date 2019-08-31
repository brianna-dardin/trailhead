public class ProjectCalloutService {
    @InvocableMethod
    public static void postOpportunityToPMS(List<Id> optyIds){
        QueueablePMSCall qPMSCall = new QueueablePMSCall(optyIds);
        System.enqueueJob(qPMSCall);
    }
    
    public class QueueablePMSCall implements Queueable, Database.AllowsCallouts {
        public List<Id> optyIds;
        
        public QueueablePMSCall(List<Id> optyIds) {
            this.optyIds = optyIds;
        }
        
        public void execute(QueueableContext context) {
            List<Opportunity> optyList = [SELECT Id, Name, Account.Name, CloseDate, Amount, StageName FROM Opportunity WHERE Id =: optyIds[0]];
        
            String formattedDate = optyList[0].CloseDate.year() + '-' + optyList[0].CloseDate.month() + '-' + optyList[0].CloseDate.day();
            Map<String, Object> optyMap = new Map<String, Object>{'opportunityId' => optyList[0].Id,
                                                                  'opportunityName' => optyList[0].Name,
                                                                  'accountName' => optyList[0].Account.Name,
                                                                  'closeDate' => formattedDate,
                                                                  'amount' => optyList[0].Amount};
            
            ServiceTokens__c token = [SELECT Token__c FROM ServiceTokens__c WHERE Name = 'ProjectServiceToken'];                                                        
                                                                      
            HttpRequest req = new HttpRequest();
            req.setTimeout(60000);
            req.setEndpoint('callout:ProjectService');
            req.setHeader('token', token.Token__c);
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('POST');
            req.setBody(JSON.serializePretty(optyMap));
            
            Http http = new Http();
            HTTPResponse res = http.send(req);
            
            if (res.getStatusCode() == 200) {
                optyList[0].StageName = 'Submitted Project';
            } else {
                optyList[0].StageName = 'Resubmit Project';
            }
            update optyList[0];
        }
    }
}