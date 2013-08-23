{
    "name": "Syslog Insight Pack Demo App",
    "description": "Displays visualizations of data from the Syslog Insight Pack",
    "customLogic": {
        "script": "SyslogInsightDemo.py",
        "description": "Hourly Syslog Message Trend by Severity",
        "parameters": [
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
                    "outputTimeZone": "UTC",
                    "getAttributes": [
                        "timestamp",
                        "severity"
                    ],
                    "facets": {
                        "dateFacet": {
                            "date_histogram": {
                                "field": "timestamp",
                                "interval": "minute",
                                "outputDateFormat": "yyyy-MM-dd\'T\'HH:mm:ssZ",
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
                    "outputTimeZone": "UTC",
                    "getAttributes": [
                        "timestamp",
                        "programName"
                    ],
                    "facets": {
						"timestamp": {
							"date_histogram": {
								"field": "timestamp",
								"interval": "minute",
								"outputDateFormat": "yyyy-MM-dd'T'HH:mm:ssZ",
								"outputTimeZone": "UTC",
								"nested_facet": {
									"programName": {
										"terms": {
											"field": "programName"
										}
									}
								}
							}
						}
					},
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
                    "outputTimeZone": "UTC",
                    "getAttributes": [
                        "timestamp",
                        "severity"
                    ],
                    "facets": {
                        "dateFacet": {
                            "date_histogram": {
                                "field": "timestamp",
                                "interval": "hour",
                                "outputDateFormat": "yyyy-MM-dd\'T\'HH:mm:ssZ",
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
                    "chartid": "dailySyslogMessagesBySeverity"
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
                    "outputTimeZone": "UTC",
                    "getAttributes": [
                        "timestamp",
                        "programName"
                    ],
                    "facets": {
						"timestamp": {
							"date_histogram": {
								"field": "timestamp",
								"interval": "hour",
								"outputDateFormat": "yyyy-MM-dd'T'HH:mm:ssZ",
								"outputTimeZone": "UTC",
								"nested_facet": {
									"programName": {
										"terms": {
											"field": "programName"
										}
									}
								}
							}
						}
					},
                    "chartid": "dailySyslogMessagesByProgramName"
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
                            "title": "Syslog Messages by Severity",
                            "data": {
                                "$ref": "HourlySyslogMessagesBySeverity"
                            },
                            "parameters": {
                                "xaxis": "timestamp",
                                "yaxis": "count",
                                "categories": "severity"
                            }
                        },
						{
	                        "type": "Stacked Line Chart",
	                        "title": "Syslog Messages by Program Name",
	                        "data": {
	                            "$ref": "HourlySyslogMessagesByProgramName"
	                        },
	                        "parameters": {
	                            "xaxis": "timestamp",
	                            "yaxis": "count",
								"categories": "programName"
	                        }
	                        
	                    },
						{
                            "type": "Stacked Line Chart",
                            "title": "Hourly Syslog Messages by Severity",
                            "data": {
                                "$ref": "dailySyslogMessagesBySeverity"
                            },
                            "parameters": {
                                "xaxis": "timestamp",
                                "yaxis": "count",
                                "categories": "severity"
                            }
                        },
						{
	                        "type": "Stacked Line Chart",
	                        "title": "Hourly Syslog Messages by Program Name",
	                        "data": {
	                            "$ref": "dailySyslogMessagesByProgramName"
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