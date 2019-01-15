For an enclosure see [rpi-drive](https://github.com/msonst/rpi-drive)

```
################################################################################
#  Copyright (c) 2017, Michael Sonst, All Rights Reserved.
# 
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
# 
#  http://www.apache.org/licenses/LICENSE-2.0
# 
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
################################################################################

# Download & write rpi image
# Assuming: 2017-04-10-raspbian-jessie-lite

ssh pi@<IP>

# Set new password
passwd
sudo adduser <USER>
sudo usermod -aG sudo <USER> 

# On node to monitor via tcpdump
sudo visudo
> <BACKUPUSER> ALL=(ALL) NOPASSWD: ALL

sudo raspi-config
> Interfacing Options > Enable SSH
> Hostname > private-cloud
> Advanced > Expand Filesystem
> Localisation Options > Change Wi-fi Country > US
> Localisation Options > Change Timezone > US > Eastern
> reboot

sudo timedatectl set-ntp True

sudo apt-get -y update
sudo apt-get -y dist-upgrade
sudo apt-get -y update 

sudo apt-get -y install rsync

ssh-keygen
ssh-copy-id <USER>@<RHOST>

sudo chown -R <USER>:<USER> /data/virtual

nano /boot/config.txt
> dtoverlay=pi3-disable-wifi
> dtoverlay=pi3-disable-bt

chmod +x backup-user.sh
chmod +x backup-logs.sh
chmod +x backup-db.sh

(crontab -l ; echo "00 * * * * /home/<USER>/backup/backup-user.sh") | crontab -
(crontab -l ; echo "00 * * * * /home/<USER>/backup/backup-logs.sh") | crontab -
#                   -  - - - -
#                   |  | | | |
#                   |  | | | ----- Day of week (0 - 7) (Sunday=0 or 7)
#                   |  | | ------- Month (1 - 12)
#                   |  | --------- Day of month (1 - 31)
#                   |  ----------- Hour (0 - 23)
#                   -------------- Minute (0 - 59)



################################################################################
## 0) Single drive
sudo su -c "echo '/dev/sda1 /data/virtual ext3 defaults 1 2' >> /etc/fstab"
sudo mount -a

################################################################################

# TODO: Update cert via letsencrypt.
```
