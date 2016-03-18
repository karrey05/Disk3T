#! /bin/bash 

# Download MYD04_L2
wkdir=/home/yudong/data/MODIS/AOD/MYD04_L2

# date range. It starts from Jul. 4, 2002
sdate="7/5/2002"    # mm/dd/yyyy
edate="12/31/2003" 

sec0=`date -u -d "$sdate" +%s`
sec1=`date -u -d "$edate" +%s`
let days=(sec1-sec0)/86400

for day in `seq 0 $days`; do
  t1=`date -u -d "$sdate $day day"`  
  cyr=`date -u -d "$t1" +%Y`    # 1994
  yod=`date -u -d "$t1" +%j`
  cmn=`date -u -d "$t1" +%m`
  cdy=`date -u -d "$t1" +%d`

  mkdir -p $wkdir/$cyr/$cmn/$cdy
  cd $wkdir/$cyr/$cmn/$cdy
  wget ftp://ladsweb.nascom.nasa.gov/allData/6/MYD04_L2/$cyr/$yod/MYD04_L2.*.hdf 
  
done 

#sample URL 
#ftp://ladsweb.nascom.nasa.gov/allData/6/MYD04_L2/2016/032/MYD04_L2.A2016032.0245.006.2016033002646.hdf

