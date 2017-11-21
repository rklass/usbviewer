#!/bin/bash
# Das Programm prüft, ob ein stream läuft und nimmt den auf eine Datei des Sticks auf
# 1.) Test ob der Stream läuft (in while Schleife)
while [ 1==1 ];do
  IP1="192.168.0.101"                  # IP address Sony Camera in Bondorf
  IP2="192.168.2.116"   # IP der Axiskamera in Gechingen
  IP3="192.168.0.80"   # Test mit meinem PC  -> hier kann man eine ip Adresse zum Testen eingeben 
  echo "IP der Kamera wird geprüft"
#Ping IP-address of camera to see if it's online
  iwas=0
  echo "iwas= " $iwas
  if ping -c 1 $IP1 > /dev/null ; then
    iwas=1
    echo "Kamera Bondorf ist gefunden iwas = " $iwas
  fi
  if ping -c 1 $IP2 > /dev/null ; then
    iwas=2
    echo "Kamera Gechingen ist gefunden iwas = " $iwas 
  fi
#-----------------Auskommentierung entfernen für Test, dazu muß IP3 eine IP Adresse im Netz sein----------
#  if ping -c 1 $IP3 > /dev/null ; then
#    iwas=3
#    echo "Test an meinem PC ist gefunden  iwas = " $iwas
#  fi
#-----------------Auskommentierung entfernen für Test, dazu muß IP3 eine IP Adresse im Netz sein----------
  echo "iwas= " $iwas
  if [ $iwas -gt 0 ] ; then #es wurde ein Stream oder PC gefunden
# 2.) Namen mit Datum-Uhrzeit  generieren filename = Aufnahme Datum Zeit jetzt
#
# Variable deklarieren
    sleep 4
    datum=$(date +"%y-%m-%d-%H-%M-%S")
    echo $datum
# 3.) Stream mit ffmpeg auf filename in /media/usb0 schreiben
    if [ $iwas == 1 ] ; then
      file="Bondorf-$datum.mp4"
      pfad="/media/usb0/$file"
      echo "----> Test mit Bondorf Kamera wird gestartet <----"
      echo "----------> file= " $pfad
      ffmpeg -i rtsp://192.168.0.101/video1 $pfad     #Stream aus Kamera Bondorf    
    fi
    if [ $iwas == 2 ] ; then
      file="Gechingen-$datum.mp4"
      pfad="/media/usb0/$file"
      echo "----> Test mit Gechingen Kamera wird gestartet <----"
      echo "----------> file= " $pfad
      ffmpeg -i rtsp://root:tibet2000@192.168.2.116:554/axis-media/media.amp $pfad    #Stream aus Kamera Gechingen
    fi
    if [ $iwas == 3 ] ; then
      file="TestRK-PC-$datum.mp4"
      pfad="/media/usb0/$file"
      echo "----> Test am PC RK wird gestartet <----"
      echo "----------> file= " $pfad
      ffmpeg -i /home/pi/test-1504367260-Saturday-02-09-17-17-47.mp4 $pfad    #Test an meinem PC
    fi
  fi
sleep 1 # while schleife geht in 1 sec weiter
done
