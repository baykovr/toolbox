#!/usr/bin/env python2

def check_os():
	#--OS CHECK--
	os = 'unknown'
	print "Platform: ",sys.platform
	if sys.platform == 'win32' or sys.platform == 'win64':
		os = 'win'
	elif sys.platform == "linux" or sys.platform == "cygwin":
		os = 'linux'
	else:
		print "some other sys"
	return os

def cmd(cmd):
	print 'Trying to exec:',cmd
	try:
		suppression = "&>/dev/null"
		return os.system(cmd)
	except Exception as e:
		print   e
		return -1

def send_sms(number,msg):
	server = smtplib.SMTP( "smtp.gmail.com", 587 )
	#server.starttls()
	#server.login( 'secret_gmail@gmail.com', 'secret_pass' )
	#server.sendmail( 'user', number, msg)
	#server.quit()
	pass

def push_rsa(conf):
	keyfile = '~/.ssh/id_rsa.pub'
	if not os.path.isfile(keyfile):
		#format: cat ~/.ssh/id_rsa.pub | ssh user@hostname 'cat >> .ssh/authorized_keys'
		push_key = "cat "+keyfile+" | ssh "+client+" 'cat >> .ssh/authorized_keys'"
		if cmd(push_key) != 0:
			print "[ ! ] Could not push key to client."
	else:
		print "[ ! ]Missing",keyfile,"you should generate it."

def sync_dirs(conf):
	print 'syncing...'
	for host in conf['hosts']:
		for directory in conf['dirs']:
			pull = "rsync -avzru "+host+":"+directory+" "+directory
			push = "rsync -avzru "+directory+" "+host+":"+directory
			print pull
			cmd(pull)
			print push
			cmd(push)

def load_conf():
	conf = {'hosts':[],'dirs':[],'progs':[]}
	try:
		# Load from file
		conf_file = open('confs/canis.rc','r')
		for line in conf_file:
			line = line.strip('\n\r')
			if len(line) > 0:
				if line[0] == '#':
					# Comment
					pass
				else:
					line = line.split(' ')
					if line[0] == 'host':
						conf['hosts'].append(line[1])
					elif line[0] == 'dir':
						conf['dirs'].append(line[1])
					elif line[0] == 'prog':
						conf['progs'].append(line[1])
					else:
						pass #unrelated line
		conf_file.close()
		return conf
	except Exception as e:
		print '[ ! ]',e
		return -1

if __name__ == "__main__":
	crit_err = Exception('[ ! ] Critical error, exiting.')
	try:
		import sys,os,argparse,smtplib

		# Check os
		# os = check_os()
		# Args
		parser = argparse.ArgumentParser(description='Canis')
		group = parser.add_mutually_exclusive_group()
		group.add_argument('-s','--sync',help='sync both directories (no deletion)',action="store_true")
		arguments = parser.parse_args()

		if arguments.sync:
			# Load config
			conf = load_conf()
			if conf == -1:
				raise crit_err
			sync_dirs(conf)
		else:
			print 'nothing to do.'

	except Exception, e:
		print e
		exit(1)
