
* compute and display linear trend from past 5 winters for over the globe, 
* to identify growing and decaying regions 
'reinit'

'open year_djf.ctl'
'open no2_djf.ctl'
*'si_styles' 

parea='1 10.5 0.5 8.0'

'set parea 'parea
*'set mpdset hires'

'set x 1 2880'
'set y 1 1440'
'set time 1jan2012 1jan2016'  
 'q dims'
 line=sublin(result, 5)
 t1=subwrd(line, 11)
 t2=subwrd(line, 13)

* model: no2.2 = delta + lambda* t 
 
'set t 't2
  
'define xbar=ave(xt, t='t1', t='t2')'
'define sigmax2=ave( (xt-xbar)*(xt-xbar), t='t1', t='t2')'
'define ybar=ave(no2.2, t='t1', t='t2')'
'define xbyb=ave((no2.2-ybar)*(xt-xbar), t='t1', t='t2')'
'define xb2=ave( (xt-xbar)*(xt-xbar), t='t1', t='t2')'
'define lamda=xbyb/xb2'
'define delta=ybar/lamda-xbar'
'define sigma2=ave( (no2.2 - lamda * (xt + delta))*(no2.2 - lamda * (xt + delta)),  t='t1', t='t2')'
'define sigma=sqrt(sigma2)'

* save no2 data for the most recent winter, with threshold imposed 
'set gxout fwrite' 
'set fwrite -le -st 2016_DJF.bin'
'd maskout(no2.2, no2.2-500)' 
'disable fwrite' 

* save no2 growth rate 
'set gxout fwrite' 
'set fwrite -le -st 5_year_trend_DJF.bin'
'd maskout(lamda, no2.2-500)' 
'disable fwrite' 

'quit'




