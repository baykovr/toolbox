#!/usr/bin/env python2
# Code snippets for various little things.
import os,sys

# syscalls
# an alias, writes to stdout
# @ret : nothing
def cmd(command):
	os.system(command)

# @ret : string
def pcmd(cmd):
	return os.popen(cmd).read()

# Note on using relative to $HOME variable files
#from os.path import expanduser
#some_file=os.path.expanduser('~/somefile')

#if not os.path.exists(directory):
#	os.makedirs(directory)

# note : To suppres output append to command prior to sys call
# 	on win   '>nul 2>&1'
#	on linux '&>/dev/null'

# File I/O
# Note: uses os_check.
# 	Detects win/linux newline char for you.
def f_addln(filename,line):
	try:
		fp = open(filename,"a")
		if os_check() == 'win':
			line = line + '\r\n'
		fp.write(line)
		fp.close()
		return 0
	except Exception as e:
		print('[erro] in f_addln',e)

# Don't forget to add \r\n in windows.
# ex'line\r\n'.
def f_addln_raw(filename,line):
	try:
		fp = open(filename,"a")
		fp.write(line)
		fp.close()
		return 0
	except Exception as e:
		print('[erro] in f_addln',e)

def fstring(filename):
	content = ''
	with open (filename, "r") as fp:
		content=fp.read().replace('\n', '')
	return content
	
# @ret : [string] : file contents as a list, strips new line characters.
# Note: will strip out new line characters.
def flist(filename): 
	try:
		line_list = []
		fp = open(filename)
		for line in fp:
			line = line.strip('\r\n\t\0')
			line_list.append(line)
		return line_list
	except Exception as e:
		print('[erro] in flist',e)

# @ret : [string] : file contents as a list, retains new line characters.
def flist_raw(filename):
	try:
		line_list = []
		fp = open(filename)
		for line in fp:
			line_list.append(line)
		return line_list
	except Exception as e:
		print('[erro] in flist_raw',e)

# @logfile_path : string : name of destiantion logfile, (absolute or relative path).
# @append_mgs : string : contents to write to logfile and stdout.
def log(logfile_path,append_msg):
	# log to file
	with open(LOGFILE, 'a') as f:
		f.write(append_msg+'\n')
	# log to stdout
	print append_ms

# SMTP
def send_sms(number,msg,username,password):
	import smtplib
	server = smtplib.SMTP( "smtp.gmail.com", 587 )
	server.starttls()
	# gmail credentials
	server.login( username, password )
	server.sendmail( username, number, msg)
	server.quit()

def send_mail(fromaddr,toaddr,subject,body,username,password):
	from email.MIMEMultipart import MIMEMultipart
	from email.MIMEText import MIMEText

	msg = MIMEMultipart()
	msg['From']    = fromaddr
	msg['To']      = toaddr
	msg['Subject'] = subject
	msg.attach(MIMEText(body, 'plain'))

	import smtplib
	server = smtplib.SMTP('smtp.gmail.com', 587)
	server.ehlo()
	server.starttls()
	server.ehlo()
	# gmail credentials
	server.login(username, password)
	text = msg.as_string()
	server.sendmail(fromaddr, toaddr, text)