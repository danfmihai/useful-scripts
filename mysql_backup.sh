#! /bin/bash

BACKUP_DIR="$HOME/backups/mysql"
MYSQL_USER="root"
MYSQL="/usr/bin/mysql"
MYSQL_PASSWORD="Schumi2011"
MYSQLDUMP="/usr/bin/mysqldump"

databases=$($MYSQL -u $MYSQL_USER -p$MYSQL_PASSWORD -B -e "show databases;" | tail -n +2)
echo $databases

if [ -d != $BACKUP_DIR ]; then
    mkdir -p $BACKUP_DIR
fi    

for db in $databases; do
    if [ ${db} != "information_schema" ]; then 
        $MYSQLDUMP --force --opt -u $MYSQL_USER -p$MYSQL_PASSWORD $db > $BACKUP_DIR/"${db}_$(date '+%m-%d-%Y').sql"
        echo "Saving ${db}..."
    fi    
done    