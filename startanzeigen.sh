#!/bin/bash
# Das Programm startet eine slideshow. Dabei werden die auf einem Stick befindlichen jpgs und pdfs verwendet
#
#1. Prüfen, wieviele Sticks gelsteckt sind. Wenn <> 1 Stick, wird das vorhandene
# Verzeichnis Ansicht dargestellt
unoconv --listener &   # office im Hintergrund starten
echo "office wurde gestartet "
echo " "
echo "-------------------------------------------------------------"
#--
anzs=$(bash /home/pi/rkups/anzahlsticks.sh )
echo "anzs= " $anzs
if [ $anzs != 1 ]
  then
    echo "Es stecken keiner oder mehr als ein Sticks -> Ansicht wird dargestellt und fertig"
     sudo bash /home/pi/rkups/darstellen.sh endlos
    exit 0
fi
 #
#2. Es steckt genau 1 Stick drin
echo " "
echo "-------------------------------------------------------------"
echo "Es steckt " $anzs " Stick -> Ansicht wird neu erzeugt"
rm -r /home/pi/rkups/Anzeigen/*  # Verzeichnis Anzeigen loeschen
rm -r /home/pi/rkups/Anzeigenmp4/*  # Verzeichnis Anzeigenmp4 loeschen
rm -r /home/pi/rkups/Anzeigenurl/*  # Verzeichnis Anzeigenurl loeschen 

# der komplette Stick wird auf SD kopiert (vorher löschen)
rm -r /home/pi/rkups/Stick/*  # Verzeichnis Anzeigen loeschen
cp /media/usb0/* /home/pi/rkups/Stick
files="/home/pi/rkups/Stick/*"
echo " "
echo "-------------------------------------------------------------"
echo "Diese Files sind auf dem Stick ", $files # das sind die files auf dem Stick
cd /home/pi/rkups/Anzeigen
rename 's/\s/_/g' $files  #alle leerzeichen auf dem Stick werden durch _ ersetzt
# Nun werden die Office Files in pdf gewandelt
echo " "
echo "-------------------------------------------------------------"
echo " "
echo "Nun wurde jeweils die Lehrzeichen entfernt und durch _ ersetzt ", $files # das sind files mit " " -> "_" ersetzt
echo " "
echo "-------------------------------------------------------------"
for filename in $files  #alle Officefiles in pdf wandeln
do
  typ=${filename:(-4)}  # die letzten 4 Zeichen des filenamens
  echo "typ= " $typ
  if [ $typ == "pptx" ] || [ $typ == "xlsx" ] || [ $typ == "docx" ]
  then
   echo $filename " wird nach pdf umgewandelt"
   unoconv -f pdf $filename  
   echo "fertig"
  fi
done
echo " "
echo "-------------------------------------------------------------"
files="/home/pi/rkups/Stick/*"
for filename in $files  #jpgs nach Ordner "Anzeigen" kopieren
do
    typ=${filename:(-4)}  # die letzten 4 Zeichen des filenamens
    echo "typ= " $typ
    if [ $typ == ".pdf" ]
# Behandlung der pdfs
     then #pdfs werden nach ppm gewandelt
       cp $filename /home/pi/rkups/Anzeigen    #pdf File wird in Anzeigen gespeichert
       pdfdatei=${filename##*/}           #Dateiname des pdfs wird ermittelt
       echo "pdfdatei= " $pdfdatei
       pdfdatk=${pdfdatei:0:-4}           # und es werden die zeichen ".pdf" hinten abgeschnitten
       echo "pdfdatk= " $pdfdatk
       pdftoppm $filename $pdfdatk         # damit wird seitenweise nach ppm gewandelt, der Name bleibt aber gleich
       rm /home/pi/rkups/Anzeigen/$pdfdatei  #pdfdatei wird wieder gelöscht
    fi
    echo " "
    echo "-------------------------------------------------------------"
# Behandlung der jpgs und jpegs
    if [ $typ == ".jpg" ] || [ $typ == "jpeg" ]
      then
        echo "kopiert wird: " $filename
        cp $filename /home/pi/rkups/Anzeigen
      fi
     echo "-------------------------------------------------------------"
# Behandlung der url.txt
     if [ ${filename:(-7)}  == "url.txt" ]
     then
      echo "kopiert wird: " $filename
      cp $filename /home/pi/rkups/Anzeigenurl
     fi
echo "-------------------------------------------------------------"
# Behandlung der mp4
     if [ $typ == ".mp4" ] 
     then
      echo "kopiert wird: " $filename
      cp $filename /home/pi/rkups/Anzeigenmp4
     fi
done

# nun wird angezeigt
sudo bash /home/pi/rkups/darstellen.sh endlos
exit 0

