{
    "name": "SyslogInsightPackDemo",
    "description": "Displays demo charts using structured data from SyslogInsightPack",
    "customLogic": {
        "script": "SyslogDemoApp.py",
        "description": "Syslog Message Trend by Severity",
        "parameters": [
         	{
                "name": "search",
                "type": "SearchQuery",
                "value": {
                    "filter": {
                        "range": {
                            "timestamp": {
				"relativeTimeInterval":"LastHour"
                            }
                        }
                    },
                    "logsources": [
                        {
                            "type": "logSource",
                            "name": "SyslogDemo1_box1_InsightPack"
                        }
                    ],
                    "query": "*",
                    "sortKey": [
                        "-timestamp"
                    ],
                    "getAttributes": [
                        "timestamp",
                        "programName"
                    ],
                    "facets": {
                        "dateFacet": {
                            "date_histogram": {
                                "field": "timestamp",
                                "interval": "minute",
                                "outputDateFormat": "MM/dd/yyyy HH:mm:ss Z",
                                "nested_facet": {
                                    "dlFacet": {
                                        "terms": {
                                            "field": "programName"
                                        }
                                    }
                                }
                            }
                        }
                    },
                    "fields": [
                        {
                            "id": "date",
                            "label": "Timestamp",
                            "type": "DATE"
                        },
                        {
                            "id": "programName",
                            "label": "Program Name",
                            "type": "TEXT"
                        },
                        {
                            "id": "count",
                            "label": "count",
                            "type": "LONG"
                        }
                    ],
                    "chartid": "HourlySyslogMessagesByProgramName"
                }
            },
			{
                "name": "search",
                "type": "SearchQuery",
                "value": {
                    "filter": {
                        "range": {
                            "timestamp": {
				"relativeTimeInterval":"LastDay"
                            }
                        }
                    },
                    "logsources": [
                        {
                            "type": "logSource",
                            "name": "SyslogDemo1_box1_InsightPack"
                        }
                    ],
                    "query": "*",
                    "sortKey": [
                        "-timestamp"
                    ],
                    "getAttributes": [
                        "timestamp",
                        "programName"
                    ],
                    "facets": {
                        "dateFacet": {
                            "date_histogram": {
                                "field": "timestamp",
                                "interval": "hour",
                                "outputDateFormat": "MM/dd/yyyy HH:mm:ss Z",
                                "nested_facet": {
                                    "dlFacet": {
                                        "terms": {
                                            "field": "programName"
                                        }
                                    }
                                }
                            }
                        }
                    },
                    "fields": [
                        {
                            "id": "date",
                            "label": "Timestamp",
                            "type": "DATE"
                        },
                        {
                            "id": "programName",
                            "label": "Program Name",
                            "type": "TEXT"
                        },
                        {
                            "id": "count",
                            "label": "count",
                            "type": "LONG"
                        }
                    ],
                    "chartid": "DailySyslogMessagesByProgramName"
                }
            },
			{
                "name": "search",
                "type": "SearchQuery",
                "value": {
                    "filter": {
                        "range": {
                            "timestamp": {
				"relativeTimeInterval":"LastWeek"
                            }
                        }
                    },
                    "logsources": [
                        {
                            "type": "logSource",
                            "name": "SyslogDemo1_box1_InsightPack"
                        }
                    ],
                    "query": "*",
                    "sortKey": [
                        "-timestamp"
                    ],
                    "getAttributes": [
                        "timestamp",
                        "programName"
                    ],
                    "facets": {
                        "dateFacet": {
                            "date_histogram": {
                                "field": "timestamp",
                                "interval": "day",
                                "outputDateFormat": "MM/dd/yyyy HH:mm:ss Z",
                                "nested_facet": {
                                    "dlFacet": {
                                        "terms": {
                                            "field": "programName"
                                        }
                                    }
                                }
                            }
                        }
                    },
                    "fields": [
                        {
                            "id": "date",
                            "label": "Timestamp",
                            "type": "DATE"
                        },
                        {
                            "id": "programName",
                            "label": "Program Name",
                            "type": "TEXT"
                        },
                        {
                            "id": "count",
                            "label": "count",
                            "type": "LONG"
                        }
                    ],
                    "chartid": "WeeklySyslogMessagesByProgramName"
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
                            "type": "Stacked Bar Chart",
                            "title": "Hourly (by Minute) Syslog Messages by Program Name",
                            "data": {
                                "$ref": "HourlySyslogMessagesByProgramName"
                            },
                            "parameters": {
                                "xaxis": "date",
                                "yaxis": "count",
                                "categories": "programName"
                            }
                        },
						{
                            "type": "Stacked Bar Chart",
                            "title": "Daily (by Hour) Syslog Messages by Program Name",
                            "data": {
                                "$ref": "DailySyslogMessagesByProgramName"
                            },
                            "parameters": {
                                "xaxis": "date",
                                "yaxis": "count",
                                "categories": "programName"
                            }
                        },
						{
                            "type": "Stacked Bar Chart",
                            "title": "Weekly (by Day) Syslog Messages by Program Name",
                            "data": {
                                "$ref": "WeeklySyslogMessagesByProgramName"
                            },
                            "parameters": {
                                "xaxis": "date",
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
