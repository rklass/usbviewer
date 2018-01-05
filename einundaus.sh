#!/bin/bash -e
sudo rm /home/pi/rkups/error.txt #errordatei loeschen
echo Neuer Durchlauf --------------------------------- $(date) | tee -a /home/pi/rkups/error.txt
while true; do  /bin/ping -c1 www.google.com > /dev/null && break; sleep 60; done
echo Internet laeuft jetzt --------------------------  $(date) | tee -a /home/pi/rkups/error.txt
zeile=$(grep "KonfigParameter" /home/pi/rkups/usbviewconfig.txt)
echo $zeile
abschalten=${zeile:7:4}
echo abschalten= $abschalten | tee -a /home/pi/rkups/error.txt
abschalten=( ${abschalten[@]#0} ) # führende Nullen weg
abschalten=$((abschalten)) # damit wird aus dem String ein integer
echo abschalten= $abschalten | tee -a /home/pi/rkups/error.txt
einschalten=${zeile:15:4}
echo einschalten= $einschalten | tee -a /home/pi/rkups/error.txt
einschalten=( ${einschalten[@]#0} ) # führende Nullen weg
einschalten=$((einschalten)) # damit wird aus dem String ein integer
echo einschalten= $einschalten | tee -a /home/pi/rkups/error.txt
x=$(date)
  hhmm=${x:11:2}
  hhmm=$hhmm${x:14:2} # ist die aktuelle Uhrzeit
  hhmm=( ${hhmm[@]#0} ) # führende Nullen weg
  hhmm=$((hhmm)) # damit wird aus dem String ein integer
  view=$(cat /home/pi/rkups/viewerlaeuft.txt)  #view ist 1, wenn der Bildshirm eingeschaltet ist
echo Das Programm einundaus.sh ist gestartet.  view= $view aktuelle Zeit= $hhmm abschalten= $abschalten einschalten= $einschalten | tee -a /home/pi/rkups/error.txt

# Prüfung, ob es sinvolle Eingaben waren
if [[ `echo "$einschalten" | grep -E ^[[:digit:]]+$` ]]
 then
  echo einschalten ist korrekt belegt | tee -a /home/pi/rkups/error.txt
 else
  echo Es war keine Zahl auf einschalten | tee -a /home/pi/rkups/error.txt
 exit
fi
if [[ `echo "$abschalten" | grep -E ^[[:digit:]]+$` ]]
 then
  echo abschalten ist korrekt belegt | tee -a /home/pi/rkups/error.txt
 else
  echo Es war keine Zahl auf abschalten | tee -a /home/pi/rkups/error.txt
 exit
fi
# Warten, da es ein weilchen dauert bis date stimmt
sleep 120
echo Aktuelle Zeit ist nun  --------------------------  $(date) | tee -a /home/pi/rkups/error.txt

#
while true  # endlosschleife
do
  sleep 20
  x=$(date)
  hhmm=${x:11:2}
  hhmm=$hhmm${x:14:2} # ist die aktuelle Uhrzeit
  hhmm=( ${hhmm[@]#0} ) # führende Nullen weg
  hhmm=$((hhmm)) # damit wird aus dem String ein integer
  view=$(cat /home/pi/rkups/viewerlaeuft.txt)  #view ist 1, wenn der Bildshirm eingeschaltet ist
#  echo view= $view aktuelle Zeit= $hhmm abschalten= $abschalten einschalten= $einschalten | tee -a /home/pi/rkups/error.txt
  if [ "$view" -eq 1 ] && [ "$hhmm" -eq "$abschalten" ]
  then
   echo view= $view aktuelle Zeit= $hhmm abschalten= $abschalten einschalten= $einschalten | tee -a /home/pi/rkups/error.txt
   echo Monitor wird abgeschaltet | tee -a /home/pi/rkups/error.txt
  bash /home/pi/rkups/monitoroff.sh
  fi
  if [ "$view" -eq 0 ] && [ "$hhmm" -eq "$einschalten" ]
  then
   echo view= $view aktuelle Zeit= $hhmm abschalten= $abschalten einschalten= $einschalten | tee -a /home/pi/rkups/error.txt
   echo Monitor wird eingeschaltet | tee -a /home/pi/rkups/error.txt
  bash /home/pi/rkups/monitoron.sh
  fi

done

#Thu 28 Dec 13:57:26 CET 2017  ist das Formate von date
