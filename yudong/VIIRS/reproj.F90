program reproj

! Read NCC data and save to 0.01-deg lat/lon 

      use hdf5 
      use endian_utility

      implicit none

      ! for reprojection
      real, parameter :: lat0=-89.995, lon0=-179.995, res=0.01
      integer, parameter :: nc=36000, nr=18000  ! lat/lon grid
      integer :: ic, ir, iargc
      real (kind=4), allocatable :: lon(:, :), lat(:, :), factor(:) 
      !integer*2, allocatable :: ialb(:, :) 
      real*4 :: oalb(nc, nr) , c1, c2
      character, allocatable :: calb(:)
      integer, allocatable :: ialb(:, :) 
      real, allocatable :: factors(:) 

      ! declarations
      integer (kind=4) :: fid,swid,status,astat
      integer (hsize_t) :: rank,dims(2),maxdims(2), fdims(1), datatype,i,j, nx, ny, ix, nf
      character (len=255) :: dimlist

      !======= choose the file and field to read
      character (len=228) :: nccfile, geofile, ofile ! input and output file names 
      character*100,   parameter    :: ncc_name = "/All_Data/VIIRS-NCC-EDR_All/Albedo"
      character*100,   parameter    :: ncc_factors_name = "/All_Data/VIIRS-NCC-EDR_All/AlbedoFactors"
      character*100,   parameter    :: lon_name = "/All_Data/VIIRS-NCC-EDR-GEO_All/Longitude" 
      character*100,   parameter    :: lat_name = "/All_Data/VIIRS-NCC-EDR-GEO_All/Latitude"
      integer(hid_t)                :: file_id, field_id
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

      call h5dopen_f(file_id, ncc_name, field_id, status)
      if (status .ne. 0) write(*, *) "Failed to get dataset: ", ncc_name 

      call h5dget_space_f(field_id, dataspace, status)
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

      call h5dread_f(field_id, H5T_STD_U16BE, calb, dims, status)
      if (status .ne. 0) write(*, *) "Failed to read sm" 

      ! get scale factors 
      call h5dopen_f(file_id, ncc_factors_name, field_id, status)
      if (status .ne. 0) write(*, *) "Failed to get dataset: ", ncc_name

      call h5dget_space_f(field_id, dataspace, status)
      if (status .ne. 0) write(*, *) "Failed to get dataspace id"

      CALL h5sget_simple_extent_dims_f(dataspace, fdims, maxdims, status)
      if (status .lt. 0) write(*, *) "Failed to get dims, status=", status
 
      nf = fdims(1) 
      allocate(factors(nf)) 
      call h5dread_f(field_id, H5T_IEEE_F32BE, factors, dims, status)
      if (status .ne. 0) write(*, *) "Failed to read sm" 
      call h5fclose_f(file_id, status)  
      call h5close_f(status) 

      !swap to Big Endian:  
      c1=swap_endian(factors(1))
      c2=swap_endian(factors(2))
      write(*, *) "Factors dim=", nf, "factors(1)=", c1, " factors(2)=", c2 

      !converting from char to 2-byte unsigned int value 
      Do ir = 1, ny
       Do ic=1, nx*2, 2
         i=ic+(ir-1)*nx*2 
         ix = (ic+1)/2
         ialb(ix, ir) = ichar(calb(i))*256+ichar(calb(i+1)) 
       End do 
      End Do 

!-------------- read geo lat/lon data file, assuming same dimensions ----------------
      call h5open_f(status)
      if (status .ne. 0) write(*, *) "Failed to open HDF interface"

      call h5fopen_f(geofile, H5F_ACC_RDONLY_F, file_id, status)
      if (status .ne. 0) write(*, *) "Failed to open GEO file"

!      call h5gopen_f(file_id,sm_gr_name,sm_gr_id, status)
!      if (status .ne. 0) write(*, *) "Failed to get group: ", sm_gr_name

      call h5dopen_f(file_id, lat_name, field_id, status)
      if (status .ne. 0) write(*, *) "Failed to get dataset: ", lat_name

      call h5dread_f(field_id, H5T_IEEE_F32BE, lat, dims, status)
      if (status .ne. 0) write(*, *) "Failed to read lon" 

      call h5dopen_f(file_id, lon_name, field_id, status)
      if (status .ne. 0) write(*, *) "Failed to get dataset: ", lon_name

      call h5dread_f(field_id, H5T_IEEE_F32BE, lon, dims, status)
      if (status .ne. 0) write(*, *) "Failed to read lon" 

      call h5fclose_f(file_id, status)  
      call h5close_f(status) 
       
      !swap endians
      Do ir=1, ny
        Do ic=1, nx
          lat(ic, ir) = swap_endian(lat(ic, ir)) 
          lon(ic, ir) = swap_endian(lon(ic, ir)) 
        End Do 
      End Do 

      write(*, *) 'min(lat)   max(lat)    min(lon)   max(lon) '
      write(*, *) minval(lat), maxval(lat), minval(lon), maxval(lon) 

      oalb=-9999.0
      ! reprojection
      Do j=1, ny
        Do i=1, nx
           if (lat(i, j) .GT. -900 .and. lon(i, j) .GT. -900) then 
             ir = nint ( (lat(i, j) - lat0 )/res ) + 1
             ic = nint ( (lon(i, j) - lon0 )/res ) + 1
             if (ic .GT. nc .or. ir .GT. nr) then 
               write(*, *) ic, ir, lat(i, j), lon(i, j) 
             else 
               oalb(ic, ir) = ialb(i, j)*c1+c2 
             end if 
           end if 
        End do 
      End do 
     
      write(*, *) "Saving binary format ...", nc, nr
      open(22, file=ofile, form="unformatted", access="direct", recl=nc*4) 
        Do j=1, nr
          write(22, rec=j) oalb(:, j)  
        End Do 
      close(22) 
       
end program reproj 
