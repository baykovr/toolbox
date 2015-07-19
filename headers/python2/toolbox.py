#!/usr/bin/env python2
# Code snippets for various little things.
import os,sys

# syscalls
# an alias, writes to stdout
def cmd(command):
	os.system(command)
# returns stdout
def cmd_pipe(comand):
    return os.popen(command).read()

# To suppres output append to command prior to sys call
	# on win   '>nul 2>&1'
	# on linux '&>/dev/null'

# File I/O
# Note: uses os_check
# Detects win/linux newline char for you.
def f_addln(filename,line):
	try:
		fp = open(filename,"a")
		if os_check() == 'win':
			line = line + '\r\n'
		fp.write(line)
		fp.close()
		return 0
	except Exception, e:
		print '[erro] in f_addln',e

# Don't forget to add \r\n in windows
# ex'line\r\n'
def f_addln_raw(filename,line):
	try:
		fp = open(filename,"a")
		fp.write(line)
		fp.close()
		return 0
	except Exception, e:
		print '[erro] in f_addln',e

# Note: will strip out new line characters
# Return file contents as a list
# each line is a new item
def f_as_list(filename): 
	try:
		line_list = []
		fp = open(filename)
		for line in fp:
			line = line.strip('\r\n')
			line_list.append(line)
		return line_list
	except Exception, e:
		print '[erro] in f_getlist',e

# Will not strip newline delimeter
# Get exact contents
def f_as_list_raw(filename):
	try:
		line_list = []
		fp = open(filename)
		for line in fp:
			line_list.append(line)
		return line_list
	except Exception, e:
		print '[erro] in f_getlist',e

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

# Templates
# def os_template():
# 	try:
# 		os = 'unknown'
# 		if sys.platform == 'win32' or sys.platform == 'win64':
# 			os = 'win'
# 		elif sys.platform == "linux":
# 			os = 'linux'
# 		else:
# 			os = sys.platform
# 		return os
# 	except Exception as e:
# 		print '[erro] in os_check',e