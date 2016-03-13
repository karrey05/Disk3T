
ddir=/media/Disk3T/Team/yudong/GSOD

#for year in `seq 2000 2015`; do 
for year in `seq 1990 1999`; do 

  mkdir -p $ddir/$year 
  cd $ddir/$year
  wget -nH -nd ftp://ftp.ncdc.noaa.gov/pub/data/gsod/$year/gsod_$year.tar

done




