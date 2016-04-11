
# DJF
for year in 2012 2016; do 
 # remove existing kmz because zip will accumulate
 rm ${year}_DJF_global.kmz

./convert_bin_to_kml 1000 4500 DJF/$year ${year}_DJF_global.kml 

zip ${year}_DJF_global.kmz ${year}_DJF_global.kml

scp ${year}_DJF_global.kmz ec2-user@cloud.big3k.org:/data/www/free/no2/

done 


for year in 2012 2015; do
 # remove existing kmz because zip will accumulate
 rm ${year}_JJA_global.kmz

./convert_bin_to_kml 1000 4500 JJA/$year ${year}_JJA_global.kml

zip ${year}_JJA_global.kmz ${year}_JJA_global.kml

scp ${year}_JJA_global.kmz ec2-user@cloud.big3k.org:/data/www/free/no2/

done

