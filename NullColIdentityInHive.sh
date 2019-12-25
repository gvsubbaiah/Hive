#!/bin/bash
#================================================#
#Author: Venkata Subbaiah Ganamanthu
#Created on: 25th March 2017
#Purpose: To identify null columns in hive table
#usage: Have to pass to params 1. database name,2. tablname
#ex: hivtb.sh prac test
#================================================#

dbname=$1
tblname=$2

if [ -z $dbname ]; then
echo "Please provide database name"
exit
else
echo "Proivded database name is :" "$dbname"
fi

if [ -z $tblname ]; then
echo "Please provide tablename"
exit
else
echo "Provided tablename is:" "$tblname"
fi

dblist=`hive -S -e "show databases" | awk '{print $1}'| sed '/^WARN:/d'`
echo $dblist | grep -w $dbname 
if [ $? -ne 0 ]; then
echo "$dbname" ' database does not exist'
exit
fi	

tblist=`hive -S -e "use "$dbname";show tables" | awk '{print $1}' | sed '/^WARN:/d'`
echo $tblist | grep -w $tblname
if [ $? -ne 0 ]; then
echo "$tblname" ' table does not exist in ' "$dbname"
exit
fi

lstcol=`hive -S -e "describe $dbname.$tblname" | awk '{print $1}' | sed '/^WARN:/d'` 

col=`echo $lstcol | sed s/WARN://g`

for i in $col; do
hive -S -e "set hive.execution.engine=tez;select '$i' from $dbname.$tblname where (CASE  length("$i") when 0 then 0 end) = 0" | awk '{print $1}' | sed '/^WARN:/d' >> `pwd`"/colslog.txt"
done

fname=`pwd`"/colslog.txt"

sed -i '/^$/d' $fname

collist=`sed 'N;s/\n/','/' $fname`

if [ `$fname wc != 0]; then
echo "The following columns ($collist) are contains null values in $dbname.$tblname" >> `pwd`/"$dbname"_"$tblname"_`date +"%Y%m%d_%H%M%S"`.txt
fi

rm -r $fname

