import ballerina/io;
import ballerina/http;
import ballerina/internal;


string redirectUrl = "https%3A%2F%2Flocalhost%2Finstagram%2Fauth";
string username = "1397689896.35513e3.2854ffdaef8844cc984c91522192377e";
string userId = "1397689896";

http:Client instagramEndpoint = new("https://api.instagram.com");
public function fetch() returns (json){
    var response = instagramEndpoint->get("/v1/users/" + userId + "/media/recent?access_token=" + accessToken);
    json res = [];

    if (response is http:Response) {
        io:println("yay");
        json | error s = response.getJsonPayload();
        if (s is json) {
            var j = s.data;
            int i = 0;
            while (i < 20) {
                res[i] = [
                    j[i].link,
                    j[i].created_time,
                    j[i].images.standard_resolution.url
                ];
                i = i + 1;
            }
        }

    }
    else {
        io:println("Get request failed");
    }

    return res;
}








































































