#!/bin/bash
# Das Programm startet eine Slideshow. Dabei werden die auf einem Stick befindlichen jpgs, pdfs und mp4s auf die 
# Speicherkarte des Raspberry Pi kopiert. Die pdfs werden zuvor in jpgs konvertiert.

# Schritt 1: Pruefen wie viele USB Sticks angeschlossen sind. Wenn <> 1 Stick, wird die Slideshow 
# mit vorhandenen jpgs und mp4s gestartet. Diese muessen sich in den Verzeichnisses ./Anzeigen und ./Anzeigenmp4 befinden

# Pfad festlegen, in welchem alle Scripte liegen
pfad="/home/pi/rkups/"

clear
unoconv --listener &   # Office wird im Hintergrund fuer die Konvertierung gestartet
#echo false > /home/pi/rkups/viewerlaeuft.txt # viewerlaeuft.txt wird auf true gestellt
echo "---------------------------------------------------------------------------------------------"
echo "Hintergrund-Programm fuer die Konvertierung von Office- und PDF-Dokumenten wurde gestartet "
echo "---------------------------------------------------------------------------------------------"
anzs=$($pfad"anzahlsticks.sh" )
echo "Anzahl USB-Sticks:" $anzs
if [ $anzs != 1 ]
  then
    echo "Keiner oder mehr als ein USB-Stick identifiziert. -> Anzeige wird gestartet"
     sudo bash $pfad"darstellen.sh" endlos
    exit 0
fi
#2. Wenn ein Stick im Raspberry steckt, dann die Konvertierungen starten
echo "---------------------------------------------------------------------------------------------"
echo -e "Es wurde(n)" $anzs "USB-Stick(s) identifiziert -> Bilder und Filme werden neu erzeugt."
rm -r $pfad"Anzeigen/"*  # Verzeichnis ./Anzeigen loeschen
rm -r $pfad"Anzeigenmp4/"*  # Verzeichnis ./Anzeigenmp4 loeschen
rm -r $pfad"Anzeigenurl/"*  # Verzeichnis ./Anzeigenurl loeschen 

# Der komplette Stick wird auf SD kopiert (vorher löschen)
rm -r $pfad"Stick/"*  # Verzeichnis ./Anzeigen loeschen
cp /media/usb0/* $pfad"Stick"
files=$pfad"Stick/"*
echo "---------------------------------------------------------------------------------------------"
echo -e "Die folgenden Dateien befinden sich auf dem USB-Stick: \n", $files # das sind die files auf dem Stick
cd $pfad"Anzeigen"
rename 's/\s/_/g' $files  #alle Leerzeichen der Dateinamen auf auf dem Stick werden durch _ ersetzt
# Nun werden die Office Files in pdf gewandelt
echo "---------------------------------------------------------------------------------------------"
echo -e "Die Leerzeichen in den folgenden Dateinamen wurden entfernt und durch _ ersetzt. \n ", $files # das sind files mit " " -> "_" ersetzt
echo "---------------------------------------------------------------------------------------------"

# Der File usbviewconfig.txt von stick wird kopiert
if [ -a /home/pi/rkups/Stick/usbviewconfig.txt ]
then
  echo "Es gab den file usbviewconfig.txt, er wird kopiert"
  cp /home/pi/rkups/Stick/usbviewconfig.txt /home/pi/rkups/usbviewconfig.txt
else
  echo "Es gab keinen  file usbviewconfig.txt, alter konfigfile bleibt"
fi
# nun wird die Abschaltung gestartet (im Hintergrund)
sudo bash /home/pi/rkups/einundaus.sh &
echo "---------------------------------------------------------------------------------------------"
echo -e "Konfigfile Prueffung ist abgeschlossen"
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
files=$pfad"Stick/*"
for filename in $files  #jpgs nach Ordner "Anzeigen" kopieren
do
    typ=${filename:(-4)}  # die letzten 4 Zeichen des filenamens
    #echo "typ= " $typ
    if [ $typ == ".pdf" ]
# Behandlung der pdfs
     then #pdfs werden nach ppm gewandelt
       cp $filename $pfad"Anzeigen"    #pdf File wird in Anzeigen gespeichert
       pdfdatei=${filename##*/}           #Dateiname des pdfs wird ermittelt
       echo "Folgende PDF-Datei wird konvertiert: " $pdfdatei
       pdfdatk=${pdfdatei:0:-4}           # und es werden die zeichen ".pdf" hinten abgeschnitten
       #echo "pdfdatk= " $pdfdatk
       pdftoppm $filename $pdfdatk         # damit wird seitenweise nach ppm gewandelt, der Name bleibt aber gleich
       rm $pfad"Anzeigen/"$pdfdatei  #pdfdatei wird wieder gelöscht
    fi
echo "---------------------------------------------------------------------------------------------"
# Behandlung der jpgs und jpegs
    if [ $typ == ".jpg" ] || [ $typ == "jpeg" ]
      then
        echo -e "JPG-Bild wird auf den Raspberry kopiert: " $filename
        cp $filename $pfad"Anzeigen"
      fi
echo "---------------------------------------------------------------------------------------------"
# Behandlung der url.txt
     if [ ${filename:(-7)}  == "url.txt" ]
     then
      echo -e  "url.txt mit dem Link auf die anzuzeigenden Web-Sites wird auf den Raspberry kopiert: " $filename
      cp $filename $pfad"Anzeigenurl"
     fi
echo "---------------------------------------------------------------------------------------------"
# Behandlung der mp4
     if [ $typ == ".mp4" ] 
     then
      echo -e "MP-Movie wird auf den Raspberry kopiert: " $filename
      cp $filename $pfad"Anzeigenmp4"
echo "---------------------------------------------------------------------------------------------"
     fi
done

# nun wird angezeigt
sudo bash $pfad"darstellen.sh" endlos
exit 0
