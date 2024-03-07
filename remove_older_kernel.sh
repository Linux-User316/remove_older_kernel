#!/bin/bash

KERNEL_NOW() {
ls /lib/modules/ > /tmp/space.txt
zenity --text-info --title "Der aktuelle Inhalt von  /lib/modules/" --filename=/tmp/space.txt --width=600 --height=200 2> /dev/null
}

DEPENDENCY() {

if [ -d /usr/share/doc/dialog ]; then
	dialog --no-lines --ok-label " ENTER " --colors --stderr --prgbox "\Zr\Z2 Aktiver Kernel \ZR\n\n	\Zr\Z0  Alle Kernel \ZR" \
"echo;uname -sr;echo;dpkg -l | grep -E '^..[[:space:]]+linux-image-[\.[:digit:]]+'" 16 85
	clear
       KERNEL_NOW
else
	# Zeigt alle zur Zeit installierten Kernel!
	echo "** Alle Kernel! **"
	echo
	dpkg -l | grep -E '^..[[:space:]]+linux-image-[\.[:digit:]]+' | awk '{print $2}'
	echo
	echo "** Aktiver Kernel! **"
	echo
	uname -sr
	printf "\n** Bitte mit ENTER bestätigen! **"
	read -n1
        clear
        KERNEL_NOW
fi
}

KERNEL() {
# Wird nur aktive wenn mehr als zwei Kernel vorhanden sind!
for DURCHLAUF in KERNEL; do
if [ "$(dpkg -l | grep -E '^..[[:space:]]+linux-image-[\.[:digit:]]+' | awk '{print $2}' | wc -l)" -le "2" ]; then   # soll ist zwei Kernel!
   exit
elif [  "$(dpkg -l | grep -E '^..[[:space:]]+linux-image-[\.[:digit:]]+' | awk '{print $2}' | wc -l)" -ge "3" ]; then  # reagiert ab 3 Kernel!
  KERNEL=$(dpkg -l | grep -m1 'linux-image-*' | awk '{ print $2 }' | cut -d- -f3,4)
  sudo apt-get remove --purge linux-headers-${KERNEL}  linux-image-${KERNEL}-generic  linux-modules-${KERNEL}-generic  linux-modules-extra-${KERNEL}-generic 
  fi
  
if [ ! "$(sudo dpkg -l 'linux-*' | grep '^rc' | wc -l)" = "0" ]; then
   REMOVE=`sudo dpkg -l | grep linux-* |  awk '/^rc/{ print $2}'`
   sudo apt-get autoremove --purge  ${REMOVE} 
   printf "\n** Bitte mit ENTER bestätigen! **"
   read -t10
fi
done
}

###############################################################################################

DEPENDENCY
KERNEL







