@RestResource(urlMapping='/project/*')
global class ProjectRESTService {
    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId, Date StartDate, 
                                         Date EndDate, Double Amount, String Status) {
		Savepoint sp = Database.setSavepoint();
        
        try {
            Project__c proj = new Project__c();
            proj.Name = ProjectName;
            proj.ProjectRef__c = ProjectRef;
            proj.Opportunity__c = OpportunityId;
            proj.Start_Date__c = StartDate;
            proj.End_Date__c = EndDate;
            proj.Billable_Amount__c = Amount;
            proj.Status__c = Status;
            insert proj;
            
            Opportunity opp = new Opportunity();
            opp.Id = OpportunityId;
            opp.DeliveryInstallationStatus__c = 'In Progress';
            update opp;
            
            return 'OK';
        } catch (Exception e) {
            Database.rollback(sp);
            return e.getMessage();
        }
    }
}