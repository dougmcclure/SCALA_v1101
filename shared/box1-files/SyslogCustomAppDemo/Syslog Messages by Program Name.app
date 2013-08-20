{
	"name": "Syslog Insight Pack Demo Sample App",
	"description": "Display various charts using data from Syslog Insight Pack",
	"customLogic": {
	    "script": "dailySyslogMessagesProgramName.py",
	    "description": "View charts based on Syslog Insight Pack search results",
	    "parameters": [
	        {
                "name": "search",
                "type": "SearchQuery",
                "value": {
                    "logsources": [
                        {
                            "type": "logSource",
                            "name": "SyslogDemo1_box1_InsightPack"
                        }
                    ] 
                }
            }            
	    ],
	    "output": {
	        "type": "Data",
	        "visualization": {
	            "dashboard": {
	                "columns": 2,
	                "charts": [
	                    	{
	                        "type": "Bubble Chart",
	                        "title": "Hourly Syslog Messages by Program Name",
	                        "data": {
	                            "$ref": "programName"
	                        },
	                        "parameters": {
	                            "xaxis": "timestamp",
	                            "yaxis": "programName",
								"size": "count"
	                        }
	                        
	                    },
						{
	                        "type": "Heat Map",
	                        "title": "Hourly Syslog Messages by Program Name",
	                        "data": {
	                            "$ref": "programName"
	                        },
	                        "parameters": {
	                            "xaxis": "timestamp",
	                            "yaxis": "programName",
								"category": "count"
	                        }
	                        
	                    },
						{
	                        "type": "Stacked Line Chart",
	                        "title": "Hourly Syslog Messages by Program Name",
	                        "data": {
	                            "$ref": "programName"
	                        },
	                        "parameters": {
	                            "xaxis": "timestamp",
	                            "yaxis": "count",
								"categories": "programName"
	                        }
	                        
	                    }
	                ]
	            }
	        }
	    }   
	    
	}
	
}
