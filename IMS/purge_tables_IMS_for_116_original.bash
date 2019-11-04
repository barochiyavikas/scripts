#!/bin/bash
#
# Script to dump data and purge tables from PostgreSQL
#
# VARIABLES:
HOME="/home/user/script"
DBUSER="postgres"
DBPASS="postgres"
DBPORT="5432"
DBHOST="127.0.0.1"
DBNAME="IMS_2018"
TABLES="$HOME/tables_columns.txt"
PURGE="10"
LOG="$HOME/logs/purge_tables.log"
TBLDUMPLOC="$HOME/pgdumps/tables"

# Functions

function count_purge_rows {
	echo "$(date) - Counting rows to purge from $table." >> $LOG 2>&1
	PURGEROWS=$(/usr/lib/postgresql/10/bin/psql -U $DBUSER -p $DBPORT -h $DBHOST -d $DBNAME -c "select count(*) from $table where $column IN 
(select proc_inst_id from mdm_incident where incident_date <(current_date - integer '$PURGE')
and status='Close')" |sed -n 3p)
	#SELECT COUNT(*) FROM $table WHERE $column < (current_date - integer '$PURGE')
	echo "$(date) - counting of rows DONE." >> $LOG 2>&1
	echo "$table row count- $PURGEROWS" >> $LOG 2>&1
	}
function dump_data {
	echo "$(date) - Dumping $table by column $column" >> $LOG 2>&1
	if [ ! -d "$TBLDUMPLOC/$table" ]
	then
		/bin/mkdir $TBLDUMPLOC/$table
	fi
	/usr/lib/postgresql/10/bin/psql -U $DBUSER -p $DBPORT -h $DBHOST -d $DBNAME -c "copy (SELECT * FROM $table WHERE $column IN (select proc_inst_id from mdm_incident where incident_date < (current_date - integer '$PURGE'))to stdout" |gzip > $TBLDUMPLOC/$table/$(date +%Y%m%d)-$table.sql.gz
	echo "$(date) - dump data DONE." >> $LOG 2>&1
	}
function count_dump_rows {
	echo "$(date) - Checking dumped row number from $table" >> $LOG 2>&1
	DUMPROWS=$(zcat $TBLDUMPLOC/$table/$(date +%Y%m%d)-$table.sql.gz |wc -l) 
	echo "$(date) - counting of dump rows DONE." >> $LOG 2>&1
	echo "$table count of dump rows - $DUMPROWS" >> $LOG 2>&1
	}
function purge_data {
	echo "$(date) - Purging data from $table" >> $LOG 2>&1
	/usr/lib/postgresql/10/bin/psql -U $DBUSER -p $DBPORT -h $DBHOST -d $DBNAME -c "DELETE FROM $table WHERE $column < (current_date - integer '$PURGE')" >> $LOG 2>&1
	echo "$(date) - purge data DONE." >> $LOG 2>&1
	}
function vacuum_table {
	echo "$(date) - Vacuuming table $table" >> $LOG 2>&1
	/usr/lib/postgresql/10/bin/psql -U $DBUSER -p $DBPORT -h $DBHOST -d $DBNAME -c "VACUUM $table"
	echo "$(date) - vacuum table DONE." >> $LOG 2>&1
	}

	
# Script

export PGPASSWORD="$DBPASS"
echo "################# START #################" >> $LOG 2>&1
echo "$(date) - Starting DB Purge script" >> $LOG 2>&1
while read table column
do
	count_purge_rows
	dump_data
	count_dump_rows
	if [ "$PURGEROWS" -eq "$DUMPROWS" ];
	then
		echo "$(date) - STATUS: OK! Row count for $table: $PURGEROWS = $DUMPROWS." >> $LOG 2>&1
		purge_data
		# If table vacuuming is required uncomment line below
		#vacuum_table
	else
		echo "$(date) - STATUS: NOT OK! Row count for <$table>: $PURGEROWS != $DUMPROWS." >> $LOG 2>&1
	fi
done < $TABLES


echo "$(date)- Script Finished." >> $LOG 2>&1

