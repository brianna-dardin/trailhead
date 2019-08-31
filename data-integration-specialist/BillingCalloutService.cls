public class BillingCalloutService {
    public static void callBillingService(Project__c proj, Project__c oldProj) {
        if (proj.Status__c == 'Billable' && oldProj.Status__c != 'Billable') {
            futureCallout(proj.Id);
        }
    }
    
    @future(callout=true)
    public static void futureCallout(Id projId) {
        Project__c proj = [SELECT Id, ProjectRef__c, Billable_Amount__c 
                           FROM Project__c 
                           WHERE Id =: projId];
        
        ServiceCredentials__c cred = [SELECT Username__c, Password__c 
                                      FROM ServiceCredentials__c 
                                      WHERE Name = 'BillingServiceCredential'];
        
        BillingServiceProxy.project bspProj = new BillingServiceProxy.project();
        bspProj.projectid = proj.ProjectRef__c;
        bspProj.billAmount = proj.Billable_Amount__c;
        bspProj.username = cred.Username__c;
        bspProj.password = cred.Password__c;
        
        BillingServiceProxy.InvoicesPortSoap11 bsp = new BillingServiceProxy.InvoicesPortSoap11();
        String response = bsp.billProject(bspProj);
        system.debug(response);
    }
}