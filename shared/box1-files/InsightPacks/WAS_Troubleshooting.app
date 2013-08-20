{
	"name": "WAS Errors and Warnings Dashboard",
	"description": "Display a dashboard of charts that show WAS errors and warnings",
	"customLogic": {
	    "script": "WASDashboard.py",
	    "description": "View charts based on search results",
	    "parameters": [
	        {
                "name": "search",
                "type": "SearchQuery",
                "value": {
                    "logsources": [
                        {
                            "type": "logSource",
                            "name": "DT_WAS_Systemout"
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
             	"value": "logsourceHostname" 
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
	                        "title": "Error and Warning Counts - Last Day",
	                        "data": {
	                            "$ref": "ErrorsWarningsVsTime"
	                        },
	                        "parameters": {
	                            "xaxis": "date",
	                            "yaxis": "count",
	                            "categories": "severity"
	                        }
	                        
	                    },
	                    {
	                        "type": "Stacked Bar Chart",
	                        "title": "Message Counts - Top 5 over Last Day",
	                        "data": {
	                            "$ref": "MsgclassifierVsTime"
	                        },
	                        "parameters": {
	                            "xaxis": "date",
	                            "yaxis": "count",
	                            "categories": "msgclassifier"
	                        }
	                        
	                    },
	                    {
	                        "type": "Stacked Bar Chart",
	                        "title": "Java Exception Counts - Top 5 over Last Day",
	                        "data": {
	                            "$ref": "ExceptionVsTime"
	                        },
	                        "parameters": {
	                            "xaxis": "date",
	                            "yaxis": "count",
	                            "categories": "javaException"
	                        }
	                        
	                    },
	                    {
	                        "type": "Stacked Bar Chart",
	                        "title": "Error and Warning Total by Hostname - Top 5 over Last Day",
	                        "data": {
	                            "$ref": "ErrorsWarningsByHostname"
	                        },
	                        "parameters": {
	                            "xaxis": "date",
	                            "yaxis": "count",
	                            "categories": "hostname"
	                        }
	                        
	                    },
	                    {
	                        "type": "Stacked Bar Chart",
	                        "title": "Messages by Hostname - Top 5 over Last Day",
	                        "data": {
	                            "$ref": "MsgclassifierByHost"
	                        },
	                        "parameters": {
	                            "xaxis": "date",
	                            "yaxis": "count",
	                            "categories": "hostname"
	                        }
	                        
	                    },
	                    {
	                        "type": "Stacked Bar Chart",
	                        "title": "Java Exception by Hostname - Top 5 over Last Day",
	                        "data": {
	                            "$ref": "ExceptionByHost"
	                        },
	                        "parameters": {
	                            "xaxis": "date",
	                            "yaxis": "count",
	                            "categories": "hostname"
	                        }
	                        
	                    }
	                    
	                ]
	            }
	        }
	    }   
	    
	}
	
}
