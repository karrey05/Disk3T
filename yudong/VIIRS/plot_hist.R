
# histogram  of NCC lab data

#xdef 4445  linear  -10.0 0.009
#ydef 3334  linear  30.0  0.009
nc=4445
nr=3334
fid = file('ncc_d20160407.bin', 'rb') 
alb = readBin(fid, numeric(), n=nc*nr, size=4, endian='little') 
close(fid) 


#valid range 0 ~ 200

amin=  0.01
amax = 200 
nbreaks = 40 # log scale
dx = (log(amax)-log(amin)) / nbreaks
xbreaks = exp(dx)^(0:nbreaks)*amin 

ahist = hist(alb[alb > amin & alb < amax], breaks=xbreaks, plot=F )
plot(ahist, log='x', xlim=c(amin, amax), xlab='Reflectance', axes=F, main="Histogram of VIIRS NCC Reflectance") 

labv=0.125*2^(0:8)
axis(1, at=labv, labels=as.character(labv))
axis(2) 

dev.copy(postscript, "NCC_hist.ps") 


