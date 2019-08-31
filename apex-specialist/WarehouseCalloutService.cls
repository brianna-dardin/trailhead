public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    @future(callout=true)
    public static void runWarehouseEquipmentSync(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            List<Object> equipment = (List<Object>) JSON.deserializeUntyped(response.getBody());
            
            List<Product2> products = new List<Product2>();
            for (Object eq : equipment) {
                Map<String, Object> eqMap = (Map<String, Object>) eq;
                
                Product2 prod = new Product2(Warehouse_SKU__c = (String)eqMap.get('_id'),
                                             Replacement_Part__c = True,
                                             Current_Inventory__c = (Integer)eqMap.get('quantity'),
                                             Name = (String)eqMap.get('name'),
                                             Maintenance_Cycle__c = (Integer)eqMap.get('maintenanceperiod'),
                                             Lifespan_Months__c = (Integer)eqMap.get('lifespan'),
                                             Cost__c = (Integer)eqMap.get('cost'));
                products.add(prod);
            }
            upsert products Warehouse_SKU__c;
        }
    }

}