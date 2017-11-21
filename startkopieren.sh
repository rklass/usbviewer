#!/bin/bash
# Das Programm bereinigt und kopiert dann den laufenden Stream auf den Stick
echo "-------------------------------------------------------"
echo "   Programm startkopieren.sh ist gestartet"
echo "   Jetzt startet Programm alteweg.sh "
sleep 3
sudo bash /home/pi/rkups/alteweg.sh
echo "alteweg.sh ist gelaufen. "
echo " "
echo "-------------------------------------------------------"
echo "C: Jetzt startet das Kopierprogramm /home/pi/rkups/aufnehmen.sh"
sudo bash /home/pi/rkups/aufnehmen.sh

