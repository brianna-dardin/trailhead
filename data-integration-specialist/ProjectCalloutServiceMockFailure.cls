@isTest
global class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
   global HTTPResponse respond(HTTPRequest request) {
       HttpResponse response = new HttpResponse();
       response.setHeader('Content-Type', 'application/json');
       response.setBody('{"error":"Invalid name"}');
       response.setStatusCode(500);
       return response;
   }
}