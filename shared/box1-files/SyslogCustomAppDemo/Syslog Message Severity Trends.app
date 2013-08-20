{
    "name": "SyslogInsightPackDemo",
    "description": "Displays demo charts using structured data from SyslogInsightPack",
    "customLogic": {
        "script": "SyslogDemoApp.py",
        "description": "Hourly Syslog Message Trend by Severity",
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
                        "severity"
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
                                            "field": "severity"
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
                            "id": "severity",
                            "label": "Severity",
                            "type": "TEXT"
                        },
                        {
                            "id": "count",
                            "label": "count",
                            "type": "LONG"
                        }
                    ],
                    "chartid": "HourlySyslogMessagesBySeverity"
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
                        "severity"
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
                                            "field": "severity"
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
                            "id": "severity",
                            "label": "Severity",
                            "type": "TEXT"
                        },
                        {
                            "id": "count",
                            "label": "count",
                            "type": "LONG"
                        }
                    ],
                    "chartid": "DailySyslogMessagesBySeverity"
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
                        "severity"
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
                                            "field": "severity"
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
                            "id": "severity",
                            "label": "Severity",
                            "type": "TEXT"
                        },
                        {
                            "id": "count",
                            "label": "count",
                            "type": "LONG"
                        }
                    ],
                    "chartid": "WeeklySyslogMessagesBySeverity"
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
                            "type": "Stacked Line Chart",
                            "title": "Hourly (by Minute) Syslog Messages by Severity",
                            "data": {
                                "$ref": "HourlySyslogMessagesBySeverity"
                            },
                            "parameters": {
                                "xaxis": "date",
                                "yaxis": "count",
                                "categories": "severity"
                            }
                        },
						{
                            "type": "Stacked Line Chart",
                            "title": "Daily (by Hour) Syslog Messages by Severity",
                            "data": {
                                "$ref": "DailySyslogMessagesBySeverity"
                            },
                            "parameters": {
                                "xaxis": "date",
                                "yaxis": "count",
                                "categories": "severity"
                            }
                        },
						{
                            "type": "Stacked Line Chart",
                            "title": "Weekly (by Day) Syslog Messages by Severity",
                            "data": {
                                "$ref": "WeeklySyslogMessagesBySeverity"
                            },
                            "parameters": {
                                "xaxis": "date",
                                "yaxis": "count",
                                "categories": "severity"
                            }
                        }
                    ]
                }
            }
        }
    }
}
