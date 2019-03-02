public class RevokingDevice{
    @future(callout=true)
    public static void makeCallout(String User, String Token, String userDeviceID){
        //Get the base URL for your salesforce instance
        String baseURL = System.URL.getSalesforceBaseUrl().getHost();
        String EncUserDeviceId = EncodingUtil.urlEncode(UserDeviceID,'UTF-8');
        String EncToken = EncodingUtil.urlEncode(Token,'UTF-8');
        System.debug('User is: '+user);
        System.debug('Token Value: '+enctoken);
        System.debug('deviceID: '+EncuserDeviceID);
        Http h = new Http();
        // Instantiate a new HTTP request, specify the method (POST) as well as the endpoint
        HttpRequest req = new HttpRequest();
        //req.setEndpoint('https://login.mobile1.t.salesforce.com/services/raevokeDevice');
        req.setEndpoint('https://'+baseURL+'/services/revokeDevice');
        req.setMethod('POST');
        req.setHeader('content-type','application/x-www-form-urlencoded');
        req.setBody('token='+enctoken+'&userDeviceId='+encuserDeviceId);
        system.debug('request body: '+req.getbody());                

        // Send the request, and return a response
        HttpResponse res = h.send(req);
        // status code = 200 if it is successful, 302 if there is a redirect involved, or 400 if there is an error
        integer statusCode = res.getStatusCode();
        string statusText = res.getStatus();
        string location = res.getHeader('Location');
        System.debug(statusCode);
        System.debug(statusText);
        System.debug(location);
        // Check for HTTP status 302 - unlikely, but just in case. 
        //if(statusCode==302){
          //  HttpRequest redirReq = new HttpRequest();
          //  redirReq.setEndpoint(location);
          //  redirReq.setMethod('GET');
            // status code = 200 if it is successful - 400 if there is an error
          //  HttpResponse redirRes = h.send(redirReq);
          //  integer redirStatusCode = redirRes.getStatusCode();
          //  string redirStatusText = redirRes.getStatus();
          //  System.debug(redirStatusCode);
          //  System.debug(redirStatusText);
        //}
        
}}
