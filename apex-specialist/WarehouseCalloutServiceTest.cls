@isTest
private class WarehouseCalloutServiceTest {
  // implement your mock callout test here
    @isTest static void calloutTest() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock()); 
        
        Test.startTest();
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();
        
        List<Product2> products = [SELECT Id
                                   FROM Product2
                                   WHERE Warehouse_SKU__c != NULL];
        
        System.assertEquals(5, products.size());
    }
    
    @isTest static void scheduleTest() {
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock()); 
        WarehouseSyncSchedule reminder = new WarehouseSyncSchedule();
        String sch = '0 30 8 10 8 ?';
        String jobID = System.schedule('Test Job', sch, reminder);
        
        Test.stopTest();
        
        System.assert(jobID != null);
    }
}