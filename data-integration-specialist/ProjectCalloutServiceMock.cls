@isTest
global class ProjectCalloutServiceMock implements HttpCalloutMock {
   global HTTPResponse respond(HTTPRequest request) {
       HttpResponse response = new HttpResponse();
       response.setHeader('Content-Type', 'application/json');
       response.setBody('{"project":12345}');
       response.setStatusCode(200);
       return response;
   }
}