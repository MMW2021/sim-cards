#!/bin/bash
# sim networking install script for signifier pis

#  install ppp if it's not already installed.
echo "Installing PPP\n"
sudo apt install ppp -y


# save ppp conf file to /etc/ppp/peers/gprs
echo "installing PPP conf file to /etc/ppp/peers/gprs\n"
cat << EOF > /etc/ppp/peers/gprs
/dev/ttyUSB2 115200
# The chat script
connect 'chat -s -v -f /etc/chatscripts/chat-connect -T mdata.net.au'
# The close script
disconnect 'chat -s -v -f /etc/chatscripts/chat-disconnect'
# Hide password in debug messages
user ""
password ""
hide-password
# The phone is not required to authenticate
noauth
persist
# Debug info from pppd
debug
# If you want to use the HSDPA link as your gateway
#defaultroute
# pppd must not propose any IP address to the peer
noipdefault
# No ppp compression
#novj
#novjccomp
#noccp
#ipv6 ::
ipv6cp-accept-local
#ipv6cp-accept-local
#ipv6cp-accept-remote
#+ipv6
#ipv6cp-use-ipaddr
local
# For sanity, keep a lock on the serial line
lock
modem
dump
updetach
# Hardware flow control
nocrtscts
remotename 3gppp
ipparam 3gppp
ipcp-max-failure 30
# Ask the peer for up to 2 DNS server addresses
usepeerdns
EOF
ls /etc/ppp/peers/gprs
# save chat-connect script to /etc/chatscripts/chat-connect
echo "saving chat connect script to /etc/chat-connect\n"
cat << EOF > /etc/chatscripts/chat-connect
ABORT "BUSY"
ABORT "NO CARRIER"
ABORT "NO DIALTONE"
ABORT "ERROR"
ABORT "NO ANSWER"
TIMEOUT 60
"" AT
OK AT
OK AT+CPIN?
OK AT+CSQ
OK AT+CREG?
OK AT+CGREG?
OK AT+COPS?
OK AT+CGDCONT=1,"IP","\T"
OK ATD*99#
CONNECT
EOF
ls /etc/chatscripts/chat-connect


# send the chat-disconnect script to etc
echo "saving chat-disconnect scripts to /etc/chatscripts/chat-disconnect\n"
cat << EOF > /etc/chatscripts/chat-disconnect
ABORT "ERROR"
ABORT "NO DIALTONE"
SAY "\nSending break to the modem\n"
""  +++
""  +++
""  +++
SAY "\nGoodbye\n"
EOF
ls /etc/chatscripts/chat-disconnect
#send the .service file to systemd
echo "installing simppp systemd service"
cat << EOF > /etc/systemd/system/simppp.service
[Unit]
Description=PPP Service for Aldimobile sim
[Service]
Type=idle
ExecStart=/usr/sbin/pppd call gprs
Restart=always
[Install]
WantedBy=multi-user.target
Alias=simppp.service
EOF
ls /etc/systemd/system/simpp.service
echo "done...to test run:\n"
echo "sudo pppd call gprs"
