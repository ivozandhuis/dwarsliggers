#! /usr/bin/env python3

import requests
import json
import csv

readfile = open('gebpla_std.csv', 'r')
rd = csv.reader(readfile)

writefile = open('gebpla_std_ext.csv', 'w')
wr = csv.writer(writefile, quoting=csv.QUOTE_ALL)

header = {'accept': 'application/json'}

# get
for row in rd:
	uri = row[1]
	print(uri)
	if uri.startswith('http://'):
		# get info - content negotiation
		r = requests.get(uri, headers=header)
		json_data = json.loads(r.text)

		# write data
		data = (row[0],)	
		data = data + (json_data['uri'],)
		data = data + (json_data['name'],)
		data = data + (json_data['amsterdamCode'],)
		data = data + (json_data['inProvince'],)		
		wr.writerow(data)
	else:
		# write data
		data = (row[0],)	
		data = data + (row[1],)
		data = data + ("",)
		data = data + ("",)
		data = data + ("",)		
		wr.writerow(data)
		
writefile.close()
