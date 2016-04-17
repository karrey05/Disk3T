program saveraw 

! Read 1-day's worth of NCC data and geo files, 
! reproject to 0.00675 (750m) resoluton lat/lon
! and save the gridded data, for compact archiving

!usage: 
! ./save_raw ncc_file_list geo_file_list outfile outctl 

    implicit none

   interface
    subroutine read_alb_geo(nccfile, geofile, alb, lat, lon, nx, ny)
      character*200, intent(in) :: nccfile, geofile
      integer, intent(out) :: nx, ny
      real, allocatable, intent(out) :: alb(:, :), lat(:, :), lon(:, :)
    end subroutine
   end interface

      ! batch processing of multiple files 
      integer, parameter :: maxfiles = 400   ! normally 250-260 
      integer :: nfiles
      character*200 :: ncclist, geolist 
      character*200 :: nccfile(maxfiles), geofile(maxfiles)
      character*200 :: gradsf, ctlf   !output for grads format 

      ! the swath dimension 
      integer ::  nx, ny           ! usually nx = 4121,  ny = 3084
      integer :: i, j, ic, ir, iargc, nf, ierr  
      real (kind=4), allocatable :: lat(:, :), lon(:, :), alb(:, :)  

      ! scope of output, center of grid   
      real, parameter :: minlat=-89.996625, maxlat=89.996625  ! 
      real, parameter :: minlon=-179.996625, maxlon=179.996625 ! global 
      real, parameter :: res0 = 0.00675    ! (0.75*360)/(2Pi*6371)   (750m resolution) 
      real :: resx, resy, clat, clon 
       
      integer :: nc, nr

      !output data for grads
      real*4, allocatable :: oalb(:, :) 

      resy = res0   
      resx = res0    
      nc = nint( (maxlon - minlon )/resx) + 1
      nr = nint( (maxlat - minlat )/resy) + 1
      write(*, *) "nc=", nc, " nr=", nr
      allocate(oalb(nc, nr)) 

     if (iargc() .ne. 4) then  
       write(*, *)"usage: save_raw ncc_file_list geo_file_list outfile outctl" 
       stop 
     end if 
     call getarg(1, ncclist)
     call getarg(2, geolist)
     call getarg(3, gradsf)
     call getarg(4, ctlf) 

     open(15, file=trim(ncclist), form='formatted', status='old') 
      nfiles = maxfiles 
      Do i=1, maxfiles
         read(15, '(a)', iostat=ierr) nccfile(i) 
         if (ierr .ne. 0 ) then
           nfiles = i-1
           exit
         end if 
      End Do 
      Close(15) 
      write(*, *) "number of ncc files: ", nfiles 

     !should have same number of files in geolist as in ncclist
     open(17, file=trim(geolist), form='formatted', status='old')
      nfiles = maxfiles
      Do i=1, maxfiles
         read(17, '(a)', iostat=ierr) geofile(i)
         if (ierr .ne. 0 ) then
           nfiles = i-1
           exit
         end if
      End Do
      Close(17)
      write(*, *) "number of geo files: ", nfiles 

    oalb = -9999.0 
    Do nf = 1, nfiles 

        call read_alb_geo(nccfile(nf), geofile(nf), alb, lat, lon, nx, ny) 
      
        Do j=1, ny
          Do i=1, nx
             clat=lat(i, j)
             clon=lon(i, j) 
             if (clat .GE. minlat .and. clat .LE. maxlat .and. & 
                 clon .GE. minlon .and. clon .LE. maxlon) then  
               ir = nint ( (clat - minlat )/resy ) + 1
               ic = nint ( (clon - minlon )/resx ) + 1
               oalb(ic, ir) = alb(i, j)
             end if 
        End Do  ! i
      End Do  ! j

    End Do   ! nfiles 

      write(*, *) "Saving binary format ...", nc, nr
      open(22, file=gradsf, form="unformatted", access="direct", recl=nc*4)
        Do j=1, nr
          write(22, rec=j) oalb(:, j)
        End Do
      close(22)

      open(24, file=ctlf, form="formatted") 

      write(24, '(a)')'dset ^'//trim(gradsf) 
      write(24, '(a)')'options little_endian' 
      write(24, '(a)')'undef -9999.0' 
      write(24, '(a)')'Title VIIRS DNB NCC albedo 750km '
      write(24, '(a, I0.0, a, F0.4, a, F0.5)')'xdef ', nc, ' linear ', minlon, ' ', resx 
      write(24, '(a, I0.0, a, F0.4, a, F0.5)')'ydef ', nr, ' linear ', minlat, ' ', resy 
      write(24, '(a)')'zdef 1 linear 1 1'
      write(24, '(a)')'tdef 1 linear 0Z1Oct2004 1mn'
      write(24, '(a)')'vars 1'
      write(24, '(a)')'alb   1 99   alb unitless'
      write(24, '(a)')'endvars'

      close(24) 

      deallocate(oalb) 

      stop 
      end 
