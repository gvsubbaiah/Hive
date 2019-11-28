#to include the current database in the Hive prompt
set hive.cli.print.current.db=true;

--hiveconf hive.root.logger=DEBUG,console
--hiveconf hive.cli.errors.ignore=true 

OPTIMIZATION
set hive.auto.convert.join=true;
SET hive.optimize.ppd=true;
SET hive.optimize.ppd.storage=true;
SET hive.vectorized.execution.enabled=true;
SET hive.vectorized.execution.reduce.enabled=true;
set hive.vectorized.execution.reduce.groupby.enabled=true;
SET hive.cbo.enable=true;
SET hive.compute.query.using.stats=true;
SET hive.stats.fetch.column.stats=true;
SET hive.stats.fetch.partition.stats=true;
SET hive.tez.auto.reducer.parallelism=true;
SET hive.tez.max.partition.factor=20;
SET hive.exec.reducers.bytes.per.reducer=128000000;
set hive.tez.container.size=10240;
set tez.am.resource.memory.mb=16384;
set hive.tez.java.opts=-Xmx3270m;
set mapreduce.map.memory.mb=2048;
set mapreduce.reduce.memory.mb=4096;
set mapreduce.map.java.opts=-Xmx1638m;
set mapreduce.reduce.java.opts=-Xmx3276m;
set tez.grouping.max-size = 268435456;
set hive.exec.parallel.thread.number=16;

Multi SerDe Format: 
ROW FORMAT SERDE 'org.apache.hadoop.hive.contrib.serde2.MultiDelimitSerDe'
WITH SERDEPROPERTIES (
    "field.delim"="§")
stored as textfile
tblproperties("skip.header.line.count"="1", "skip.footer.line.count"="1");
