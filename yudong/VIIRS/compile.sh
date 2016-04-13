
export INC_HDF=/usr/include
export LIB_HDF=/usr/lib/x86_64-linux-gnu

 gfortran -I$INC_HDF -c reproj.F90 
 gfortran -I$INC_HDF -L$LIB_HDF -o reproj reproj.F90 -lhdf5 -lhdf5_fortran
