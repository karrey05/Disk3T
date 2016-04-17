program ncc2kml 

! Read multiple NCC data files and save to KML 

      implicit none
   interface
    subroutine read_alb_geo(nccfile, geofile, alb, lat, lon, nx, ny)
      character*200, intent(in) :: nccfile, geofile
      integer, intent(out) :: nx, ny
      real, allocatable, intent(out) :: alb(:, :), lat(:, :), lon(:, :)
    end subroutine
   end interface

      !control output type 
      integer, parameter :: save_grads = 1    ! > 0, save binary 
      integer, parameter :: save_kml = 0    ! > 0, save kml 

      ! batch processing of multiple files 
      integer, parameter :: nfiles = 13 
      character*200 :: nccfile(nfiles), geofile(nfiles), kmlfile ! input and output file names 
      character*200 :: gradsf, ctlf   !output for grads format 

      !  swath dimension
      integer :: nx, ny
      integer :: i, j, ic, ir, iargc, nf  
      real (kind=4), allocatable :: lon(:, :), lat(:, :), alb(:, :), v

      ! scope of output  
      real, parameter :: minlat=30, maxlat=60.0   ! confine regions to limit kml size 
      real, parameter :: minlon=-10, maxlon=30.0   ! confine regions to limit kml size 
      real, parameter :: res0 = 0.00675    ! (0.75*360)/(2Pi*6371)   (750m resolution) 
      real :: resx, resy   ! change lat/lon res with latitude to avoid gaps 
       
      integer :: nc, nr

      !KML stuff 
      integer, parameter :: maxcolors=7
      real, parameter :: vmin=4, vmax=64, h=0  ! compute from data, logscale display 
      real :: clat, clon 
      character*8 ::  colors(maxcolors)   

      !output data for grads
      real*4, allocatable :: oalb(:, :) 

      !from yellowish to white hot
      data colors/'ff10ffe7', 'ff48fdeb', 'ff34fcf5', 'ff6cfcf7', 'ffabfcf9', 'ffcefffe', 'ffffffff'/ 
      
      resy = res0   
      resx = res0 / cos( max(abs(minlat), abs(maxlat))*3.1415926 /180.0)  
      nc = nint( (maxlon - minlon )/resx) + 1
      nr = nint( (maxlat - minlat )/resy) + 1
      write(*, *) "nc=", nc, " nr=", nr
      allocate(oalb(nc, nr)) 

      kmlfile = 'ncc_d20160407.kml' 
      gradsf = 'ncc_d20160407.bin' 
      ctlf = 'ncc_d20160407.ctl' 

      nccfile(1)='NCC/VNCCO_npp_d20160407_t0117457_e0123594_b23021_c20160407072343678640_noaa_ops.h5'
      nccfile(2)='NCC/VNCCO_npp_d20160407_t0123274_e0129392_b23022_c20160407072925744724_noaa_ops.h5'
      nccfile(3)='NCC/VNCCO_npp_d20160407_t0129108_e0135173_b23022_c20160407073506802103_noaa_ops.h5'
      nccfile(4)='NCC/VNCCO_npp_d20160407_t0134559_e0140536_b23022_c20160407074047863146_noaa_ops.h5'
      nccfile(5)='NCC/VNCCO_npp_d20160407_t0140411_e0146281_b23022_c20160407074629917706_noaa_ops.h5'
      nccfile(6)='NCC/VNCCO_npp_d20160407_t0146281_e0152150_b23022_c20160407075210995992_noaa_ops.h5'
      nccfile(7)='NCC/VNCCO_npp_d20160407_t0152044_e0158002_b23022_c20160407075752066045_noaa_ops.h5'
      nccfile(8)='NCC/VNCCO_npp_d20160407_t0157406_e0203454_b23022_c20160407080334129102_noaa_ops.h5'
      nccfile(9)='NCC/VNCCO_npp_d20160407_t0203187_e0209288_b23022_c20160407080915205951_noaa_ops.h5'
      nccfile(10)='NCC/VNCCO_npp_d20160407_t0208585_e0215104_b23022_c20160407081456255169_noaa_ops.h5'
      nccfile(11)='NCC/VNCCO_npp_d20160407_t0214402_e0220502_b23022_c20160407082038313701_noaa_ops.h5'
      nccfile(12)='NCC/VNCCO_npp_d20160407_t0220236_e0226283_b23022_c20160407082619370298_noaa_ops.h5'
      nccfile(13)='NCC/VNCCO_npp_d20160407_t0226087_e0232046_b23022_c20160407083200453089_noaa_ops.h5'

      geofile(1)='NCC-Geo/GNCCO_npp_d20160407_t0117457_e0123594_b23021_c20160407072343678438_noaa_ops.h5'
      geofile(2)='NCC-Geo/GNCCO_npp_d20160407_t0123274_e0129392_b23022_c20160407072925744537_noaa_ops.h5'
      geofile(3)='NCC-Geo/GNCCO_npp_d20160407_t0129108_e0135173_b23022_c20160407073506801917_noaa_ops.h5'
      geofile(4)='NCC-Geo/GNCCO_npp_d20160407_t0134559_e0140536_b23022_c20160407074047862946_noaa_ops.h5'
      geofile(5)='NCC-Geo/GNCCO_npp_d20160407_t0140411_e0146281_b23022_c20160407074629917518_noaa_ops.h5'
      geofile(6)='NCC-Geo/GNCCO_npp_d20160407_t0146281_e0152150_b23022_c20160407075210995801_noaa_ops.h5'
      geofile(7)='NCC-Geo/GNCCO_npp_d20160407_t0152044_e0158002_b23022_c20160407075752065843_noaa_ops.h5'
      geofile(8)='NCC-Geo/GNCCO_npp_d20160407_t0157406_e0203454_b23022_c20160407080334128905_noaa_ops.h5'
      geofile(9)='NCC-Geo/GNCCO_npp_d20160407_t0203187_e0209288_b23022_c20160407080915205725_noaa_ops.h5'
      geofile(10)='NCC-Geo/GNCCO_npp_d20160407_t0208585_e0215104_b23022_c20160407081456254974_noaa_ops.h5'
      geofile(11)='NCC-Geo/GNCCO_npp_d20160407_t0214402_e0220502_b23022_c20160407082038313505_noaa_ops.h5'
      geofile(12)='NCC-Geo/GNCCO_npp_d20160407_t0220236_e0226283_b23022_c20160407082619370093_noaa_ops.h5'
      geofile(13)='NCC-Geo/GNCCO_npp_d20160407_t0226087_e0232046_b23022_c20160407083200452895_noaa_ops.h5'

 !kml output ----------------------------------------------------
 if (save_kml > 0 ) then 
      open(12, file=trim(kmlfile), form="formatted")

! header
       write(12, '(a)')'<?xml version="1.0" encoding="UTF-8"?>'
       write(12, '(a)')'<kml xmlns="http://www.opengis.net/kml/2.2">'

       write(12, '(a)')'<Document id="SkyInformatics Inc. All Rights Reserved.">'
       write(12, '(a, a, a)')' <name>', trim(kmlfile), '</name>'
        write(12, '(a)')'       <Style id="defaultStyles">'
        write(12, '(a)')'               <LineStyle>'
        write(12, '(a)')'                       <color>cc000000</color>'
        write(12, '(a)')'               </LineStyle>'
        write(12, '(a)')'               <PolyStyle>'
        write(12, '(a)')'                       <outline>0</outline>'
        write(12, '(a)')'               </PolyStyle>'
        write(12, '(a)')'       </Style>'
      ! define custome styles
      Do ic=1, maxcolors
        write(12, '(a, I0.0, a)')'      <Style id="st', ic, '">'
        write(12, '(a)')'               <LineStyle>'
        write(12, '(a, a, a)')'                 <color>', colors(ic), '</color>'
        write(12, '(a)')'               </LineStyle>'
        write(12, '(a)')'               <PolyStyle>'
        write(12, '(a, a, a)')'                 <color>', colors(ic), '</color>'
        write(12, '(a)')'                       <outline>0</outline>'
        write(12, '(a)')'                       <fill>1</fill>'
        write(12, '(a)')'               </PolyStyle>'
        write(12, '(a)')'       </Style>'
      End Do

 end if 
 !kml output ----------------------------------------------------

      oalb = -9999.0 
      Do nf = 1, nfiles 
        call read_alb_geo(nccfile(nf), geofile(nf), alb, lat, lon, nx, ny) 
        write(*, *) 'min(alb)   max(alb)   min(lat)   max(lat)    min(lon)   max(lon) '
        write(*, '(6F10.2)') minval(alb), maxval(alb), minval(lat), maxval(lat), minval(lon), maxval(lon) 
      
        Do j=1, ny
          Do i=1, nx
             clat=lat(i, j)
             clon=lon(i, j) 
             if (clat .GE. minlat .and. clat .LE. maxlat .and. & 
                 clon .GE. minlon .and. clon .LE. maxlon) then  
               ir = nint ( (clat - minlat )/resy ) + 1
               ic = nint ( (clon - minlon )/resx ) + 1
               oalb(ic, ir) = alb(i, j)

           ! kml 
           v = alb(i, j) 
           if ( v .GE. vmin .and. v .LT. vmax .and. save_kml .GT. 0) then  ! plot 
             ic = nint( log(v)/log(2.0) ) 
             if (ic > maxcolors) ic=maxcolors 
        write(12, '(a)')'       <Placemark>'
        write(12, '(a, I0.0, a)')'              <styleUrl>#st', ic, '</styleUrl>'

        write(12, '(a)')'               <Polygon>'
        write(12, '(a)')'                       <tessellate>1</tessellate>'
        write(12, '(a)')'                       <altitudeMode>clampToGround</altitudeMode>'
        write(12, '(a)')'                       <outerBoundaryIs>'
        write(12, '(a)')'                               <LinearRing>'
        write(12, '(a)')'                                       <coordinates>'
        ! important: goes counter-clockwise for correct shading
        write(12, '(F0.7, A, F0.7, A, F0.1)') clon + resx*0.5, ',', clat + resy*0.5, ',', h
        write(12, '(F0.7, A, F0.7, A, F0.1)') clon - resx*0.5, ',', clat + resy*0.5, ',', h
        write(12, '(F0.7, A, F0.7, A, F0.1)') clon - resx*0.5, ',', clat - resy*0.5, ',', h
        write(12, '(F0.7, A, F0.7, A, F0.1)') clon + resx*0.5, ',', clat - resy*0.5, ',', h
        write(12, '(F0.7, A, F0.7, A, F0.1)') clon + resx*0.5, ',', clat + resy*0.5, ',', h
        write(12, '(a)')'                                       </coordinates>'
        write(12, '(a)')'                               </LinearRing>'
        write(12, '(a)')'                       </outerBoundaryIs>'
        write(12, '(a)')'               </Polygon>'
        write(12, '(a)')'       </Placemark>'
            end if ! if (clat ... 
         end if !   if ( v .GE. vmin) then  ! plot 
 
        End Do  ! i
      End Do  ! j

      End Do   ! nfiles 

if (save_kml > 0) then 
       write(12, '(a)')'</Document>'
       write(12, '(a)')'</kml>'
       write(12, *)
       close(12)
  
endif 

     if(save_grads .GT. 0) then 

      write(*, *) "Saving binary format ...", nc, nr
      open(22, file=gradsf, form="unformatted", access="direct", recl=nc*4)
        Do j=1, nr
          write(22, rec=j) oalb(:, j)
        End Do
      close(22)

      open(24, file=ctlf, form="formatted") 

      write(24, '(a)')'dset ^'//trim(gradsf) 
      write(24, '(a)')'options little_endian' 
      write(24, '(a)')'undef -999.0' 
      write(24, '(a)')'Title VIIRS DNB NCC albedo 750km '
      write(24, '(a, I0.0, a, F0.4, a, F0.5)')'xdef ', nc, ' linear ', minlon, ' ', resx 
      write(24, '(a, I0.0, a, F0.4, a, F0.5)')'ydef ', nr, ' linear ', minlat, ' ', resy 
      write(24, '(a)')'zdef 1 linear 1 1'
      write(24, '(a)')'tdef 1 linear 0Z1Oct2004 1mn'
      write(24, '(a)')'vars 1'
      write(24, '(a)')'alb   1 99   alb unitless'
      write(24, '(a)')'endvars'

      close(24) 

     end if 

      deallocate(oalb) 

      stop 
      end 
