
'reinit'

'open no2_djf.ctl'
'set lat 20 44' 
'set lon 102 130' 
* apply general styles 
'si_styles' 

parea='1 10.5 0.5 8.0'

'set parea 'parea
'set mpdset hires'

'set time 1jan2012' 
'set gxout shaded' 
'set clevs 0 500 1000 1500 2000 2500 3000 3500' 
'd no2' 
'draw title 2012'
'gxprint China-2012-djf.png png x1200 y800 white' 

'c' 
'si_styles'
'set parea 'parea
'set mpdset hires'

'set time 1jan2016' 
'set gxout shaded'
'set clevs 0 500 1000 1500 2000 2500 3000 3500'
'd no2'
'draw title 2016'
'gxprint China-2016-djf.png png x1200 y800 white'




