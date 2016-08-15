#!/bin/bash
#
# Database Backup Dropbox
#
# Author Helmar Junior <helmarluizjr@gmail.com>
#

#Default values
DATE_NOW=$(date +"%Y-%m-%d:%H:%M")
LOCAL_BKP_DIR="/var/www/backup"
DROPBOX_BKP_DIR="/database-backup"

################
#### START  ####
################

#Create directory if not exists
if [ ! -d ${LOCAL_BKP_DIR} ]; then
  mkdir -p ${LOCAL_BKP_DIR}
fi
if [ ! -d ${DROPBOX_BKP_DIR} ]; then
  mkdir -p ${DROPBOX_BKP_DIR}
fi

#Dump database
# echo "dropping database"
pg_dump -c --inserts -U postgres sistema >  $LOCAL_BKP_DIR/database_full.sql

# compress sql file
# echo "compressing database"
tar -czvf $LOCAL_BKP_DIR/$DATE_NOW.tar.gz $LOCAL_BKP_DIR/database_full.sql

# echo "sending backup!"
./dropbox_uploader.sh upload $LOCAL_BKP_DIR/$DATE_NOW.tar.gz $DROPBOX_BKP_DIR
# echo "backup sended!"

# remove created files from local server
rm $LOCAL_BKP_DIR/database_full.sql
rm $LOCAL_BKP_DIR/$DATE_NOW.tar.gz
