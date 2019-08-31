@isTest
private class BillingCalloutServiceTest {
	@testSetup
    static void makeData() {
        ServiceCredentials__c cred = new ServiceCredentials__c();
        cred.Name = 'BillingServiceCredential';
        cred.Username__c = 'bsUser1';
        cred.Password__c = 'bsPass1';
        insert cred;
        
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
        
        Project__c proj = new Project__c();
        proj.Name = 'Test Project';
        proj.ProjectRef__c = '123456789';
        proj.Opportunity__c = o.Id;
        proj.Start_Date__c = Date.today();
        proj.End_Date__c = Date.today().addDays(30);
        proj.Billable_Amount__c = 100000;
        proj.Status__c = 'Running';
        insert proj;
    }
    
    @isTest
    static void calloutSuccess() {
        Project__c proj = [SELECT Id, Status__c, ProjectRef__c, Billable_Amount__c 
                           FROM Project__c 
                           LIMIT 1];
        
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
        
        Test.startTest();
        proj.Status__c = 'Billable';
        update proj;
        Test.stopTest();
        
        /*Project__c updated = [SELECT Id, Status__c, ProjectRef__c, Billable_Amount__c 
                               FROM Project__c 
                               LIMIT 1];
        
        system.assertEquals('Billed', updated.Status__c);*/
    }
    
    @isTest
    static void calloutFailure() {
        Project__c proj = [SELECT Id, Status__c, ProjectRef__c, Billable_Amount__c 
                           FROM Project__c 
                           LIMIT 1];
        
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
        
        Test.startTest();
        proj.Status__c = 'Billable';
        update proj;
        Test.stopTest();
        
        /*Project__c updated = [SELECT Id, Status__c, ProjectRef__c, Billable_Amount__c 
                               FROM Project__c 
                               LIMIT 1];
        
        system.assertEquals('Billable', updated.Status__c);*/
    }
}