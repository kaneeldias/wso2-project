import wso2/gsheets4;
import ballerina/http;
import ballerina/io;

gsheets4:SpreadsheetConfiguration spreadsheetConfig = {
    clientConfig: {
        auth: {
            scheme: http:OAUTH2,
            config: {
                grantType: http:DIRECT_TOKEN,
                config: {
                    accessToken: accessToken,
                    refreshConfig: {
                        clientId: clientId,
                        clientSecret: clientSecret,
                        refreshToken: refreshToken,
                        refreshUrl: gsheets4:REFRESH_URL
                    }
                }
            }
        }
    }
};

gsheets4:Spreadsheet spreadsheet = new;
gsheets4:Client spreadsheetClient = new(spreadsheetConfig);
string spreadsheetId = "1TriZLR5F00yIuYXUCI1A1LNwNd6AWOEkDxMLJ8xeMhU";
string sheetName = "Sheet1";



public function main2() {
    var sps = spreadsheetClient->openSpreadsheetById(spreadsheetId);

    if (sps is gsheets4:Spreadsheet) {
        // If successful, print the Spreadsheet object.
        spreadsheet = sps;
        io:println("Spreadsheet Details: ", spreadsheet);
        openSheet();
    } else {
        // If unsuccessful, print the error returned.
        io:println("Error: ", spreadsheet);
    }
}

public function openSheet() {
    var response = spreadsheet.getSheetByName(sheetName);
    if (response is gsheets4:Sheet) {
        // If successful, print the Spreadsheet Details.
        io:println("Sheet Details: ", response);
        setValues();
    } else {
        // If unsuccessful, print the error returned.
        io:println("Error: ", response);
    }
}

public function setValues() {
    var response = spreadsheetClient->setSheetValues(spreadsheetId, sheetName, topLeftCell = "A1", bottomRightCell = "B3", [["12", "11"], ["10", "9"]]);
    if (response is boolean) {
        io:println("Status: ", response);
    } else {
        // If unsuccessful, print the error returned.
        io:println("Error: ", response);
    }
}

public function addRow(int index, string[] row) {
    string cell = "A" + (index+2);
    io:println(cell);
    var response = spreadsheetClient->setSheetValues(spreadsheetId, sheetName, topLeftCell = cell, [row]);
    if (response is boolean) {
        io:println("Status: ", response);
    } else {
        // If unsuccessful, print the error returned.
        io:println("Error: ", response);
    }
}

listener http:Listener httpListener = new(4000);

@http:ServiceConfig {
    basePath: "/sheets"
}
service Sheets on httpListener {


    @http:ResourceConfig {
        methods: ["POST"],
        path: "/add-row"
    }

    resource function executeOperation(http:Caller caller, http:Request req) {
        var params = req.getJsonPayload();
        if (params is json) {
            json rows = params.rows;
            io:println(rows);
            int i = 0;
            while (i < rows.length()) {
                json row = rows[i];
                int j = 0;
                string[] row_s = [];
                while (j < row.length()) {
                    row_s[j] = row[j].toString();
                    j = j + 1;
                }
                addRow(i, row_s);
                i = i + 1;
            }
        }
        var err = caller->respond("df");
    }
}




















