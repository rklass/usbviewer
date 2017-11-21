#!/bin/bash
# Das Programm geht durch alle mp4 Dateien in Verzeichnis  
# Anschliessend werden die älteren Dateien geloescht 
# Es wird so lange die aelteste Datei geloescht, bis nur noch die
# gewünschte Anzahl an Dateien (MaxAnzDat) uebrig ist 
# Es werden nur Dateien behandelt mit Namen  "beliebigerStringXX-MM-DD-hh-mm-ss.mp4
# Es muessen 2 Vorgaben eingestellt werden
#  MaxAnzDat........ Anzahl Dateien, die uebrig bleiben sollen
#  pfad............  Verzeichnis, das durchsucht und in dem geloescht
#    -->  Viel Spass <--     Reinhold Klass
typeset -i alle=0
typeset -i lauf=0
typeset -i Anzahl=0
typeset -i MaxAnzDat=10   # VORGABE: Maximale Anzahl Dateien, die uebrig bleiben sollen
# 1.) Einstellungen
echo " 1.) Vorgaben "
pfad="/media/usb0/*"   # VORGABE:    Verzeichnis in dem stehen die .mp4s (mit /* hinten)
echo "pfad=  " $pfad
echo "MaxAnzDat=  " $MaxAnzDat
echo " "
# 2.) Schleife ueber pfad um die Anzahl der zu behandelnden Dateien zu ermitteln
echo " ...."
for File in $pfad
   do
    alle=alle+1 #alle ergibt die Zahl aller Dateien in pfad
    #Zahl aus Datum generieren
    datzahl="${File: -21 : -19}${File: -18 : -16}${File: -15 : -13}${File: -12 : -10}${File: -9 : -7}${File: -6 : -4}"
    # Testen, ob es eine Zahl ist
    if [[ `echo "$datzahl" | grep -E ^[[:digit:]]+$` ]]
      then
      lauf=lauf+1  # es ist eine Zahl, Datei wird gezaehlt
    fi
    echo "Filename= " $File , "lauf= " $lauf "datzahl= " $datzahl
 done
Anzahl=$lauf
# Ergebnis
echo "Es sind " $alle " Dateien drin, davon sind "  $Anzahl " Dateien mit Datum am Ende "
if [ $Anzahl -le $MaxAnzDat ]
then
  echo "Nix zu Loeschen, weil die Maximalanzahl  MaxAnzDat= " $MaxAnzDat " nicht ueberschritten ist. " 
fi
# 3) In While Schleife immer die aelteste Datei löschen solange bis nur noch MaxAnzDat da sind
while [ $Anzahl -gt $MaxAnzDat ]
do
  datmin=555555555555  # ist eine Zahl YYMMDDhhmmss
#aelteste Datei finden
  for File in $pfad
   do
      datzahl="${File: -21 : -19}${File: -18 : -16}${File: -15 : -13}${File: -12 : -10}${File: -9 : -7}${File: -6 : -4}"
    # Testen, ob es eine Zahl ist
      if [[ `echo "$datzahl" | grep -E ^[[:digit:]]+$` ]]
      then
        echo $File " hat die datzahl= "  $datzahl "datmin = " $datmin
        if [ $datzahl -lt $datmin ]
        then
           datmin=$datzahl
           Fileold=$File
        fi
      fi
  done
  echo " "
  echo "---> Der aelteste File ist " $Fileold  " mit Datzahl= "  $datmin  " er wird geloescht"
# alten File loeschen
  rm $Fileold
  Anzahl=Anzahl-1 
  echo "---> File wurde geloescht. Aktuelle  Anzahlfiles=  " $Anzahl " Erlaubt sind maximal MaxAnzDat= " $MaxAnzDat
  echo " "
done
echo " - - - FERTIG - - - "
