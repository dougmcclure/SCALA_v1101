#
#dailySyslogMessagesProgramNameSeverity.py
#
#v1.0 8/16/13 Initial Version (based on Sachin's work)

import unity

from unity import UnityConnection, get_response_content
from urllib import urlencode
#import simplejson as json

# Try importing the built-in json package (for 2.6 and higher). If that doesn't
# work (Python 2.5 and lower), use simplejson
try:
    import json
except ImportError:
    import simplejson as json


unity_connection = UnityConnection('https://10.10.10.2:9987/Unity/', 'unityadmin', 'unityadmin')
unity_connection.login()

post_data = '{"start":0,"results":100,"filter":{"range":{"timestamp":{"from":"11/08/2013 12:16:22.000 -0400 12:16 PM","to":"16/08/2014 12:16:22.000 -0400 12:16 PM","dateFormat":"dd/MM/yyyy HH:mm:ss.SSS Z"}}},"logsources":[{"type":"logSource","name":"/SyslogDemo1_box1_InsightPack"}],"query":"*","outputTimeZone":"UTC","getAttributes":["timestamp","severity","programName"],"facets":{"timestamp":{"date_histogram":{"field":"timestamp","interval":"day","outputDateFormat":"yyyy-MM-dd\'T\'HH:mm:ssZ","outputTimeZone":"UTC","nested_facet":{"severity":{"terms":{"field":"severity","nested_facet":{"programName":{"terms":{"field":"programName"}}}}}}}}}}'

response_text = get_response_content(unity_connection.post('/query', data=post_data,  content_type='application/json; charset=UTF-8'))
searchresults = json.loads(response_text)

unity_connection.logout()

#Print the JSON to system out
print json.dumps(searchresults, sort_keys=False,indent=4, separators=(',', ': '))
