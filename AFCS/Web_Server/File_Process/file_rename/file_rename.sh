#!/bin/bash


#Here we delete old files

cd /home/nec/afc/backend/idms/server/file-server/ftp/tran/file_rename/output/

/bin/rm -rf *


#Here we process dupplicated folder files

cd /home/nec/afc/backend/idms/server/file-server/ftp/tran/file_rename/input/

ls -ltrh > /home/nec/afc/backend/idms/server/file-server/ftp/tran/file_rename/file_list.txt

while read line
do
i=`echo ${line} |awk -F' ' '{print $9}'`

J=`echo ${i}| cut -b 1-35,51-54`

K=`echo "$J"`

Y=`echo "$K"`

#cd /home/nec/afc/backend/idms/server/file-server/ftp/tran/file_rename/input/

/bin/mv ${i} ${Y}

/bin/mv ${Y} /home/nec/afc/backend/idms/server/file-server/ftp/tran/file_rename/output/

done < /home/nec/afc/backend/idms/server/file-server/ftp/tran/file_rename/file_list.txt

/bin/mv /home/nec/afc/backend/idms/server/file-server/ftp/tran/file_rename/output/* /home/nec/afc/backend/idms/server/file-server/ftp/tran/temp_data/

