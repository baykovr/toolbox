#system-report

A python script for executing arbitrary system commands and sending the results using email/sms using gmails smtp.

Using cron you can also automate the script to make a simple remote reporting tool.

#Usage

1. Modify src/system-report.py with valid credentials for gmail (username/password)
2. Modify destination email address (EMAIL_TO) and subject
3. *Modify the report code in __src/system-report.py__ to your liking.
4. Make report.sh executable using <code>chmod +x report.sh</code>
5. Schedule report.sh using cron.

### * Modifying
The example code fills out the report string using hostname,date,sensors and nmap (which portscans the local network),

The resulting email looks like this:

	------------------------------------------------------------
	[START-REPORT]
	[REDACTED HOSTNAME]
	Sun Aug  3 22:00:02 CDT 2014
	------------------------------------------------------------
	[THERMAL]
	via686a-isa-6000
	Adapter: ISA adapter
	Vcore:        +1.80 V  (min =  +0.06 V, max =  +3.10 V)
	in1:          +0.24 V  (min =  +0.06 V, max =  +3.10 V)
	+3.3V:        +3.31 V  (min =  +2.98 V, max =  +3.63 V)
	+5V:          +4.98 V  (min =  +4.51 V, max =  +5.50 V)
	+12V:        +11.71 V  (min = +10.81 V, max = +13.20 V)
	fan1:           0 RPM  (min =    0 RPM, div = 2)  ALARM
	fan2:           0 RPM  (min = 10546 RPM, div = 8)
	temp1:        +64.1°C  (high = +146.2°C, hyst = -70.9°C)
	temp2:        +32.6°C  (high = +146.2°C, hyst = -70.9°C)
	temp3:        +21.5°C  (high = -70.9°C, hyst = -70.9°C)  ALARM

	------------------------------------------------------------
	[NETWORK]

	Starting Nmap 6.00 ( http://nmap.org ) at 2014-08-03 22:00 CDT
	Nmap scan report for [REDACTED HOSTNAME] (192.168.1.1)
	Host is up (0.033s latency).
	Not shown: 997 closed ports
	PORT   STATE SERVICE
	23/tcp open  telnet
	53/tcp open  domain
	80/tcp open  http

	Nmap done: 256 IP addresses (2 hosts up) scanned in 3.04 seconds
	------------------------------------------------------------
	[END-REPORT]

Example edit
	# some command
	report = pipe_cmd('some command')
	report+= pipe_cmd('some other command')
	# is some server up?
	report+= pipe_cmd('ping -c 1 example.com')
	
send_mail and sms take a string in body and msg arguments respectively. 



### SMS

Sending an sms is possible if you know the carriers gateway, heres a [list](http://www.emailtextmessages.com/) in most cases its something simple as 10digitphonenumber@txt.att.net , use with caution.

### Schedule  with Cron

example:

You'll need cron and crontab installed:

    crontab -e
    # Append
    0 */1 * * * /home/YOUR_USERNAME/PATH_TO_REPO/report.sh
    # This runs report.sh once every hour
    
For additional help with cron see: [cron examples](http://www.thegeekstuff.com/2011/07/cron-every-5-minutes/)

You should probably modify the cron task to not run so often

    # Every Hour
    0 */1 * * * /home/YOUR_USERNAME/PATH_TO_REPO/report.sh
    # Every 6 Hours
    0 */6 * * * /home/YOUR_USERNAME/PATH_TO_REPO/report.sh
    # etc 
    
### Some ideas for extensions

1. Parse nmaps output to monitor router usage over time.
2. Send a progress report every so often [progress bar](http://www.theiling.de/projects/bar.html)
