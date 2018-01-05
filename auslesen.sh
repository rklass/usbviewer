#!/bin/bash
zeile=$(grep "zeit" /home/pi/rkups/usbviewconfig.txt)
zeit=${zeile:4:6}

zeile=$(grep "abschalten" /home/pi/rkups/usbviewconfig.txt)
ausschalten=${zeile:11:15}

zeile=$(grep "anschalten" /home/pi/rkups/usbviewconfig.txt)
anschalten=${zeile:11:15}


echo zeit= $zeit ausschalten= $ausschalten anschlalten= $anschalten
