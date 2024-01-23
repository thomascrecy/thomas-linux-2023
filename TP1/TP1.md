# TP1 : Casser avant de construire

## II. Casser


## 2. Fichier

### 3. 🌞 Supprimer des fichiers

```
$ sudo rm /bin/sh
$ sudo rm /bin/bash
```

## 3. Utilisateurs

### 🌞 Mots de passe

```
$ sudo passwd otheruser
```

```
$ sudo rm -r /etc/passwd
```

### 🌞 Another way ?

```

```

## 4. Disques

### 🌞 Effacer le contenu du disque dur

```
$ sudo dd if=/dev/zero of=/dev/sda bs=4M

```

## 5. Malware

## 🌞 Reboot automatique

```
$ sudo nano /home/toto/script_reboot.sh
```

```
#!/bin/bash
# Script pour redémarrer la machine

sleep 30

reboot
```

```
$ sudo chmod +x /home/toto/script_reboot.sh
```

```
$ sudo nano /etc/rc.local
```

```
#A la fin du fichier

$ /chemin/vers/votre/script_reboot.sh
```

```
$ sudo chmod +x /etc/rc.local
```

## 6. You own way

### 🌞 Trouvez 4 autres façons de détuire la machine