#!/bin/bash
# Das Programm stellt Files aus den Ordnern  "Anzeigen" und "Anzeigenmp4" dar
# Aufruf mit Parameter "endlos" stellt in eine Endlosschleife alles dar
vcgencmd display_power 0
eingabe=$1
repeat=1
echo Eingabparameter in darstellen.sh war $eingabe
while [ $repeat -eq 1 ]
do
#1.) Bilddateien
  anzfjpg=$(find /home/pi/rkups/Anzeigen -type f | wc -l)  # das ist die Anzahl der Bilddateien
  echo anzfjpg= $anzfjpg

  if [ $anzfjpg -gt 0 ];then
vcgencmd display_power 1
     sudo fbi -a -T 1 -t 1 -1 --once -v --noverbose /home/pi/rkups/Anzeigen/*
# nun wird gewartet, bis alles angezeigt ist
     x=1111
     y=$(pidof fbi)
     echo x vor der schleife $x
     echo y vor der schleife $y
      while [[ `echo "$x" | grep -E ^[[:digit:]]+$` ]] && [ $x -gt 0 ]
#     while [[ 'echo "$x"| grep [[:digit:]]' ]] && [ $x > 0 ]    # warten bis fbi fertig ist (also die PID von fbi keine Zahl>0 mehr ist)
     do 
        x=$(pidof fbi)
        echo x,y in schleife = $x , $y
     done
  fi
  if [[ `echo "$y" | grep -E ^[[:digit:]]+$` ]] # Killt den fbi Prozess, aber nur wenn es einen gab (also auf y eine Zahl steht)
  then
    sudo kill $y
    vcgencmd display_power 0
    echo fbi Prozess $y wurde erfolgreich gekillt
  fi
#2.) Videos

  anzfmp=$(find /home/pi/rkups/Anzeigenmp4 -type f | wc -l)  # das ist die Anzahl der mp4s
  echo anzfmp= $anzfmp

  if [ $anzfmp -gt 0 ];then
#Anzeigen der mp4 Videos
    files="/home/pi/rkups/Anzeigenmp4/*"
    echo files=$files
    for filename in $files  #alle mp4s einzeln viewen
    do
     echo Video spielen:   $filename
    vcgencmd display_power 1
     sudo omxplayer $filename
    vcgencmd display_power 0
    done
  fi
# pr√ºfen, ob eine Enlosschleife gewollt ist
  if [ "$eingabe" == "endlos" ]
  then
    repeat=1
  else
    repeat=0
  fi
echo In der Schleife re√peat= $repeat
done
