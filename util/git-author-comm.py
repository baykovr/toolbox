#!/usr/bin/env python 

# Display authors which appear as contributors in both (two) repositories.


import os,sys

def usage():
	print 'Show authors which appear in two git repositories.'
	print 'python2 git-author-comm.py [path-to-git-repo] [path-to-git-repo]'

def sysout(command):
	return os.popen(command).read()

def get_authors(git):
	cmd = "git --work-tree="+git+" --git-dir="+git+"/.git log --format='%aN' | sort -u"
	# Split results to a list.
	authors = sysout(cmd).split('\n')
	# Remove any empty lines prior to return.
	return filter(None, authors)

def get_same_authors(a1,a2):
	# Return a set of authors which appear in both repositories.
	return set(a1).intersection(a2)

if __name__ == "__main__":
	if len(sys.argv) != 3:
		usage()
	else:
		git1 = sys.argv[1]
		git2 = sys.argv[2]
		
		authors = get_same_authors(get_authors(git1),get_authors(git2))
		if len(authors) == 0:
			print 'There are no matches.'
		else:
			print 'The folowing appear in both repositories: '
			for author in authors:
				print author
					