{
	"name": "Syslog Insight Pack Demo Sample App",
	"description": "Display various charts using data from Syslog Insight Pack",
	"customLogic": {
	    "script": "dailySyslogMessagesProgramNameSeverity.py",
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
	                        "type": "Tree Map",
	                        "title": "Daily Syslog Messages by Program Name and Severity",
	                        "data": {
	                            "$ref": "timestamp"
	                        },
	                        "parameters": {
	                            "level1": "timestamp",
	                            "level2": "severity",
								"level3": "programName",
								"value":  "count"
	                        }
	                        
	                    }
	                ]
	            }
	        }
	    }   
	    
	}
	
}
