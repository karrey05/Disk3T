
'reinit'

'open no2_djf.ctl'
'set lat 20 44' 
'set lon 102 142' 
* apply general styles 
'si_styles' 

parea='1 10.5 0.5 8.0'

'set parea 'parea
'set mpdset hires'

'set time 1jan2012' 
'set gxout kml' 
'set kml -poly 2012.kml'
'set clevs 0 500 1000 1500 2000 2500 3000 3500' 
*'set ccols 988 966 944 922 900 800 600 400 200'
'd maskout(no2, no2-500)'

'c' 
'si_styles'
'set parea 'parea
'set mpdset hires'

'set time 1jan2016' 
'set gxout kml' 
'set kml -poly 2016.kml'
'set clevs 0 500 1000 1500 2000 2500 3000 3500'
*'set ccols 988 966 944 922 900 800 600 400 200'
'd maskout(no2, no2-500)'





