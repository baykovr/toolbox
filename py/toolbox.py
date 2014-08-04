import os,sys

# All functions return -1 on fail

# System Related
def os_check():
	# Returns os type as string
	# mainly concerned with win/linux
	# otherwise returns unknown
	# add your own others.
	try:
		os = 'unknown'
		if sys.platform == 'win32' or sys.platform == 'win64':
			os = 'win'
		elif sys.platform == "linux" or sys.platform == "cygwin":
			os = 'linux'
		else:
			pass
			# uncomment to return actual os
			os = sys.platform
		return os
	except Exception as e:
		print '[ ! ] in os_check',e
		return -1

def cmd(command,suppress):
	# Note: uses os_check
	#
	# execute a system command
	# suppress True/False
	# if true will suppress command output 
	# by redirecting stdout/stderr
	try:
		redir_method = ''
		if suppress:
			if os_check() == 'win':
				redir_method = '>nul 2>&1'
			elif os_check() == 'linux':
				redir_method = '&>/dev/null'
			else:
				print '[ ! ] in cmd, unknown os cannot redirect stdout/stderr'

		command = command+redir_method
		return os.system(command)
	
	except Exception as e:
		print '[ ! ] in cmd',e
		return -1

# File I/O

def f_addln(filename,line):
	# Note: uses os_check
	# Detects win/linux newline char for you.
	try:
		fp = open(filename,"a")
		
		if os_check() == 'win':
			line = line + '\r\n'

		fp.write(line)
		
		fp.close()
		return 0
	except Exception, e:
		print '[ ! ] in f_addln',e
		return -1

def raw_f_addln(filename,line):
	#
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

def raw_f_as_list(filename):
	# Will not strip newline delimeter
	# Get exact contents
	try:
		line_list = []
		fp = open(filename)
		for line in fp:
			line_list.append(line)
		return line_list
	except Exception, e:
		print '[ ! ] in f_getlist',e
		return -1

# SMTP
def send_sms(number,msg,username,password):
	import smtplib
	server = smtplib.SMTP( "smtp.gmail.com", 587 )
	server.starttls()
	# gmail credentials
	server.login( username, password )
	server.sendmail( username, number, msg)
	server.quit()
	pass

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


print raw_f_as_list('test.txt')