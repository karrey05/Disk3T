
'reinit'
'open alb.ctl'
'set lat 40 50'
'set lon 0 20'
'set mpdset hires'
'set grads off'
'set grid off'
'set gxout shaded'
'set clevs 2 4 8 16 32 64 128'
'd maskout(maskout(alb, alb-2), 100-alb)'
*Contouring: 20 to 90 interval 10
'cbar'
'gxprint ncc_d20160407.png x1000 y800 black' 


