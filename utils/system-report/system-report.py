#!/usr/bin/env python2

import os
import sys
import smtplib


# configs
SMTP_DEST     = 'smtp.gmail.com'
SMTP_PORT     =  587
USER_GMAIL    = 'SECRET_SRC_ADDR@gmail.com'
USER_GPASS    = 'SECRET_PASSWORD'

# email params.
EMAIL_FROM    =  USER_GMAIL
EMAIL_TO      = 'DESTINATION@anywhere.com'
EMAIL_SUBJECT = 'SYSTEM-REPORT'

def pipe_cmd(command):
	return os.popen(command).read()

def send_sms(number,msg,username,password):
	server = smtplib.SMTP( SMTP_DEST, SMTP_PORT)
	server.starttls()
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

	server = smtplib.SMTP(SMTP_DEST, SMTP_PORT)
	server.ehlo()
	server.starttls()
	server.ehlo()
	server.login(username, password)
	text = msg.as_string()
	server.sendmail(fromaddr, toaddr, text)

if __name__ == "__main__":
        report = ''
	seperator = '-'*60+'\n'
	
	host = pipe_cmd('hostname')
	date = pipe_cmd('date')
	thermal = pipe_cmd('sensors')
	network = pipe_cmd('nmap -T3  192.168.1.0/24')

	report  = seperator
	report += '[START-REPORT]\n'
	report += host
	report += date 
	report += seperator 

	report += '[THERMAL]\n'
	report += thermal
	report += seperator 

	report += '[NETWORK]\n'
	report += network
	report += seperator
	report += '[END-REPORT]\n'

	send_mail(EMAIL_FROM,EMAIL_TO,EMAIL_SUBJECT,report,USER_GMAIL,USER_GPASS)
