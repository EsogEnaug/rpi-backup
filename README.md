```
# Download & write rpi image
# Assuming: 2017-04-10-raspbian-jessie-lite

ssh pi@<IP>

# Set new password
passwd
sudo adduser <USER>
sudo usermod -aG sudo <USER> 

sudo raspi-config
# Interfacing Options > Enable SSH
# Hostname > private-cloud
# Advanced > Expand Filesystem
# Localisation Options > Change Wi-fi Country > US
# Localisation Options > Change Timezone > US > Eastern
# reboot

sudo timedatectl set-ntp True

sudo apt-get -y update
sudo apt-get -y dist-upgrade

sudo apt-get -y update 

sudo apt-get -y install rsync

ssh-keygen
ssh-copy-id <USER>@<RHOST>

nano backup.sh
##################################
#!/bin/sh

USER=<USER>
RHOST=<RHOST>
SRC_DIR=/data/virtual
DST_DIR=/data/virtual/private-cloud

echo "Backing up $RHOST"
CMD="rsync -avzP --delete -e ssh "$USER"@"$RHOST":"$SRC_DIR" "$DST_DIR""

(crontab -l ; echo "00 09 * * 1-5 echo hello") | crontab -

##################################

chmod +x backup.sh

################################################################################
## 0) Single drive
sudo su -c "echo '/dev/sda1 /data/virtual ext3 defaults 1 2' >> /etc/fstab"
sudo mount -a
```
