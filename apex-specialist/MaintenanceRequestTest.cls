@isTest
private class MaintenanceRequestTest {
    @testSetup static void testData() {
        List<Product2> products = new List<Product2>();
        for (Integer i = 0; i < 10; i++) {
            Product2 p = new Product2(Name = 'Test Product '+i,
                                      Maintenance_Cycle__c = (i+1)*2,
                                      Replacement_Part__c = True);
            products.add(p);
        }
        insert products;
        
        List<Case> cases = new List<Case>();
        for (Integer i = 0; i < 300; i++) {
            Case c = new Case(Type = 'Routine Maintenance',
                              Subject = 'Test',
                              Date_Due__c = Date.today(),
                              Status = 'New');
            cases.add(c);
        }
        insert cases;
        
        List<Work_Part__c> parts = new List<Work_Part__c>();
        for (Case c : cases) {
            for (Product2 p : products) {
                Work_Part__c wp = new Work_Part__c(Maintenance_Request__c = c.Id,
                                                   Equipment__c = p.Id);
                parts.add(wp);
            }
        }
        insert parts;
    }
    
    @isTest static void positiveTest() {
        List<Case> cases = [SELECT ID, Subject, Type, Status, Date_Reported__c, Date_Due__c, Equipment__c,
                            (SELECT Id, Equipment__r.Maintenance_Cycle__c
                             FROM Work_Parts__r)
                            FROM Case];
        
        Set<Id> caseIDs = new Set<Id>();
        for (Case c : cases) {
            c.Status = 'Closed';
            caseIDs.add(c.Id);
        }
        update cases;
        
        List<Case> newCases = [SELECT ID, Subject, Type, Status, Date_Reported__c, Date_Due__c, Equipment__c
                                FROM Case
                                WHERE Id NOT IN :caseIDs];
        
        System.assertEquals(cases.size(), newCases.size());
        
        for (Case c : newCases) {
            System.assertEquals(Date.today(), c.Date_Reported__c);
            System.assertEquals(Date.today()+2, c.Date_Due__c);
            System.assertEquals('Maintenance', c.Subject);
        }
    }
    
    @isTest static void negativeTest() {
        List<Case> cases = [SELECT ID, Subject, Type, Status, Date_Reported__c, Date_Due__c, Equipment__c,
                            (SELECT Id, Equipment__r.Maintenance_Cycle__c
                             FROM Work_Parts__r)
                            FROM Case];
        
        Set<Id> caseIDs = new Set<Id>();
        for (Case c : cases) {
            c.Status = 'Closed';
            c.Type = 'Other';
            caseIDs.add(c.Id);
        }
        update cases;
        
        List<Case> newCases = [SELECT ID, Subject, Type, Status, Date_Reported__c, Date_Due__c, Equipment__c
                                FROM Case
                                WHERE Id NOT IN :caseIDs];
        
        System.assertEquals(0, newCases.size());
    }
}