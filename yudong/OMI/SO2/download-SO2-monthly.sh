#! /bin/bash 

wkdir=/home/yudong/data/OMI/SO2/monthly

# sample URL 
# http://avdc.gsfc.nasa.gov/pub/data/satellite/Aura/OMI/V03/L3/OMSO2m/OMSO2_0.25x0.25_monthly/2005/200501.txt

# it starts from Jan. 2005
#for year in `seq 2005 2015`; do 
#  for mon in 01 02 03 04 05 06 07 08 09 10 11 12; do 
for year in 2016; do 
  for mon in 01 02; do 
  cd $wkdir
  wget http://avdc.gsfc.nasa.gov/pub/data/satellite/Aura/OMI/V03/L3/OMSO2m/OMSO2_0.25x0.25_monthly/$year/$year$mon.txt

  done 
done 




