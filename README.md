# usbviewer
Hilfsmittel
	• PDF in einzelne Bilddateien (ppm Format wandeln): https://wiki.ubuntuusers.de/poppler-utils/
	• Slidesho https://www.raspberrypi-spy.co.uk/2017/02/how-to-display-images-on-raspbian-command-line-with-fbi/
	• Autostart einbauen:
		○ Datei innerhalb /home/pi/.config/autostart/viewerstart.desktop anlegen, die so aussieht
		[Desktop Entry]
		Name=Autostart-Script
		Comment=Kommentar
		Type=Application
		Exec=/home/pi/rkups/startanzeigen.sh
		Terminal=false


Folgende Verzeichnise werden gebraucht (alle in rkups, da sind auch die scripts drin)
Anzeigen
Anzeigenmp4
Anzeigenurl
Stick

Sowie die Datei
ausgabe.txt
