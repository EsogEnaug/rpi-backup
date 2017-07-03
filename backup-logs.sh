################################################################################
#!/bin/sh
#
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

USER=<USER>
SERVER=<IP>
DAY=$(date '+%d')
HOUR=$(date '+%H')
SRC_DIR=/var/log
DST_ROOT_DIR=/data/virtual/hourly/logs
DST_SUBDIR=private-cloud
DST_DIR=$DST_ROOT_DIR/Day-$DAY/Hour-$HOUR/$DST_SUBDIR/


cd $DST_ROOT_DIR

for d in `seq 1 12`;
do
        dd=$(printf "%02i" $d)

        OLD_DIR=$DST_ROOT_DIR/Day-$dd

        if [ -d "$OLD_DIR" ] && ! [ "$DAY" -eq "$dd" ]
        then
                echo "Archiving $OLD_DIR (will override existing archive)"
                tar -zcvf Day-$dd-logs.tar.gz $OLD_DIR
                rm -r $OLD_DIR
        fi
done


mkdir -p $DST_DIR

echo "Backing up  $SRC_DIR on $SERVER"
rsync -avzP --delete --rsync-path='sudo rsync' -e ssh "$USER"@"$SERVER":"$SRC_DIR" "$DST_DIR"

##################################