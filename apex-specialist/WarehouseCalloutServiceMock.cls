global class WarehouseCalloutServiceMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        String body = '[{"_id":"55d66226726b611100aaf741","replacement":false,"quantity":5,"name":"Generator 1000 kW","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"100003"},'
        +'{"_id":"55d66226726b611100aaf742","replacement":true,"quantity":183,"name":"Cooling Fan","maintenanceperiod":0,"lifespan":0,"cost":300,"sku":"100004"},'
        +'{"_id":"55d66226726b611100aaf743","replacement":true,"quantity":143,"name":"Fuse 20A","maintenanceperiod":0,"lifespan":0,"cost":22,"sku":"100005"},'
        +'{"_id":"55d66226726b611100aaf744","replacement":false,"quantity":5,"name":"Generator 2000 kw","maintenanceperiod":365,"lifespan":120,"cost":6000,"sku":"100006"},'
        +'{"_id":"55d66226726b611100aaf745","replacement":true,"quantity":142,"name":"Fuse 25A","maintenanceperiod":0,"lifespan":0,"cost":28,"sku":"100007"}]';
        
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(body);
        response.setStatusCode(200);
        return response; 
    }
}