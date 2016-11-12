#!/usr/bin/env python3
# Robert A. Baykov <baykovr@gmail.com>
import os
from os.path import expanduser

import sys
import argparse

# repo file
REPO_FILE='~/.gituprc'

def cmd(command):
	os.system(command)

def pcmd(cmd):
	return os.popen(cmd).read()

def flist(filename): 
	try:
		line_list = []
		fp = open(filename)
		for line in fp:
			line = line.strip('\r\n')
			if len(line)>0:
				line_list.append(line)
		return line_list
	except Exception as e:
		print('[erro] in flist',e)

def update(repo):
	print('update')
	cmd('git pull -c '+repo)

def needs_update(repo):
	try:
		COMMITS = pcmd('git -C '+repo+' rev-list HEAD ...origin/master --count')
		if int(COMMITS.strip('\n')) > 0:
			print('[push]',repo)
			return True
		else:
			print('[ ok ]',repo)
			return False
	except Exception as e:
		print(e)
		return

def is_git(repo):
	if os.path.exists(repo+'/.git'):
		return True
	else:
		return False

def update(repo):
	pass

def main():
	parser = argparse.ArgumentParser(description='gitup')
	group  = parser.add_mutually_exclusive_group()
	group.add_argument( '-u',
						'--update',
						help='update repositories which needs it',
						action="store_true")
	arguments = parser.parse_args()

	repos = flist( os.path.expanduser(REPO_FILE) )
	for repo in repos:
		if not os.path.exists(repo):
				print('[erro]',repo,'does not exist.')
		elif not is_git(repo):
				print('[erro]',repo,'is not a valid git repository.')
		else:
			if needs_update(repo):
				if arguments.update:
					update(repo)

if __name__ == "__main__":
	main()