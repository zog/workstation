#!/bin/bash

BASE_DIR='/usr/local/pgsql/'
PGCTL=$BASE_DIR'bin/pg_ctl'
DB_DIRNAME='data'
BACKUP_DB_DIRNAME='backup.local.'`date +%m%d%Y`
REGEX='.*\.tar'

# Let's stop the server
$PGCTL stop -D $BASE_DIR$DB_DIRNAME
if [[ $1 =~ $REGEX ]]; then
 cd /tmp
 DUMP=$DB_DIRNAME'_tmp'
  mkdir $DUMP
  cd $DUMP
  tar -xf $1
  cd ..
else
  DUMP=$1
fi

mv $BASE_DIR$DB_DIRNAME $BASE_DIR$BACKUP_DB_DIRNAME
mv $DUMP $BASE_DIR$DB_DIRNAME
cp $BASE_DIR$BACKUP_DB_DIRNAME/*.conf $BASE_DIR$DB_DIRNAME
chmod -R 700 $BASE_DIR$DB_DIRNAME

# Let's start the server again
$PGCTL start -D $BASE_DIR$DB_DIRNAME