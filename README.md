# usbviewer
Das Programm liest PDFs, Bilder und Filme (mp4-Format) von einem USB Stick, 
konvertiert die PDFs in einzelne Bilder (jpeg Format) und kopiert alle Medien vom USB Stick auf die 
Speicherkarte des Raspberry Pi.

Anschliessend werden Bilder und Filme nach dem Start des Raspberry Pi über HDMI wiedergegeben. 

Wenn der Raspberry Pi ohne USB Stick gestartet wird, werden die Medien, welche im vorherigen Importvorgang 
auf den Raspberry Pi kopiert wurden, wiedergegeben. Beim Start mit USB Stick werden die alten Medien mit den 
Inhalten des USB Sticks überschrieben.

**Auf dem Raspberry Pi muss vorab folgendes installiert werden:**
- sudo apt-get install unoconv (Konvertierprogramme)
- sudo apt-get install fbi (Image-Viewer) 
- sudo apt-get install omxplayer (Video-Player)

**Anschliessend muss noch die automatische Erkennung des USBS-Sticks konfiguriert werden:**
```
sudo blkid
```
Es erscheint ein Eintrag für den eingesteckten USB-Stick, ähnlich dem untigen:

/dev/sda1: UUID="3A6D-A71F" TYPE="vfat"

Jetzt die Konfigurationsdatei /etc/fstab editieren:
```
sudo nano /etc/fstab
```
Folgenden Eintrag vornehmen, speichern und den Raspberry Pi neu starten:
```
UUID=3A6D-A71F /media/usb0/ vfat utf8,uid=pi,gid=pi,noatime 0 0
```
**Um die usbviewer Skripte beim Hochfahren des Raspberry Pi automatisiert auszuführen, folgenden Eintrag in der /etc/rc.local vornehmen:**
```
sudo nano /etc/rc.local
/home/pi/rkups/startanzeigen.sh  >/dev/null 2>&1
```
Falls der Raspberry Pi im X-Windows Desktop-Modus gestartet wird, kann alternativ auch folgender Autostart-Eintrag vorgenommen werden:
```
/home/pi/.config/autostart/viewerstart.desktop
```
Folgende Einträge in der Datei vornehmen und abspeichern:
```
[Desktop Entry]
Name=Autostart-Script
Comment=Kommentar
Type=Application
Exec=/home/pi/rkups/startanzeigen.sh
Terminal=false
```

**Folgende Verzeichnise werden für den usbviewer gebraucht (alle in rkups, da sind auch die scripts drin)**

- Anzeigen -> da liegen die jpgs und adere Bildformate drin
- Anzeigenmp4 -> da liegen die mp4s drin
- Anzeigenurl  -> da ist eine url drin, die angezeigt wird
- Stick  -> das ist der Clone des Sticks (mit umgebauten Namen " "  -> "_"

**Weitere nützliche Links:**
- PDF in einzelne Bilddateien (ppm Format wandeln): https://wiki.ubuntuusers.de/poppler-utils/
- Slideshow erzeugen: https://www.raspberrypi-spy.co.uk/2017/02/how-to-display-images-on-raspbian-command-line-with-fbi/




