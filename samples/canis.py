#!/usr/bin/env python3
import os
import sys
import json
import argparse

# static configs
RSA_PUB_KEYFILE=os.path.expanduser('~/.ssh/id_rsa.pub')

def cmd(command):
	os.system(command)

def pcmd(comand):
    return os.popen(command).read()

def perror(msg):
	print('[ ! ] '+msg)
	
def plog(msg):
	print('[...] '+msg)

def push_rsa(user,host,keyfile):
	# there are two methods to choose from
	# ssh-copy-id -i ~/.ssh/id_dsa.pub user@host
	# cat ~/.ssh/id_rsa.pub | ssh user@host 'cat >> .ssh/authorized_keys'
	
	# check if public keyfile exists
	# try to push it to the host using method

	if os.path.isfile(keyfile):
		#push_key = "cat "+keyfile+" | ssh "+client+" 'cat >> .ssh/authorized_keys'"
		#if cmd(push_key) != 0:
		#	print "[ ! ] Could not push key to client."
		print('pushing '+keyfile)
	else:
		perror('file not found '+keyfile)


#~def sync_dirs(conf):
	#~print 'syncing...'
	#~for host in conf['hosts']:
		#~for directory in conf['dirs']:
			#~pull = "rsync -avzru "+host+":"+directory+" "+directory
			#~push = "rsync -avzru "+directory+" "+host+":"+directory
			#~print pull
			#~cmd(pull)
			#~print push
			#~cmd(push)


#~def load_hosts():
	#~conf = {'hosts':[],'dirs':[],'progs':[]}
	#~try:
		#~# Load from file
		#~conf_file = open('confs/canis.rc','r')
		#~for line in conf_file:
			#~line = line.strip('\n\r')
			#~if len(line) > 0:
				#~if line[0] == '#':
					#~# Comment
					#~pass
				#~else:
					#~line = line.split(' ')
					#~if line[0] == 'host':
						#~conf['hosts'].append(line[1])
					#~elif line[0] == 'dir':
						#~conf['dirs'].append(line[1])
					#~elif line[0] == 'prog':
						#~conf['progs'].append(line[1])
					#~else:
						#~pass #unrelated line
		#~conf_file.close()
		#~return conf
	#~except Exception as e:
		#~print '[ ! ]',e
		#~return -1


def main():
	push_rsa('user','host',RSA_PUB_KEYFILE)
	#~parser = argparse.ArgumentParser(description='canis')
	#~group = parser.add_mutually_exclusive_group()
	#~group.add_argument( '-s',
						#~'--sync',
						#~help='sync both directories (no deletion)',
						#~action="store_true")
	#~arguments = parser.parse_args()

if __name__ == "__main__":
	main()
