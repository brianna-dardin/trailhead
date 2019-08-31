trigger ProjectTrigger on Project__c (after update) {
    //Not bulkified due to future method limits
    BillingCalloutService.callBillingService(Trigger.New[0], Trigger.OldMap.get(Trigger.New[0].Id));
}