
# upload years of data into Cassandra database 

gsoddir=/home/yudong/data/GSOD
workdir=/home/yudong/data/GSOD/Cassandra


#for year in `seq 2000 2015`; do 
#for year in `seq 1990 1999`; do 

#for year in 2016; do 

#for year in `seq 1990 2015`; do 
for year in 1990; do 
  cd $gsoddir/$year
  tar xvf gsod_$year.tar
  gunzip *-$year.op.gz 
 
  cd $workdir 
  # create cql file for each year 
  cqlfile=${year}.cql

  mkdir $year 
  echo "use time_series;"  > $cqlfile

  for gsod in $gsoddir/$year/*-$year.op; do 
   ofile=`basename $gsod |sed 's/.op$/.csv/'`
   ./gsod-to-csv.sh $gsod > $year/$ofile 

   cat >> $cqlfile <<EOF
    copy gsod (usaf_id,wban_num,event_time,temp,temp_count,dewp,dewp_count,slp,slp_count,stp,stp_count,visib,visib_count,wdsp,wdsp_count,mxspd,gust,max,max_flag,min,min_flag,prcp,prcp_flag,sndp,frshtt) from '$year/$ofile' with HEADER=TRUE; 

EOF
  done 
 ../../apache-cassandra-3.3/bin/cqlsh --file $cqlfile
done




