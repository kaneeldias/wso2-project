import ballerina/http;
import ballerina/log;

listener http:Listener httpListener = new(3000);

// Calculator REST service
@http:ServiceConfig {
    basePath: "/instagram"
}
service Instagram on httpListener {

    // Resource that handles the HTTP POST requests that are directed to
    // the path `/operation` to execute a given calculate operation
    // Sample requests for add operation in JSON format
    // `{ "firstNumber": 10, "secondNumber":  200, "operation": "add"}`
    // `{ "firstNumber": 10, "secondNumber":  20.0, "operation": "+"}`

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/get-posts"
    }
    resource function executeOperation(http:Caller caller, http:Request req) {
        json links = fetch();
        http:Client sheetsEndpoint = new("http://127.0.0.1:4000/sheets");
        var response = sheetsEndpoint->post("/add-row", {rows: untaint links});
        json res = [];
        var err = caller->respond(untaint links);
    }
}
