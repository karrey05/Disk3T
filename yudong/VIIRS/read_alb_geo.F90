
!subroutine to read from a pare of NCC and NCC-geo files 
  subroutine read_alb_geo(nccfile, geofile, alb, lat, lon, nx, ny) 

! Read NCC data and save to 0.01-deg lat/lon 

      use hdf5 
      use endian_utility

      implicit none

      character*200, intent(in) :: nccfile, geofile
      integer, intent(in) :: nx, ny 
      real, intent(out) :: alb(nx, ny), lat(nx, ny), lon(nx, ny) 

      integer :: ic, ir
      real (kind=4), allocatable :: factor(:) 
      !integer*2, allocatable :: ialb(:, :) 
      real*4 ::  c1, c2
      character, allocatable :: calb(:)
      integer, allocatable :: ialb(:, :) 
      real, allocatable :: factors(:) 

      ! declarations
      integer (kind=4) :: fid,swid,status,astat
      integer (hsize_t) :: rank,dims(2),maxdims(2), fdims(1), datatype,i,j, ix, nf
      character (len=255) :: dimlist

      !======= choose the file and field to read
      character*100,   parameter    :: ncc_name = "/All_Data/VIIRS-NCC-EDR_All/Albedo"
      character*100,   parameter    :: ncc_factors_name = "/All_Data/VIIRS-NCC-EDR_All/AlbedoFactors"
      character*100,   parameter    :: lon_name = "/All_Data/VIIRS-NCC-EDR-GEO_All/Longitude" 
      character*100,   parameter    :: lat_name = "/All_Data/VIIRS-NCC-EDR-GEO_All/Latitude"
      integer(hid_t)                :: file_id, field_id
      integer(hid_t)                :: lon_id, lat_id 
      integer(hid_t)                :: dataspace

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

      if (nx .ne. dims(1) .or. ny .ne. dims(2) ) then 
          write(*, *)' Problem: nx or ny differ from dims' 
      end if 
      !allocate(ialb(nx, ny)) 
      allocate(calb(nx*ny*2)) 
      allocate(ialb(nx, ny)) 

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
          alb(ic, ir) = ialb(ic, ir)*c1+c2 
        End Do 
      End Do 
      
      deallocate(ialb)  
      deallocate(calb)  
      deallocate(factors) 

      return 
       
end subroutine read_alb_geo
