#!/bin/bash

clear

SERVER_NAME=`hostname -i`
rm -f /tmp/.pingfile

TEST_ALIVE ()
{
c=0
i=0

HOST=$1

# If ping is successfull, increment i.
# Do this 5 times and multiply i by 20 to get
# the percent of success rate.

while [ $c -lt 5 ];do
ping -c1 $HOST > /dev/null 2>&1 && i=$[$i+1] 
c=$[$c+1]
done

PERCENT=$(( $i * 20 ))

case $i in

0)
   echo  -e "$HOST \t \033[38;5;016m \033[48;5;196m$PERCENT%\033[0m" >> /tmp/.pingfile # red 0%
;;
1)
   echo  -e "$HOST \t \033[38;5;016m \033[48;5;202m$PERCENT%\033[0m" >> /tmp/.pingfile # light red 20%
;;
2)
   echo  -e "$HOST \t \033[38;5;016m \033[48;5;214m$PERCENT%\033[0m" >> /tmp/.pingfile # yellow 40%
;;
3)
   echo  -e "$HOST \t \033[38;5;016m \033[48;5;226m$PERCENT%\033[0m" >> /tmp/.pingfile # light yellow 60%
;;
4)
   echo  -e "$HOST \t \033[38;5;016m \033[48;5;190m$PERCENT%\033[0m" >> /tmp/.pingfile # light green 80%
;;
5)
   echo  -e "$HOST \t \033[38;5;016m \033[48;5;046m$PERCENT%\033[0m" >> /tmp/.pingfile # green 100%
;;
esac

}

echo "Sending five pings to each hostname. Please wait ..."


for EACH_SITE in `awk '$1 !~ /^#/ { print $3 }' /etc/hosts | tr -s '[:space:]''/n' | grep -v "localhost" | grep -v "${SERVER_NAME}"`; do
  TEST_ALIVE ${EACH_SITE} &
done
wait

echo "Percent of alive pings:"
sort /tmp/.pingfile 

exit 0
