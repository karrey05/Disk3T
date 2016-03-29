#! /bin/bash 

wkdir=/home/yudong/data/OMI/NO2/monthly

# sample URL 
#http://www.temis.nl/airpollution/no2col/data/omi/data_v2/2016/01/no2_201601.grd.gz

#for year in 2016; do 
#  for mon in 01 02; do 
for year in `seq 2005 2015`; do 
  for mon in 01 02 03 04 05 06 07 08 09 10 11 12; do 
  cd $wkdir
  wget http://www.temis.nl/airpollution/no2col/data/omi/data_v2/$year/$mon/no2_$year$mon.grd.gz

  done 
done 


