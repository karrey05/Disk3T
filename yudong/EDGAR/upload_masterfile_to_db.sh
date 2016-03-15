
# create db 
cat > create_db.cql <<EOF
CREATE KEYSPACE edgar
WITH replication = {'class':'SimpleStrategy', 'replication_factor' : 1};

use edgar; 

create table master_table ( 
 cik	        ascii,
 company_name   ascii,
 form_type	ascii,
 date_filed     timestamp,
 filename       ascii,
PRIMARY KEY (cik, company_name, form_type, date_filed) 
); 

EOF

#cqlsh --file create_db.cql 

echo "use edgar;" > copy_mfile.cql 

for year in `seq 1993 2015`; do 
  for qtr in 1 2 3 4; do 
  
   gunzip $year/QTR$qtr/master.gz 
   
   cat >> copy_mfile.cql <<EOF2
copy master_table (cik, company_name, form_type, date_filed, filename) 
 from '$year/QTR$qtr/master' with DELIMITER='|' and ESCAPE='' and NUMPROCESSES=1 and SKIPROWS=10; 

EOF2

  done 
done 
   
cqlsh --file copy_mfile.cql 



