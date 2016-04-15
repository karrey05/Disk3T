
'reinit'
'open alb.ctl'
'set lat 36 57'
'set lon -10 20'
'set mpdset hires'
'set grads off'
'set grid off'
'si_styles'
'set gxout grfill' 
'set clevs 2 4 8 16 32 64 128' 
'set ccols 990 992 994 999 999 999 999' 
'd maskout(maskout(alb, alb-2), 200-alb)'
*Contouring: 20 to 90 interval 10
'gxprint ncc_d20160407.png x5200 y3900 black' 
'gxprint ncc_d20160407-sm.png x2000 y1700 black' 
'quit'


