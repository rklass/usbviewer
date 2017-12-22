#!/bin/bash
# Das Programm startet eine slideshow. Dabei werden die auf einem Stick befindlichen jpgs und pdfs verwendet
#
#1. Prüfen, wieviele Sticks gelsteckt sind. Wenn <> 1 Stick, wird das vorhandene
# Verzeichnis Ansicht dargestellt
unoconv --listener &   # office im Hintergrund starten
echo "---------------------------------------------------------------------------------------------"
echo "Hintergrund-Programm fuer die Konvertierung von Office- und PDF-Dokumenten wurde gestartet "
echo "---------------------------------------------------------------------------------------------"
anzs=$(bash /home/pi/rkups/anzahlsticks.sh )
echo "Anzahl USB-Sticks:" $anzs
if [ $anzs != 1 ]
  then
    echo "Keiner oder mehr als ein USB-Stick identifiziert. -> Anzeige wird gestartet"
     sudo bash /home/pi/rkups/darstellen.sh endlos
    exit 0
fi
#2. Wenn ein Stick im Raspberry steckt, dann die Konvertierungen starten
echo "---------------------------------------------------------------------------------------------"
echo -e "Es wurde(n)" $anzs "USB-Stick(s) identifiziert -> Bilder und Filme werden neu erzeugt."
rm -r /home/pi/rkups/Anzeigen/*  # Verzeichnis Anzeigen loeschen
rm -r /home/pi/rkups/Anzeigenmp4/*  # Verzeichnis Anzeigenmp4 loeschen
rm -r /home/pi/rkups/Anzeigenurl/*  # Verzeichnis Anzeigenurl loeschen 

# Der komplette Stick wird auf SD kopiert (vorher löschen)
rm -r /home/pi/rkups/Stick/*  # Verzeichnis Anzeigen loeschen
cp /media/usb0/* /home/pi/rkups/Stick
files="/home/pi/rkups/Stick/*"
echo "---------------------------------------------------------------------------------------------"
echo -e "Die folgenden Dateien befinden sich auf dem USB-Stick: \n", $files # das sind die files auf dem Stick
cd /home/pi/rkups/Anzeigen
rename 's/\s/_/g' $files  #alle leerzeichen auf dem Stick werden durch _ ersetzt
# Nun werden die Office Files in pdf gewandelt
echo "---------------------------------------------------------------------------------------------"
echo -e "Die Leerzeichen in den folgenden Dateinamen wurden entfernt und durch _ ersetzt. \n ", $files # das sind files mit " " -> "_" ersetzt
echo "---------------------------------------------------------------------------------------------"
for filename in $files  #alle Officefiles in pdf wandeln
do
  typ=${filename:(-4)}  # die letzten 4 Zeichen des filenamens
  #echo "typ= " $typ
  if [ $typ == "pptx" ] || [ $typ == "xlsx" ] || [ $typ == "docx" ]
  then
   echo -e $filename " wird nach pdf konvertiert. \n"
   unoconv -f pdf $filename  
   echo -e "Konvertierung nach PDF ist erfolgt. \n"
  fi
done
echo "---------------------------------------------------------------------------------------------"
files="/home/pi/rkups/Stick/*"
for filename in $files  #jpgs nach Ordner "Anzeigen" kopieren
do
    typ=${filename:(-4)}  # die letzten 4 Zeichen des filenamens
    #echo "typ= " $typ
    if [ $typ == ".pdf" ]
# Behandlung der pdfs
     then #pdfs werden nach ppm gewandelt
       cp $filename /home/pi/rkups/Anzeigen    #pdf File wird in Anzeigen gespeichert
       pdfdatei=${filename##*/}           #Dateiname des pdfs wird ermittelt
       echo "Zu konvertierende PDF-Datei(en): " $pdfdatei
       pdfdatk=${pdfdatei:0:-4}           # und es werden die zeichen ".pdf" hinten abgeschnitten
       #echo "pdfdatk= " $pdfdatk
       pdftoppm $filename $pdfdatk         # damit wird seitenweise nach ppm gewandelt, der Name bleibt aber gleich
       rm /home/pi/rkups/Anzeigen/$pdfdatei  #pdfdatei wird wieder gelöscht
    fi
echo "---------------------------------------------------------------------------------------------"
# Behandlung der jpgs und jpegs
    if [ $typ == ".jpg" ] || [ $typ == "jpeg" ]
      then
        echo -e "Bilder werden auf den Raspberry kopiert: \n " $filename
        cp $filename /home/pi/rkups/Anzeigen
      fi
echo "---------------------------------------------------------------------------------------------"
# Behandlung der url.txt
     if [ ${filename:(-7)}  == "url.txt" ]
     then
      echo -e  "url.txt mit dem Link auf die Web-Site wir auf den Raspberry kopiert: \n " $filename
      cp $filename /home/pi/rkups/Anzeigenurl
     fi
echo "---------------------------------------------------------------------------------------------"
# Behandlung der mp4
     if [ $typ == ".mp4" ] 
     then
      echo -e "Filme (mp4) werden auf den Raspberry kopiert: \n " $filename
      cp $filename /home/pi/rkups/Anzeigenmp4
echo "---------------------------------------------------------------------------------------------"
     fi
done

# nun wird angezeigt
sudo bash /home/pi/rkups/darstellen.sh endlos
exit 0
