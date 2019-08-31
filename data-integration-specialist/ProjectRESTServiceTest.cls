@isTest
private class ProjectRESTServiceTest {
    @isTest
    static void webServiceSuccess() {
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Opportunity o = new Opportunity();
        o.Name = 'Test Opportunity';
        o.AccountId = a.Id;
        o.StageName = 'Negotiation/Review';
        o.CloseDate = Date.today();
        o.Type = 'New Project';
        insert o;
        
        String response = ProjectRESTService.postProjectData('Test Project','123456789',o.Id,Date.today(),
                                                             Date.today().addDays(30),100000,'Running');
        system.assertEquals('OK', response);
        
        Opportunity updated = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity LIMIT 1];
        system.assertEquals('In progress', updated.DeliveryInstallationStatus__c);
        
        Project__c proj = [SELECT Id FROM Project__c WHERE Opportunity__c =: o.Id LIMIT 1];
        system.assert(proj != null);
    }
    
    @isTest
    static void webServiceFailure() {
        String response = ProjectRESTService.postProjectData('Test Project','123456789',null,Date.today(),
                                                             Date.today().addDays(30),100000,'Running');
        system.assertNotEquals('OK', response);
    }
}