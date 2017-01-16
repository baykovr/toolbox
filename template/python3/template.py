#!/usr/bin/env python3
import os
import sys
import argparse

def cmd(command):
	os.system(command)

def pcmd(comand):
    return os.popen(command).read()

def perror(msg):
	print('[ ! ] '+msg)
	
def plog(msg):
	print('[...] '+msg)

def main():
	parser = argparse.ArgumentParser(description='template')
	group = parser.add_mutually_exclusive_group()
	group.add_argument( '-t',
						'--template',
						help='argument flag with no value',
						action="store_true")
	arguments = parser.parse_args()
	
	if arguments.template:
		print('flag -t/--template found.')

if __name__ == "__main__":
	main()
