
# sample URL:  ftp://ftp.sec.gov/edgar/full-index/2015/QTR1/master.gz
for year in `seq 1993 2014`; do 
#for year in 2015; do 
  for qtr in 1 2 3 4; do 
  
  mkdir -p $year/QTR$qtr
  wget -O $year/QTR$qtr/master.gz ftp://ftp.sec.gov/edgar/full-index/$year/QTR$qtr/master.gz

 done 
done 

