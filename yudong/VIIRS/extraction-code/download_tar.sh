#! /bin/bash

# Usage: download_tar.sh yyyymmdd 
# download 1-day's worth of NCC tar and associated geo data

host='ftp-npp.class.ngdc.noaa.gov'

 if [ $# -ne 1 ]; then 
   echo "usage: download_tar.sh yyyymmdd"
   exit -1  
 fi

 ymd=$1
 mkdir -p $ymd/NCC 
 mkdir -p $ymd/NCC-Geo

 cdir=`pwd`

 cd $ymd/NCC
  wget ftp://$host/$ymd/VIIRS-EDR/VIIRS-Near-Constant-Contrast-Imagery-EDR/*.tar 
  tar xvf *.tar
  gunzip *.gz
  rm *.tar 

 cd $cdir
 cd $ymd/NCC-Geo
 wget ftp://$host/$ymd/VIIRS-EDR/VIIRS-Near-Constant-Contrast-NCC-EDR-GTM-Geo/*.tar

cd $cdir

 
