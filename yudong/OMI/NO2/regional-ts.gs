
* center of cities
* China
* .row.col
city.1.1="Beijing" 
lat.1.1=39.907
lon.1.1=116.397
city.2.1="Shanghai" 
lat.2.1=31.222 
lon.2.1=121.458
city.3.1="Xian" 
lat.3.1=34.277 
lon.3.1=108.948
city.4.1="Guangzhou" 
lat.4.1=23.117 
lon.4.1=113.25

*US/EU
* .row.col
city.1.2="Los Angeles"
lat.1.2=34.0194
lon.1.2=-118.4108 
city.2.2="Chicago"
lat.2.2=41.8376
lon.2.2=87.6818
city.3.2="London"
lat.3.2=51.510
lon.3.2=-0.130 
city.4.2="Milan"
lat.4.2=45.465
lon.4.2=9.1836 

'reinit' 

'open no2_monthly.ctl'
'set x 1'
'set y 1'
'set time 1jan2005 1feb2016'

parea='0.7 8 0.5 4.5'
cols=2
rows=4
hgap=0.1
vgap=0.2
vh=11/rows
vw=8.5/cols

ir=1
while (ir <= rows)
 ic=1
 while (ic <= cols)

*compute vpage
 vx1=(ic-1)*vw+hgap
 vx2=ic*vw-hgap
 vy1=(rows-ir)*vh+vgap
 vy2=vy1+vh-vgap

'set vpage 'vx1' 'vx2' 'vy1' 'vy2
'set grads off'
'set parea 'parea
'set xlopts 1 0.5 0.15'
'set ylopts 1 0.5 0.15'

* 1-deg box around each city
lon1=lon.ir.ic - 0.75
lon2=lon.ir.ic + 0.75
lat1=lat.ir.ic - 0.75
lat2=lat.ir.ic + 0.75

'define ts=aave(no2, lon='lon1', lon='lon2', lat='lat1', lat='lat2')' 
'd ts' 
'draw title 'city.ir.ic

 ic=ic+1
endwhile 

ir = ir + 1
endwhile 

'gxyat -x 800 -y 1000 2x4-ts-cities.png' 


