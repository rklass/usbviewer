# usbviewer
Das Programm liest PDFs, Bilder und Filme (mp4-Format) von einem USB Stick, 
konvertiert die PDFs in einzelne Bilder (jpeg Format) und kopiert alle Medien vom USB Stick auf die 
Speicherkarte des Raspberry Pi.

Anschliessend werden Bilder und Filme nach dem Start des Raspberry Pi über HDMI wiedergegeben. 

Wenn der Raspberry Pi ohne USB Stick gestartet wird, werden die Medien, welche im vorherigen Importvorgang 
auf den Raspberry Pi kopiert wurden, wiedergegeben. Beim Start mit USB Stick werden die alten Medien mit den 
Inhalten des USB Sticks überschrieben.

Außerdem werden beim Start Parameter von einer Datei  usbviewconfig.txt übernommen. Die steuern das An- und Abschalten des Monitors (Achtung: das geht nur, wenn der Pi im Internet ist !!) und die Anzeigezeit pro Bild der Slideshow

**Konfiguration des Raspberrys:**
- Download und Installation eines Raspbian Stretch Lite Images: https://downloads.raspberrypi.org/raspbian_lite_latest
- oder Download und Installation eines Raspbian Stretch Desktop Images: https://downloads.raspberrypi.org/raspbian_latest
- Image auf eine Speicherkarte ziehen

**Auf dem Raspberry Pi muss vorab folgendes installiert werden:**
- sudo apt-get install unoconv (Konvertierprogramme)
- sudo apt-get install fbi (Image-Viewer) 
- sudo apt-get install omxplayer (Video-Player)
- sudo apt-get install unclutter (Programm um Mauszeiger verschwinden zu lassen)
- sudo apt-get install cowsay

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
/dev/sda1 /media/usb0 vfat  auto,nofail,noatime,users,rw,uid=pi,gid=pi  0 0
```
Falls der Raspberry Pi im X-Windows Desktop-Modus gestartet wird, kann alternativ auch folgender Autostart-Eintrag vorgenommen werden:
```
/home/pi/.config/autostart/viewerstart.desktop
```
Folgende Einträge in der Datei viewerstart.desktop vornehmen und abspeichern:
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

**Eingabeparameter**
die Datei usbviewconfig.txt kann auf dem Stick sein. Es ist eine Textdatei mit folgendem Format
001....1300....1320....KonfigParameter
sec    hhmm    hhmm
Show   Aus     Ein

Erklaerung:
- der erste Zifferblock (3 Ziffern bei sec) geben die Zeit zur Darstellung der einzelnen Bilder/ Seiten (in sekunden) fuer die Slideshow an
- der zweite Zifferblock (4 Ziffern bei hhmm) geben den Zeitpunkt an, an dem der Bildschirm taeglich abgeschaltet wird
- der dritte Zifferblock (4 Ziffern bei hhmm) geben den Zeitpunkt an, an dem der Bildschirm taeglich einschaltet
Achtung:
Das Format der ersten Zeile muss (incl. den Text KonfigParameter und den Punkten) so bleiben



