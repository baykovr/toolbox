toolbox
=======

A collection of scripts and snippets.

##### Description

###### scripts

chtitle.sh
     
     change xterm window title

comm-git-authors.py
     
     compare two (local) git repository collaborators, display matches.
     
lid-sleep.sh

     change systemd lid shut behavior in /etc/systemd/logind.conf
     using sed.
     
netiface-share.sh

     configure two network interfaces to share internet connection,
     allowing external client to utilize shared interface.
     
robust-wifi.sh

     set wireless interface options to be (somewhat) more tolerant 
     of poor connections.

template.sh

     script template, collection of common routines such as 
     requiring root, checking for depedencies and parsing arguments.

###### one liners

chshow.sh

     show file persmission octal values.
     
wget-full.sh

     wget a website fully, convert elements for local viewing.

offline-downloader.sh

     same as wget-full except recusivly download all hrefs on site
     and store for offline viewing. 

sschain.sh

     invoke chained ssh command by composing user@host arguments 
     into a long -At string. (e.g. type -At for you).
     
recursive-unzip.sh

     unzip all zip archives in current directory and all child directories.

get-public-ip.sh

     show you public ip address using wget/grpe checkip.dyndns.org 
     (thanks stackoverflow)
