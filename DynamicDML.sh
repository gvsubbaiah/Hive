tbls=$(ls <path>/*.hql | awk -F "/" '{print $NF}' | sed 's/.hql//g')
for tbl in ${tbls[@]}
do
	env='${hivevar:ENV}'
	stmt=$(echo "SELECT 'RUNNING ${db}.$tbl';\n\nINSERT INTO TABLE ${db}.$tbl \nPARTITION (ODS) \nSELECT \n")
	cols=$(hive -e "show columns in ${db}.$tbl")
	cols=$(echo $cols | tr ' ' ',')
	cdl='${hivevar:CDL}'
	ods='${hivavar:ODS}'
	stmt2=$(echo "\nfrom \n${cdl}.$tbl\nWHERE ODS='${ods}';\n\n")
	ct=$(echo $stmt $cols $stmt2)
	echo -e $ct | sed 's/,/,\n/g' >>${ROOT}/log/${tbl}.hql
done
