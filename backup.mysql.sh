#!/bin/bash
# backup.mysql 
# A Script to make a backup of a MySQL-Database, and sends it per Email
#
# Works great with databases that fit in an Email-Message
# Let say, archives smaller then 30 megabytes.
# You could attach it to a CronJob, to make a backup at set times.
#
# Author Ensio
#
# ------
#
# I've used rar here. 
# 
# https://www.rarlab.com/
#
# You could use an other Archiver.
#
# ------
#
# I've used a bit of Java-code to email the Archive.
#
# MailApp.jar
#
# You could use some other Utility
#

PAD="/home/mysqlbackup";

cd $PAD;

DATUM=`date +"%m-%d-%y"`

# DATABASE DETAILS
DATABASE_SERVER="localhost"
DATABASE_LOGIN="root"
DATABASE_PASSWORD="a_password"
DATABASE_SCHEMA="database-name"


#EMAIL DETAILS
EMAIL_ADDRESSES=("someone@somedomain.com" "someone-else@domain.com" )
EMAIL_RETOUR="retour@domain.com"
EMAIL_SUBJECT="Backup of $DATABASE_SERVER - $DATABASE_SCHEMA"

# RAR PASSWORD
RAR_PASSWORD="abigpassword"

# DATABASE 
mysqldump --host=$DATABASE_SERVER --user=$DATABASE_LOGIN --password=$DATABASE_PASSWORD $DATABASE_SCHEMA > $PAD/$DATABASE_SCHEMA.$DATUM.sql

# Create a RAR-Archive
rar a -p$RAR_PASSWORD $PAD/$DATABASE_SCHEMA.$DATUM.sql.rar $PAD/$DATABASE_SCHEMA.$DATUM.sql

pwd;

# Email the Archive
for i in "${EMAIL_ADDRESSES[@]}"
do
echo Email for $i;
java -jar $PAD/EmailApp.jar $i "$EMAIL_SUBJECT" "$EMAIL_SUBJECT"  $PAD/$DATABASE_SCHEMA.$DATUM.sql.rar $EMAIL_RETOUR;
done;

# CLEAN-UP
rm -f $PAD/$DATABASE_SCHEMA.$DATUM.sql
rm -f $PAD/$DATABASE_SCHEMA.$DATUM.sql.rar
