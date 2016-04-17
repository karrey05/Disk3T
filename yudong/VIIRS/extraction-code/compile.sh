
export INC_HDF=/usr/include
export LIB_HDF=/usr/lib/x86_64-linux-gnu

 gfortran -c save_raw.F90 
 gfortran -I. -I$INC_HDF -L$LIB_HDF -o save_raw save_raw.o ../read_alb_geo.o ../Type_Kinds.o ../Endian_Utility.o -lhdf5 -lhdf5_fortran

