# usbviewer
Das Programm liest PDFs, Bilder und Filme (mp4-Format) von einem USB Stick, 
konvertiert die PDFs in einzelne Bilder (jpeg Format) und kopiert alle Medien vom USB Stick auf die 
Speicherkarte des Raspberry Pi.

Anschliessend werden Bilder und Filme nach dem Start des Raspberry Pi über HDMI wiedergegeben. 

Wenn der Raspberry Pi ohne USB Stick gestartet wird, werden die Medien, welche im vorherigen Importvorgang 
auf den Raspberry Pi kopiert wurden, wiedergegeben. Beim Start mit USB Stick werden die alten Medien mit den 
Inhalten des USB Sticks überschrieben.

Hilfsmittel
- PDF in einzelne Bilddateien (ppm Format wandeln): https://wiki.ubuntuusers.de/poppler-utils/
- Slideshow erzeugen: https://www.raspberrypi-spy.co.uk/2017/02/how-to-display-images-on-raspbian-command-line-with-fbi/
- Autostart einbauen:
Datei innerhalb /home/pi/.config/autostart/viewerstart.desktop anlegen, die so aussieht
		[Desktop Entry]
		Name=Autostart-Script
		Comment=Kommentar
		Type=Application
		Exec=/home/pi/rkups/startanzeigen.sh
		Terminal=false


Folgende Verzeichnise werden gebraucht (alle in rkups, da sind auch die scripts drin)

Anzeigen -> da liegen die jpgs und adere Bildformate drin

Anzeigenmp4 -> da liegen die mp4s drin

Anzeigenurl  -> da ist eine url drin, die angezeigt wird

Stick  -> das ist der Clone des Sticks (mit umgebauten Namen " "  -> "_"




