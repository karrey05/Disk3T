
* center of cities
* China

'reinit' 

'open no2_monthly.ctl'
'set lat 10 50' 
'set lon 60 140' 
'set time 1jan2005 1feb2016'
 'q dims'
 line=sublin(result, 5)
 t1=subwrd(line, 11)
 t2=subwrd(line, 13)

while(t1 <= t2) 
 'c' 
 'set mpdset hires' 
 'set t 't1
 'q dims'
 line=sublin(result, 5)
* 00Z01MAR2005 -> MAR2005
 line2=subwrd(line, 6)
 tstr=substr(line2, 6, 12) 
 'set grads off'
*'set mproj scaled'
 'set xlopts 1 0.5 0.15'
 'set ylopts 1 0.5 0.15'
 'set clevs 0 500 1000 1500 2000 2500 3000 3500 4000' 
 'set gxout shaded' 
 'd no2' 
* 'cbarn' 
 'draw title NO2 'tstr 
* gxyat does not support gif 
 'gxyat -x 800 -y 600 movie/'t1'.png' 
* 'printim movie/'t1'.gif x800 y600 white' 

t1=t1+1 
endwhile

