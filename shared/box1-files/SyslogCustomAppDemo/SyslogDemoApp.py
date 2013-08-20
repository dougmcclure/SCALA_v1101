#
#SyslogDemoApp.py
#
#v1.0 8/16/13 Initial Version (based on geetha's work)

from datetime import datetime, date, time, timedelta
import CommonAppMod
import sys
from unity import UnityConnection, get_response_content
try:
 	import json
except ImportError:
	import simplejson as json
	
##################################################
# getSearchData	
####################################################
def getSearchData(logsource, filter, query, sortKey, getAttributes, facets):
	if 'relativeTimeInterval' in filter['range']['timestamp']:
		timeInterval = filter['range']['timestamp']['relativeTimeInterval']
		toTimestamp = datetime.utcnow()
		fromTimestamp = toTimestamp - CommonAppMod.getRelativeTimeInterval(timeInterval)
		# Format the timestamp
		toFormatted = CommonAppMod.formatTimestamp(toTimestamp)
		fromFormatted = CommonAppMod.formatTimestamp(fromTimestamp)
		timestamp = {
		  "from":fromFormatted,
		  "to":toFormatted,
		  "dateFormat":"MM/dd/yyyy HH:mm:ss.SSS Z"
		}
		#filter['range'] = {"timestamp":{"from":"' + fromFormatted + '","to":"' + toFormatted + '","dateFormat":"MM/dd/yyyy HH:mm:ss.SSS Z"}}
		filter['range']['timestamp'] = timestamp;
                #print filter['range'];

	request = { 
	  "start":0,
	  "results":1,
	  "filter":filter,
	  "logsources":logsource,
	  "query":query,
	  "sortKey":sortKey,
	  "getAttributes":getAttributes,
	  "facets":facets
	 }

	#inputStr = json.dumps(request, sort_keys=False, indent=4, separators = (',',': '))
        #print inputStr
 		
	response = connection.post('/Search', json.dumps(request), content_type='application/json; charset=UTF-8');
	content = get_response_content(response)
	
	data={}
	try:
		data=json.loads(content)
	except:
		pass
	if 'result' in data:
		result = data['result']
		if 'status' in result and result['status'] == 'failure':
			msg = result['message']
			print >> sys.stderr, msg
			sys.exit(1)
	return data
						 		
##########################################
# datesort()
###########################################
def dateSort(dateFacet):
	def parseDate(dateLabel):
		aDate = map(int, dateLabel.split(" ")[0].split("-"))
		aDate.reverse()
		return aDate
	
	dateFacet.sort(lambda facet1, facet2: cmp(parseDate(facet1['label']), parseDate(facet2['label'])))
	return dateFacet
		
#---------------------------------------------
# Main script starts here
#---------------------------------------------
						 		
baseurl = 'https://localhost:9987/Unity'

connection = UnityConnection(baseurl,'unityadmin','unityadmin')
connection.login()
filter = {}
logsource = {}
chartdata = []

if len(sys.argv) > 1:
	filename = str(sys.argv[1]);
	fk = open(filename, "r")
	data = json.load(fk)
	
	#inputStr = json.dumps(data, sort_keys=False, indent=4, separators = (',',': '))
        #print inputStr
	
        parameters = data['parameters']
	for i in parameters:
		if i['name'] == 'search':
			search = i['value']
			for key in search.keys():
				if key == 'filter':
					filter = search['filter']
				elif key == 'logsources':
					logsource = search['logsources']
				elif key == 'query':
					query = search['query']
				elif key == 'sortKey':
					sortKey = search['sortKey']
				elif key == 'getAttributes':
					getAttributes = search['getAttributes']
				elif key == 'facets':
					facets = search['facets']
				elif key == 'fields':
					fields = search['fields']
                                elif key == 'chartid':
                                        chartid = search['chartid']
				
		rows = []
	
		data = getSearchData(logsource, filter, query, sortKey, getAttributes, facets)
	
 		#outputStr = json.dumps(data, sort_keys=False, indent=4, separators = (',',': '))
		#print outputStr
		if 'facetResults' in data:
			facetResults = data['facetResults']
			if 'dateFacet' in facetResults:
				dateFacet = facetResults['dateFacet']
        
                        	#outputStr = json.dumps(dateFacet, sort_keys=False, indent=4, separators = (',',': '))
                        	#print outputStr
                        	#print "---------------"
				dateSort(dateFacet)
                        	#outputStr = json.dumps(dateFacet, sort_keys=False, indent=4, separators = (',',': '))
                        	#print outputStr
                        	#print "---------------"
				for dateRow in dateFacet:
					for msgRow in dateRow['nested_facet']['dlFacet']['counts']:
						rows.append({"date":dateRow['low'], fields[1]['id']:msgRow['term'],"count":msgRow['count']});
				
		chartdata.append({'id':chartid,'fields':fields,'rows':rows })

	connection.logout()			
	appData = {'data':chartdata}
	resultStr = json.dumps(appData, sort_keys=False, indent=4, separators = (',',': '))
	print resultStr
	
