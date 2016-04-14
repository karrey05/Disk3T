
export INC_HDF=/usr/include
export LIB_HDF=/usr/lib/x86_64-linux-gnu

 gfortran -c Type_Kinds.f90
 gfortran -I. -c Endian_Utility.f90
 gfortran -I. -I$INC_HDF -c reproj.F90 
 gfortran -I. -I$INC_HDF -L$LIB_HDF -o reproj reproj.o Type_Kinds.o Endian_Utility.o -lhdf5 -lhdf5_fortran


 gfortran -c ncc_to_kml.F90
 gfortran -I. -I$INC_HDF -c read_alb_geo.F90
 gfortran -I. -I$INC_HDF -L$LIB_HDF -o ncc_to_kml ncc_to_kml.o read_alb_geo.o Type_Kinds.o Endian_Utility.o -lhdf5 -lhdf5_fortran

