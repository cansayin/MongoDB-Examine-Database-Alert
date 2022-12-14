#!/bin/bash

#this script check mongodb logs and send email if an error occurs.



#linkedin : https://www.linkedin.com/in/can-sayın-b332a157/
#cansayin.com



PATH=$PATH:$HOME/.local/bin:$HOME/bin ; export PATH
ALERT_VX=0
path_dest=/data01/log
log_name=mongod.log
logfile=$path_dest/${log_name}
oldlogfile=$path_dest/${log_name}_old
logfile_diff=$path_dest/${log_name}_diff
logfile_diff_codes=$path_dest/${log_name}_diff_error_codes
diff $oldlogfile $logfile > $logfile_diff
cat $logfile_diff | grep -e "Fail" -e "Error " |  grep ^">" > $logfile_diff_codes
host=`hostname`
usep=`cat $logfile_diff_codes | wc -l `
if [ "${usep}" -gt "${ALERT_VX}" ]; then
echo "There is an error on $host" > /tmp/mongo_db_alerts.out
echo "" >> /tmp/mongo_db_alerts.out
echo "" >> /tmp/mongo_db_alerts.out
cat $logfile_diff_codes >> /tmp/mongo_db_alerts.out

tomail='a@aaaa'
frommail=aaa@aaa
smtpmail=smtp.aaa.com
echo "There is an error on $host"  | /bin/mailx -s "$host mongo Error" -r  "$frommail" -S smtp="$smtpmail" $tomail < /tmp/mongo_db_alerts.out
fi
cp -rp $logfile $oldlogfile
