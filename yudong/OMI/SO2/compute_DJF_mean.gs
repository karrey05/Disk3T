
* compute DJF average 

'reinit' 

'open monthly.ctl'
'set time 1jan2005 1feb2016'
'q dims'
 line=sublin(result, 5)
 t1=subwrd(line, 11)
 t2=subwrd(line, 13)

while(t1 <= t2) 
 
  
 'set t 't1
 'q dims'
 line=sublin(result, 5)
 ts=subwrd(line, 6)
 tstr=substr(ts, 9, 12)

 'set x 1 1440'
 'set y 1 720'
* starting from jan 2005
if ( t1 = 1 ) 
 'define djf=(const(so2, 0, -u) + const(so2(t+1), 0, -u) )/2' 
else 
 'define djf=(const(so2(t-1), 0, -u) + const(so2, 0, -u) + const(so2(t+1), 0, -u) )/3' 
endif 
 'set undef -999.0'
 'set gxout fwrite' 
 'set fwrite -st DJF/'tstr
 'd djf' 
 'disable fwrite' 
 
t1=t1+12 
endwhile

