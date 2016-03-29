#! /bin/bash 

# Download MYD04_L2
wkdir=/home/yudong/data/OMI/NO2

# sample URL 
#http://www.temis.nl/airpollution/no2col/data/omi/data_v2/2016/omi_no2_he5_20160101.tar

# date range. It starts from Oct 1, 2004 
sdate="1/1/2016"    # mm/dd/yyyy
edate="3/28/2016" 

sec0=`date -u -d "$sdate" +%s`
sec1=`date -u -d "$edate" +%s`
let days=(sec1-sec0)/86400

for day in `seq 0 $days`; do
  t1=`date -u -d "$sdate $day day"`  
  cyr=`date -u -d "$t1" +%Y`    # 1994
  yod=`date -u -d "$t1" +%j`
  cmn=`date -u -d "$t1" +%m`    # 02 
  cdy=`date -u -d "$t1" +%d`    # 04 
  ymd=`date -u -d "$t1" +%Y%m%d`   # 19940204

  mkdir -p $wkdir/$cyr
  cd $wkdir/$cyr
  wget http://www.temis.nl/airpollution/no2col/data/omi/data_v2/$cyr/omi_no2_he5_$ymd.tar
  
done 


