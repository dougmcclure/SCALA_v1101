{
    "name": "DB2 Troubleshooting",  
    "description": "DB2 Troubleshooting Dashboard",
    "customLogic": {
        "script": "DB2Dashboard.py",
        "description": "View chart on search results",
        "parameters": [
            {
                "name": "search",
                "type": "SearchQuery",
                "value": {
                    "logsources": [
                        {
                            "type": "logSource",
                            "name": "DT_DB2_db2diag"
                        }
                    ]
                }
            },
            {
             	"name": "relativeTimeInterval",
             	"type": "string",
             	"value":"LastYear"
            },	
            {
             	"name": "timeFormat",
             	"type": "data",
             	"value": {
             	    "timeUnit": "hour",
             	    "timeUnitFormat": "MM-dd HH:mm"
             	}   
            },	
            {
             	"name": "hostnameField",
             	"type": "string",
             	"value": "DB2Hostname" 
            }	
        ],
        "output": {
            "type": "Data",
            "visualization": {
                "dashboard": {
                    "columns": 2,
                    "charts": [
 						{
                            "type": "Stacked Bar Chart",
                            "title": "Diagnostic Level Counts - Last Day",
                            "data": {
                                "$ref": "dataDiagnosticLevelCountsOverTime"
                            },
                            "parameters": {
                                "xaxis": "date",
                                "yaxis": "count",
                                "categories": "diagnosticLevel"
                            }
                        },
 						{
                            "type": "Pie Chart",
                            "title": "Top 10 Messages - Last Day",
                            "data": {
                                "$ref": "dataTop10Msgclassifiers"
                            },
                            "parameters": {
                                "xaxis": "msgclassifier",
                                "yaxis": "count"
                            }
                        },
 						{
                            "type": "Stacked Bar Chart",
                            "title": "Total Error and Severe Diagnostic Levels by DB2 Hostname - Last Day",
                            "data": {
                                "$ref": "dataDiagnosticLevelCountsOverTimeByDBHostname"
                            },
                            "parameters": {
                                "xaxis": "date",
                                "yaxis": "count",
                                "categories": "db2Hostname"
                            }
                        },
 						{
                            "type": "Stacked Bar Chart",
                            "title": "Messages by DB2 Hostname - Last Day",
                            "data": {
                                "$ref": "msgclassifierOverTimeByDBHostname"
                            },
                            "parameters": {
                                "xaxis": "date",
                                "yaxis": "count",
                                "categories": "db2Hostname"
                            }
                        }
                        
                    ]
                }
            }
        }
    }
}
