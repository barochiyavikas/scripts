#!/bin/bash
# INFO: Script to dump PostgreSQL database schema and data
#
# Variables
SUFFIX=$(date +%Y%m%d)
SCRIPTDIR="/home/user/script"
LOGFILE="$SCRIPTDIR/logs/pg_dump.log"
DUMPDIR="/home/user/script/pgdumps/backup"
DUMPDAILY="$DUMPDIR/daily"
DUMPWEEKLY="$DUMPDIR/weekly"
DUMPMONTHLY="$DUMPDIR/monthly"
DAY=$(date +%d)
WEEKDAY=$(date +%u)
DB="IMS_2018"
#WALDIR="/local/pgwalarchive"

LIST_TABLES="SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema'"
LIST_SEQ="select relname from pg_class where relkind='S'"
CONNECT="-U postgres -p 5432 -E UTF8 -h localhost"
# Script
#
# Set correct dump dir
if [ $DAY == 01 ]; then
        #  monthly backup path
        DUMPPATH=$DUMPMONTHLY;
elif [ $WEEKDAY == 6 ]; then
        # weekly backup
        DUMPPATH=$DUMPWEEKLY;
else
        # daily backup path
        DUMPPATH=$DUMPDAILY;
fi
# Export PG password
echo "######## Starting DB backup ########" >> $LOGFILE
/bin/date >> $LOGFILE
# Dump DB structure
/usr/lib/postgresql/10/bin/pg_dump $CONNECT -C --schema-only -f $DUMPPATH/$SUFFIX-$DB-structure.sql $DB >> $LOGFILE
# Dump list of tables and sequences
/usr/lib/postgresql/10/bin/psql $CONNECT -d $DB -t -c "$LIST_TABLES" > $DUMPPATH/$SUFFIX-$DB-table_seq.txt
/usr/lib/postgresql/10/bin/psql $CONNECT -d $DB -t -c "$LIST_SEQ" >> $DUMPPATH/$SUFFIX-$DB-table_seq.txt
# Dump DB data
/usr/lib/postgresql/10/bin/pg_dump $CONNECT -Z 6 -O -f $DUMPPATH/$SUFFIX-$DB-data.sql.gz $DB >> $LOGFILE 2>&1
EXIT=$?
if [ "$EXIT" -ne "0" ];
then
        echo "$(date) - Error with DB data backup ; Exit code: $EXIT"
        #echo "$(date) - Error with DB data backup ; Exit code: $EXIT" |mail -s "PROD ABP - DB BKP Error" it-support@lit-transit.com
fi
#/bin/date >> $LOGFILE
#echo "Deleting WAL archive older than 24h on prodsql1" >> $LOGFILE
#/usr/bin/ssh prodsql1 "/bin/find $WALDIR/ -amin +1440 -delete"
echo "######## DB backup finished #########" >> $LOGFILE

