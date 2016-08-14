#!/bin/bash
#
# Database Backup Dropbox
#
# Author Helmar Junior <helmarluizjr@gmail.com>
#
# Before use this scripts, learn the explanations:
#

#Default values
DATE_NOW=$(date +"%Y-%m-%d:%H:%M")
LOCAL_BKP_DIR="/var/www/backup"
DROPBOX_BKP_DIR="/database-backup"

################
#### START  ####
################

#Create directory if not exists
if [ ! -d ${DIR_BKP} ]; then
  mkdir -p ${DIR_BKP}
fi

#Dump database
# echo "dropping database"
pg_dump -c --inserts -U postgres sistema >  $LOCAL_BKP_DIR/database_full.sql

# compress sql file
# echo "compressing database"
tar -czvf $LOCAL_BKP_DIR/$DATE_NOW.tar.gz $LOCAL_BKP_DIR/database_full.sql

# nano ~/.dropbox_uploader
# OAUTH_ACCESS_TOKEN=QkhK9yWBIoAAAAAAAAADxL7vO6rhqoZoy29-aEKHx7_k7ou2kS7MdYl00Jl8aRgc
# echo "sending backup!"
./dropbox_uploader.sh upload $LOCAL_BKP_DIR/$DATE_NOW.tar.gz $DROPBOX_BKP_DIR
# echo "backup sended!"

# remove created files from local server
rm $LOCAL_BKP_DIR/database_full.sql
rm $LOCAL_BKP_DIR/$DATE_NOW.tar.gz
