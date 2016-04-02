
'reinit'
* center of cities
* China
city.1="Beijing" 
 lat.1=39.907
 lon.1=116.397

city.2="Shanghai" 
 lat.2=31.222 
 lon.2=121.458

city.3="Xi''an" 
 lat.3=34.277 
 lon.3=108.948

city.4="Guangzhou" 
 lat.4=23.15
 lon.4=113.25

city.5="Shenyang"
 lat.5=41.8
 lon.5=123.4

city.6="Tangshan"
 lat.6=39.65 
 lon.6=118.18 

city.7="Shijiazhuang"
 lat.7=38.04
 lon.7=114.51 

city.8="Zibo"
 lat.8=36.83 
 lon.8=118.07 

city.9="Zhengzhou"
 lat.9=34.75 
 lon.9=113.63

* color number, defined in si_styles.gs
color.1=400
color.2=600
color.3=040
color.4=090
color.5=066
color.6=229
color.7=306
color.8=606
color.9=926

'open no2_jan.ctl'
'set x 1'
'set y 1'
'set time 1jan2005 1jan2016'
* apply general styles 
'si_styles' 

parea='1 10 0.5 8.0'

ir=1
while (ir <= 9)

'set parea 'parea

* 1-deg box around each city
lon1=lon.ir - 0.75
lon2=lon.ir + 0.75
lat1=lat.ir - 0.75
lat2=lat.ir + 0.75

'set vrange 0 6000' 
'set cthick 12'
'set cmark 0' 
'set ccolor 'color.ir
'set grid off' 
'define ts=aave(no2, lon='lon1', lon='lon2', lat='lat1', lat='lat2')' 
'd ts' 
'draw title 'city.ir

ir = ir + 1
endwhile 

'gxprint China-cities-jan.png png x1000 y800 white' 


