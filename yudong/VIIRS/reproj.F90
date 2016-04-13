program reproj

! Read NCC data and save to 0.01-deg lat/lon 

      use hdf5 

      implicit none

      ! for reprojection
      real, parameter :: lat0=-89.995, lon0=-179.995, res=0.01
      integer, parameter :: nc=3600, nr=1800  ! lat/lon grid
      integer :: ic, ir, iargc
      real (kind=4), allocatable :: lon(:, :), lat(:, :), factor(:) 
      !integer*2, allocatable :: ialb(:, :) 
      real*4 :: oalb(nc, nr) 
      character, allocatable :: calb(:)
      integer, allocatable :: ialb(:, :) 

      ! declarations
      integer (kind=4) :: fid,swid,status,astat
      integer (hsize_t) :: rank,dims(2),maxdims(2), datatype,i,j, nx, ny, ix
      character (len=255) :: dimlist

      !======= choose the file and field to read
      character (len=228) :: nccfile, geofile, ofile ! input and output file names 
      character*100,   parameter    :: ncc_name = "/All_Data/VIIRS-NCC-EDR_All/Albedo"
      character*100,   parameter    :: ncc_factors_name = "/All_Data/VIIRS-NCC-EDR_All/AlbedoFactors"
      character*100,   parameter    :: lon_name = "longitude"
      character*100,   parameter    :: lat_name = "latitude"
      integer(hid_t)                :: file_id, sm_gr_id,sm_field_id
      integer(hid_t)                :: lon_id, lat_id 
      integer(hid_t)                :: dataspace

      i =  iargc()
      If (i.ne.3) Then   ! wrong cmd line args, print usage
         write(*, *)"Usage:"
         write(*, *)"reproj ncc_file_in geo_file_in bin_file_out"
         stop
      End If

     call getarg(1, nccfile)
     call getarg(2, geofile)
     call getarg(3, ofile)
      
      !======= open the interface 
      call h5open_f(status) 
      if (status .ne. 0) write(*, *) "Failed to open HDF interface" 
      
      call h5fopen_f(nccfile, H5F_ACC_RDONLY_F, file_id, status) 
      if (status .ne. 0) write(*, *) "Failed to open HDF file" 
      
!      call h5gopen_f(file_id,sm_gr_name,sm_gr_id, status)
!      if (status .ne. 0) write(*, *) "Failed to get group: ", sm_gr_name 

      call h5dopen_f(file_id, ncc_name,sm_field_id, status)
      if (status .ne. 0) write(*, *) "Failed to get dataset: ", ncc_name 

      call h5dget_space_f(sm_field_id, dataspace, status)
      if (status .ne. 0) write(*, *) "Failed to get dataspace id" 

      CALL h5sget_simple_extent_dims_f(dataspace, dims, maxdims, status)
      if (status .lt. 0) write(*, *) "Failed to get dims, status=", status 

      nx = dims(1) 
      ny = dims(2) 
      write(*, *)"nx = ", nx, "  ny=", ny
      !allocate(ialb(nx, ny)) 
      allocate(calb(nx*ny*2)) 
      allocate(ialb(nx, ny)) 
      allocate(lat(nx, ny)) 
      allocate(lon(nx, ny)) 

      call h5dread_f(sm_field_id, H5T_STD_U16BE, calb, dims, status)
      !call h5dread_f(sm_field_id, H5T_STD_U16BE, ialb, dims, status)
      !call h5dread_f(sm_field_id, H5T_NATIVE_REAL, ialb, dims, status)
      if (status .ne. 0) write(*, *) "Failed to read sm" 
 
#if 0
      Do ic=1, nx
       Do ir = 1, ny*2, 2
         i=ir+(ic-1)*ny*2 
         ix = (ir+1)/2
         ialb(ix, ic) = ichar(calb(i))*256+ichar(calb(i+1)) 
       End do 
      End Do 
#endif
      Do ir = 1, ny
       Do ic=1, nx*2, 2
         i=ic+(ir-1)*nx*2 
         ix = (ic+1)/2
         ialb(ix, ir) = ichar(calb(i))*256+ichar(calb(i+1)) 
       End do 
      End Do 
      Do ir=1, ny
        Do ic=1, nx
          write(*, '(3I7)')ir, ic,  ialb(ic, ir) 
        End Do 
      End Do 
   
        

#if 0

      call h5dopen_f(sm_gr_id, lon_name, lon_id, status)
      if (status .ne. 0) write(*, *) "Failed to get lon_id" 

      call h5dread_f(lon_id, H5T_NATIVE_REAL, lon, dims, status)
      if (status .ne. 0) write(*, *) "Failed to read lon" 

      call h5dopen_f(sm_gr_id, lat_name, lat_id, status)
      if (status .ne. 0) write(*, *) "Failed to get lat_id" 

      call h5dread_f(lat_id, H5T_NATIVE_REAL, lat, dims, status)
      if (status .ne. 0) write(*, *) "Failed to read lat" 

#endif
      call h5fclose_f(file_id, status)  
      call h5close_f(status) 

#if 0
      ! reprojection
      do j=1, nx 
             ir = nint ( (lat(j) - lat0 )/res ) + 1
             ic = nint ( (lon(j) - lon0 )/res ) + 1
             osm(ic, ir) = sm(j) 
      end do 
     
      write(*, *) "Saving binary format ...", nc, nr
      open(22, file=ofile, form="unformatted", access="direct", recl=nc*nr*4) 
          write(22, rec=1) osm 
      close(22) 
#endif
       
end program reproj 
