#!/bin/bash
# Reload a varnish config
# Author: Kristian Lyngstol
 
FILE="/usr/local/Cellar/varnish/2.1.4/etc/varnish/default.vcl"
 
# Hostname and management port
# (defined in /etc/default/varnish or on startup)
HOSTPORT="localhost:8081"
NOW=`date +%s`
 
error()
{
    echo 1>&2 "Failed to reload $FILE."
    exit 1
}
 
varnishadm -T $HOSTPORT vcl.load reload$NOW $FILE || error
varnishadm -T $HOSTPORT vcl.use reload$NOW || error
echo Current configs:
varnishadm -T $HOSTPORT vcl.list
