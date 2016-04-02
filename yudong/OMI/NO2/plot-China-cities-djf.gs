
'reinit'
* center of cities
* China
city.1="Beijing" 
 lat.1=39.907
 lon.1=116.397

city.2="Shanghai" 
 lat.2=31.222 
 lon.2=121.458

city.3="Xi'an" 
 lat.3=34.277 
 lon.3=108.948

city.4="Guangzhou" 
 lat.4=23.15
 lon.4=113.25

city.5="Nanjing"
 lat.5=32.06
 lon.5=118.79

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

city.10="E. China"
 lat.10=34.75 
 lon.10=113.63

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
color.10=900

'open no2_djf.ctl'
'set x 1'
'set y 1'
'set time 1jan2006 1jan2016'
* apply general styles 
'si_styles' 

parea='1 10 0.5 8.0'

ir=1
while (ir <= 10)

'set parea 'parea

* 1.5-deg box around each city
lon1=lon.ir - 0.75
lon2=lon.ir + 0.75
lat1=lat.ir - 0.75
lat2=lat.ir + 0.75

if (ir > 9) 
*Eastern China 
  lon1=110
  lon2=123
  lat1=30
  lat2=41
endif 

'set vrange 500 4500' 
'set cthick 12'
'set cmark 0' 
'set ccolor 'color.ir
'set grid off' 
'define ts=aave(no2, lon='lon1', lon='lon2', lat='lat1', lat='lat2')' 
'd ts' 
'set strsiz 0.18'
'set string 'color.ir
ypos=8-ir*0.3
'draw string 1.5 'ypos' 'city.ir

ir = ir + 1
endwhile 

'gxprint China-cities-djf.png png x1200 y800 white' 


