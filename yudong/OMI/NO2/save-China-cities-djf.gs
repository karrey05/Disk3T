* 4/3/16: add saving data to text file 
*4/2/16: do now use absolute units. Use Beijing 2005 value as baseline value
'reinit'
* center of cities
* China
city.1="Beijing" 
 lat.1=39.907
 lon.1=116.397

city.2="Shanghai" 
 lat.2=31.222 
 lon.2=121.458

city.3="Xian" 
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

city.10="E_China"
 lat.10=34.75 
 lon.10=113.63

city.11="Tianjin"
 lat.11=39.1 
 lon.11=117.2

city.12="Taiyuan"
 lat.12=37.87 
 lon.12=112.55

city.13="Jinan"
 lat.13=36.65 
 lon.13=117.12 

city.14="Hefei"
 lat.14=31.83 
 lon.14=117.23

city.15="Wuhan"
 lat.15=30.58 
 lon.15=114.29

'open no2_djf.ctl'
'set x 1'
'set y 1'
'set time 1jan2005 1jan2016'

parea='1 10.5 1.0 8.3'

ir=1
while (ir <= 15)

'set parea 'parea

* 1.5-deg box around each city
lon1=lon.ir - 0.75
lon2=lon.ir + 0.75
lat1=lat.ir - 0.75
lat2=lat.ir + 0.75

if (ir = 10) 
*Eastern China 
  lon1=110
  lon2=123
  lat1=30
  lat2=41
endif 

'define ts=aave(no2, lon='lon1', lon='lon2', lat='lat1', lat='lat2')' 
* set up Bejing baseline value 
if (ir = 1) 
  'define base=ts(t=1)' 
endif

'set gxout print'
'set prnopts %10.1f 1 1'
'd ts/base' 

dummy=write('csv/'city.ir'.txt', result)
dummy=close('csv/'city.ir'.txt')

ir = ir + 1
endwhile 



