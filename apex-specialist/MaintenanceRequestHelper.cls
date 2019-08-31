public class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> workOrders){
        // update workorders
        List<Case> newCases = new List<Case>();
        for (Case c : workOrders) {
            Case newCase = c.clone();
            newCase.Type = 'Routine Maintenance';
            newCase.Subject = 'Maintenance';
            newCase.Status = 'New';
            newCase.Date_Reported__c = Date.today();
            
            Double cycle = 0;
            for (Work_Part__c wp : c.Work_Parts__r) {
                if (cycle == 0 || cycle > wp.Equipment__r.Maintenance_Cycle__c) {
                    cycle = wp.Equipment__r.Maintenance_Cycle__c;
                }
            }
            
            newCase.Date_Due__c = Date.today() + (Integer)Math.floor(cycle);
            newCases.add(newCase);
        }
        
        if (newCases.size() > 0) {
            insert newCases;
        }
    }        
    
}