
* compute DJF average 

'reinit' 

'open no2_monthly.ctl'
'set time 1jan2006 1feb2016'
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

 'set x 1 2880'
 'set y 1 1440'
 'define djf=(no2(t-1)+no2+no2(t+1))/3' 
 'set undef -999.0'
 'set gxout fwrite' 
 'set fwrite -st DJF/'tstr
 'd djf' 
 'disable fwrite' 
 
t1=t1+12 
endwhile

