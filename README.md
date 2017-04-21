# check_BIRD_BGP_protocols

Nagios check for BGP protocols of BIRD routing daemon

Nagios check v1.0

Basic usage: ./check_BIRD_BGP_protocols-p IPv6

-p Sets process check for given protocol: IPv4 or IPv6

-h Displays this help message

Author: Rafal Dwojak, rafal@dwojak.com

Installation as NRDP check:

cd /tmp wget --no-check-certificate -O linux-general.tar.gz "https://<your_nagios_instance>/nrdp/?cmd=nrdsgetclient&token=<your_token&configname=linux-general"

gunzip -c linux-general.tar.gz | tar xf -

cd clients

HOSTNAME - The name the client will send to the Nagios server as the host.

INTERVAL - The frequency in minutes that you want the checks to be run. (1-59)

./installnrds HOSTNAME INTERVAL

View: crontab -u nagios -l

*/5 * * * * /usr/local/nrdp/clients/nrds/nrds.pl -H 'HOSTNAME' > /dev/null 2>&1\n

Edit and remove \n:

crontab -u nagios -e

*/5 * * * * /usr/local/nrdp/clients/nrds/nrds.pl -H 'HOSTNAME' > /dev/null 2>&1

To automatically insert hostname:

crontab -u nagios -e

/usr/local/nrdp/clients/nrds/nrds.pl -H $(hostname) > /dev/null 2>&1

visudo

nagios ALL=(root) NOPASSWD:/usr/local/nagios/libexec/check_BIRD_BGP_protocols

vi /usr/local/nrdp/clients/nrds/nrds.cfg

command[Check BIRD]=/usr/bin/sudo /usr/local/nagios/libexec/check_BIRD_BGP_protocols -p IPv4

