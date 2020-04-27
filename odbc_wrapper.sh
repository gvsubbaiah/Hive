PARAMS=$1,$2,$3,$4,$5,$6,$7,$8,$9
ROOT=$(dirname $(dirname $0))
OUSR=$3
driverpath=${ROOT}/lib/ojdbc6.jar
config=${ROOT}/config
props=$(echo -e " --driver-memory 2G --executor-cores 3 --executor-memory 5G --conf spark.sparkContext.defaultParallelism=15 --conf  spark.driver.extraClassPath=$driverpath --conf spark.executor.extraClassPath=$driverpath --jars $driverpath --conf spark.ui.port=22890")
rundate=$(date +"%F")

#Removing old log files
rm ${ROOT}/logs/*.log

log=${ROOT}/logs/load_${rundate}_$(date +"%Y%m%d%H%M%S").log
echo -e "$(date +"%F %H:%M:%S") INFO: Process Started" | tee -a $log
pylog=${ROOT}/logs/migration_${rundate}_$(date +"%Y%m%d%H%M%S").log
echo -e "$PARAMS" | tee -a $log
export SPARK_MAJOR_VERSION=2;spark-submit --master yarn $props --queue ${10} ${ROOT}/scripts/ds2hs_v2.py $PARAMS,$OPWD &>>$pylog
errmsg=$(grep ORA $pylog | awk -F ":" '{print $NF}')
grep -i "Recon" $pylog | tee -a $log
if [ ! -z "${errmsg}" ]
then 
	echo ${errmsg} >>${ROOT}/logs/err_${rundate}.log
	grep -i "Input" $pylog >>${ROOT}/log/rerun_${rundate}.txt
else
	grep -i "Input" $pylog >>${ROOT}/logs/completed_${rundate}.txt
fi
echo -e "$(date +"%F %H:%M:%S") INFO: Process Ended" | tee -a $log
