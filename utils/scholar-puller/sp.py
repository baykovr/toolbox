#!/usr/bin/env python2

import urllib2,re,argparse,os,sys
from urlparse import urlparse

#--toolbox
def raw_f_addln(filename,line):
	# Don't forget to add \r\n in windows
	# ex'line\r\n'
	try:
		fp = open(filename,"a")
		fp.write(line)
		fp.close()
		return 0
	except Exception, e:
		print '[ ! ] in f_addln',e
		return -1
def f_as_list(filename):
	# Note: will strip out new line characters
	# Return file contents as a list
	# each line is a new item 
	try:
		line_list = []
		fp = open(filename)
		for line in fp:
			line = line.strip('\r\n')
			line_list.append(line)
		return line_list
	except Exception, e:
		print '[ ! ] in f_getlist',e
		return -1
#--/toolbox

#--URL&WEB
def scholar_query(title):
	# scholar is actually really good at handling exacts
	# passing by title is usually sufficient
	prefix = 'http://scholar.google.com/scholar?q='
	# keywords must be broken by +'s
	title_list = title.split(" ")
	for item in title_list:
		prefix+=("+"+item)
	return prefix	
	# OR
	#return prefix+title

def query_web(query):
	# note: scholar will block some user-agents, ie wget
	req = urllib2.Request(query, headers={ 'User-Agent': 'Mozilla/5.0' })
	html = urllib2.urlopen(req).read()
	return html

def parse_pdfurl(html):
	# returns [] of url's
	pdf_urls = re.findall(r'(http?://\S+\.pdf)', html)
	return pdf_urls
#--/URL&WEB

if __name__ == "__main__":
	parser = argparse.ArgumentParser(description='ScholarPuller (lu 04.07.2015)')
	
	actions = parser.add_mutually_exclusive_group()
	actions.add_argument("-t","--title", type=str,help='Retrieve pdf url from query.')
	parser.add_argument("-f","--format",help="Format output as js object.",action="store_true")
	arguments = parser.parse_args()

	if arguments.title != None:
		try:
			first_url = parse_pdfurl( query_web( scholar_query(arguments.title) ) )[0]
			if arguments.format:
				# papers.push(new Paper("Conference","Year","Title","Url","Description));
				# The format I use on my website
				js = "papers.push(new Paper(\"C\",\"Y\",\""+arguments.title+"\",\""+first_url+"\",\"Your Description\"));"
				print js
			else:
				print first_url
		except Exception as err:
			print err
	else:
		print 'ScholarPuller (lu 04.07.2015) \n -h or --help for help'
