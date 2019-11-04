#!/bin/bash

cd /home/nec/afc/backend/idms/server/file-server/ftp/tran/temp_data/

ls -lrth >/home/nec/afc/backend/idms/server/file-server/ftp/tran/file_name.txt

while read line
do

i=`echo ${line} |awk -F' ' '{print $9}'`
Y=`echo "$i"`
/bin/mv ${Y} /home/nec/afc/backend/idms/server/file-server/ftp/tran/data/

sleep 0.25

done < /home/nec/afc/backend/idms/server/file-server/ftp/tran/file_name.txt


