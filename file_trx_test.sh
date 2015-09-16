#!/bin/bash

#valid script options
VALID_OPTS="sc:"

#unique port
PORT=22122

#usage message
USAGE_MSG="Usage: $0 [OPTIONS]\n"\
"\nAvailable OPTIONS are the following ones:\n"\
"    -s	Runs as Server, just listen waiting for client side\n"\
"    -c	Runs as Client, runs with target IP Address as parameter\n"

if [ $# -eq 0 ]; then
    echo -e $USAGE_MSG
    exit 1
fi

while getopts $VALID_OPTS opt; do
    case $opt in
        c)
            res=$(dd if=/dev/zero bs=1M count=100 | nc $OPTARG $PORT) > /dev/null
            if [ $? -ne 0 ]; then
            res=""\
"\n Something has go wrong, please the following:\n"\
"    - Check if correct IP Address was passed\n"\
"    - Check the client is up on the remote machine\n"\
"    - Check if some firewall is blocking this script port (port=$PORT)"
            # else
            #    res=$(echo $res | awk 'END { printf "%s %s at %s %s" $1,$2,"at",$8,$9; }') > /dev/null
            fi
        ;;
        s)
            nc -l $PORT > /dev/null
	    if [ $? -ne 0 ]; then
	        res="An error has ocurred"
        fi
        ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
        ;;
    esac
done

echo -e $res
