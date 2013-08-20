######################################################### {COPYRIGHT-TOP} ###
# Licensed Materials - Property of IBM
# "Restricted Materials of IBM"
# 5725-K26
#
# (C) Copyright IBM Corp. 2013  All Rights Reserved.
#
# US Government Users Restricted Rights - Use, duplication, or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
######################################################### {COPYRIGHT-END} ###
import urllib
from datetime import datetime, date, time, timedelta
#import simplejson as json

# Try importing the built-in json package (for 2.6 and higher). If that doesn't
# work (Python 2.5 and lower), use simplejson
try:
    import json
except ImportError:
    import simplejson as json

baseurl = 'https://localhost:9987/Unity'

def getBaseURL():
	return baseurl


def getTimezoneOffset(currentTimestamp):
	hourOffset = (currentTimestamp.hour - 24 - datetime.utcnow().hour)
	if hourOffset >= 0:
		hourOffset = hourOffset % 12
	else:
		hourOffset = hourOffset + 24
	
	minuteOffset = currentTimestamp.minute - datetime.utcnow().minute
	
	if minuteOffset < 0 and hourOffset >=0:
		hourOffset = hourOffset - 1
	if minuteOffset > 0 and hourOffset <= 0:
		hourOffset = hourOffset - 1
	minuteOffset = abs(minuteOffset)
	
	timezoneOffset = ''
	if hourOffset < 0:	
		timezoneOffset = '%(hours)03d%(minutes)02d'% {"hours":hourOffset, "minutes":minuteOffset}
	else:
		timezoneOffset = '+%(hours)02d%(minutes)02d'% {"hours":hourOffset, "minutes":minuteOffset}
	
	return timezoneOffset

# Takes a datetime object and returns in the format MM/dd/yyyy HH:mm:ss.SSS Z
def formatTimestamp(toFormat):
	#return str(toFormat.month) + '/' + str(toFormat.day) + '/' + str(toFormat.year) + ' ' + str(toFormat.hour) + ':' + str(toFormat.minute) + ':' + str(toFormat.second) + '.' + str(toFormat.microsecond / 1000) + ' ' + 	getTimezoneOffset(toFormat)
	return str(toFormat.month) + '/' + str(toFormat.day) + '/' + str(toFormat.year) + ' ' + str(toFormat.hour) + ':' + str(toFormat.minute) + ':' + str(toFormat.second) + '.' + str(toFormat.microsecond / 1000) + ' -0000 '

# Functions to get relative time offsets

def getLastQuarterHour():
	return timedelta(minutes=15)

def getLastHour():
	return timedelta(hours=1)

def getLastDay():
	return timedelta(days=1)

def getLastWeek():
	return timedelta(days=7)

def getLastMonth():
	return timedelta(days=30)

def getLastYear():
	return timedelta(days=365)

def getRelativeTimeInterval(interval):
	delta = None
	if interval == 'LastQuarterHour':
		delta = getLastQuarterHour()
	elif interval == 'LastHour':
		delta = getLastHour()
	elif interval == 'LastDay':
		delta = getLastDay()
	elif interval == 'LastMonth':
		delta = getLastMonth()
	elif interval == 'LastWeek':
		delta = getLastWeek();
	elif interval == 'LastYear':
		delta = getLastYear()
		
	return delta
		
def getParameters(argv):
	logsource = None
	timestamp = None
	timeInterval = None
	timeUnit = 'hour'
	timeUnitFormat = 'yyyy-MM-dd HH:mm'	
	hostnameField = None

	# Get the parameters passed to this script
	if len(argv) > 1:
		filename = str(argv[1])
		fk = open(filename,"r")
		data = json.load(fk)

		parameters = data['parameters']
		for i in parameters:
			if i['name'] == 'search':
				search = i['value']
				for key in search.keys():
					if key == 'filter':
						filter = search['filter']
						if 'range' in filter:
							range = filter['range']
							if 'timestamp' in range:
								timestampParm = range['timestamp']
								timestampStr = json.dumps(timestampParm, sort_keys=False,indent=4, separators=(',', ': '))
								timestamp = '{"timestamp":' + timestampStr + '}'
					elif key == 'logsources':
						logsourcesParm = search['logsources']
						logsource = '"logsources":' + json.dumps(logsourcesParm, sort_keys=False,indent=4, separators=(',', ': '))
			elif i['name'] == "relativeTimeInterval":
				timeInterval = i['value']
			elif i['name'] == 'timeFormat':
				timeFormat = i['value']
				for key in timeFormat.keys():	
					if key == 'timeUnit':
						timeUnit = timeFormat['timeUnit']
					elif key == 'timeUnitFormat':
						timeUnitFormat = timeFormat['timeUnitFormat']	
			elif i['name'] == 'hostnameField':
				hostnameField = i['value']
						
				
	# If timeInterval and timeUnit were passed in as parameters, then calculate that
	if  timeInterval:
		toTimestamp = datetime.utcnow()
		fromTimestamp = toTimestamp - getRelativeTimeInterval(timeInterval)

		# Format the timestamp
		toFormatted = formatTimestamp(toTimestamp)
		fromFormatted = formatTimestamp(fromTimestamp)
		timestamp = '{"timestamp":{"from":"' + fromFormatted + '","to":"' + toFormatted + '","dateFormat":"MM/dd/yyyy HH:mm:ss.SSS Z"}}'
    
	
	# If timestamp was not passed in as a parameter (as an absolute time interval), then a relative timestamp is used
	# The default time interval is "LastDay" 
	if timestamp == None:
		toTimestamp = datetime.now()
		fromTimestamp = toTimestamp - getLastDay()

		# Format the timestamp
		toFormatted = formatTimestamp(toTimestamp)
		fromFormatted = formatTimestamp(fromTimestamp)
		timestamp = '{"timestamp":{"from":"' + fromFormatted + '","to":"' + toFormatted + '","dateFormat":"MM/dd/yyyy HH:mm:ss.SSS Z"}}'

	parms = {}
	parms['logsource'] = logsource
	parms['timestamp'] = timestamp
	parms['timeInterval'] = timeInterval
	parms['timeUnit'] = timeUnit
	parms['timeUnitFormat'] = timeUnitFormat
	parms['hostnameField'] = hostnameField
    
	return parms

#------------------------------------------------------
# dateSort - performs an in-place sort of a dateFacet in the format described below.
# 	It sorts on the label field, which is a UTC timestamp to the granularity
#   of the requested timeUnit.  It's format is "mm-hh-DDD-yyyy UTC"
#   The mm or hh may be left off, depending on the granularity of the timeUnit.
# [
#		{
#			"high": "2012-07-06 22:10",
#			"count": 10,
#			"nested_facet": {
#				"dlFacet": {
#					"counts": [
#						{
#							"count": 10,
#							"term": "Warning"
#						}
#					],
#					"total": 1
#				}
#			},
#			"low": "2012-07-06 22:09",
#			"label": "9-22-188-2012 UTC"
#		},
# 	    etc...
# ]
#------------------------------------------------------
def dateSort(dateFacet):
	# This function parses the UTC label in the format "mm-hh-DDD-yyyy UTC"
	# and returns an array in the form [yyyy, DD, hh, mm]
	def parseDate(dateLabel):
		aDate = map(int, dateLabel.split(" ")[0].split("-"))
		aDate.reverse()
		return aDate
	
	# call an in-place List sort, using an anonymous function lambda as the sort function
	dateFacet.sort(lambda facet1, facet2: cmp(parseDate(facet1['label']), parseDate(facet2['label'])))
	return dateFacet
			

