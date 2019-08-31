@isTest
private class ProjectCalloutServiceTest {
	@testSetup
    static void makeData() {
        ServiceTokens__c token = new ServiceTokens__c();
        token.Name = 'ProjectServiceToken';
        token.Token__c = '123456789';
        insert token;
        
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
    }
    
    @isTest
    static void calloutSuccess() {
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
        
        Opportunity o = [SELECT Id, StageName FROM Opportunity LIMIT 1];
        o.StageName = 'Closed Won';
        
        Test.startTest();
        update o;
        Test.stopTest();
        
        Opportunity updated = [SELECT Id, StageName FROM Opportunity LIMIT 1];
        system.assertEquals('Submitted Project', updated.StageName);
    }
    
    @isTest
    static void calloutFailure() {
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
        
        Opportunity o = [SELECT Id, StageName FROM Opportunity LIMIT 1];
        o.StageName = 'Closed Won';
        
        Test.startTest();
        update o;
        Test.stopTest();
        
        Opportunity updated = [SELECT Id, StageName FROM Opportunity LIMIT 1];
        system.assertEquals('Resubmit Project', updated.StageName);
    }
}