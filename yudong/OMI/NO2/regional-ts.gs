
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
lon.2.2=-87.6818
*city.2.2="New York"
*lat.2.2=40.7
*lon.2.2=-74.0 
city.3.2="Milan"
lat.3.2=45.465
lon.3.2=9.1836 
*city.4.2="London"
*lat.4.2=51.510
*lon.4.2=-0.130 
city.4.2="New Delhi"
lat.4.2=28.6
lon.4.2=77.23

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

* 1-deg box around each city
lon1=lon.ir.ic - 0.75
lon2=lon.ir.ic + 0.75
lat1=lat.ir.ic - 0.75
lat2=lat.ir.ic + 0.75

* customize graphics
'set xlopts 1 0.5 0.15'
'set ylopts 1 0.5 0.15'
'set cthick 6'
'set cmark 0'
'set font 5'
'set font 10 file /usr/share/fonts/truetype/freefont/FreeSans.ttf'
'set font 11 file /usr/share/fonts/truetype/freefont/FreeSansBold.ttf'
'set font 12 file /usr/share/fonts/truetype/droid/DroidSans.ttf'
'set grid vertical' 

'set vrange 0 4000' 
'define ts=aave(no2, lon='lon1', lon='lon2', lat='lat1', lat='lat2')' 
'd ts' 
'draw title 'city.ir.ic

 ic=ic+1
endwhile 

ir = ir + 1
endwhile 

'set rgb 60 255 255 255  10'
'gxyat -x 800 -y 1000 2x4-ts-cities.png' 
*'printim 2x4-ts-cities.gif x800 y1000 white'
'gxprint 2x4-ts-cities.svg svg white'


