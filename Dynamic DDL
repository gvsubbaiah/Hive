#below script will useful when creating tables ddl from other database by refering. 

env='${hivevar:ENV}'
HDFSPath='${hivevar:HDFSPath}' 
for line in $(cat tablelist.txt)
do 
  echo "Running $line "
  ddl="/ddls/${line}.hql"
  stmt="CREATE  EXTERNAL TABLE ${env}.$line ("
  desc=$(hive -e "desc $db.$line" | sed '/ods/,+5d' | sed '$!s/$/,/')
  stmt2=")\nPARTITIONED BY(ODS STRING)\nROW FORMAT DELIMITED\nFIELDS TERMINATED BY '|'\nSTORED AS ORC\nLOCATION '${HDFSPath}/$db/${line}';\n"
  echo -e $stmt $desc $stmt2 | sed 's/,/,\n/g' >>${ddl}
done 
