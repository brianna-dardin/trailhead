trigger MaintenanceRequest on Case (before update, after update) {
    // call MaintenanceRequestHelper.updateWorkOrders 
    if (Trigger.isAfter) {
        List<ID> caseIDs = new List<ID>();
        for (Case c : Trigger.New) {
            if(c.Status == 'Closed' && Trigger.oldMap.get(c.Id).get('Status') != 'Closed'
               && (c.Type == 'Repair' || c.Type == 'Routine Maintenance')) {
                caseIDs.add(c.Id);
            }
        }
        
        if (caseIDs.size() > 0) {
            List<Case> workOrders = [SELECT ID, Subject, Type, Status, Date_Reported__c, Date_Due__c, Equipment__c, Vehicle__c, AccountId,
                                     (SELECT Id, Equipment__r.Maintenance_Cycle__c
                                      FROM Work_Parts__r)
                                     FROM Case
                                     WHERE ID IN :caseIDs];
            MaintenanceRequestHelper.updateWorkOrders(workOrders);
        }
    } 
}