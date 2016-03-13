#! /bin/bash 
#download up-to-date station history 

ddir=/media/Disk3T/Team/yudong/GSOD

cd $ddir 

histf=isd-history.csv 
new_histf=new_isd-history.csv   # with date format changed 

wget -O $histf ftp://ftp.ncdc.noaa.gov/pub/data/noaa/$histf

./transform_history.pl > $new_histf 

cat > upload_history.cql <<EOF
use time_series; 
copy station_history (usaf_id, wban_num, station_name, country, state, icao, lat, lon, elev, start_time, end_time) from '$new_histf' with NUMPROCESSES=1;
EOF

/home/yudong/data/apache-cassandra-3.3/bin/cqlsh --file upload_history.cql

exit 
# sample lines 
"999999","94996","LINCOLN 11 SW","US","NE","","+40.695","-096.854","+0418.2","20020114","20160310"
"999999","96404","TOK 70 SE","US","AK","","+62.737","-141.208","+0609.6","20110924","20160310"
"999999","96406","RUBY 44 ESE","US","AK","","+64.502","-154.130","+0078.9","20140828","20160309"

