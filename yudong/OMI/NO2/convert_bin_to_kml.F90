	Program bin2kml 

! Creat a lat/lon grid data to kml 
! fields in file 
!'(a)' xdef 2880  linear  -179.9375 0.125
!'(a)' ydef 1440  linear  -89.9375  0.125

! Usage: 

	implicit NONE
        integer, parameter :: nc=2880, nr=1440
	real, parameter :: lat0=-89.9375, lon0=-179.9375, res=0.125
	real, parameter :: vmin=1000, vmax=4000,  hmax=1000000   ! range of values 
        
        real :: data(nc, nr), v, h, clat, clon
        integer i, j, it, iargc, ic, ir, ierr, ierr1, is, maxd, itype
        character*200 :: infile, outfile, ctmp
        character*8 ::  colors(11)  !GRADS rainbow colors #4, 11, .., 6 (
                                    !http://cola.gmu.edu/grads/gadoc/colorcontrol.html
        data colors/'ae3cffff', 'a0a0ffff', 'a0c8c8ff', 'a0d28cff', 'a0dc00ff', &
               'a0e632ff', 'e6dc32ff', 'e6af2dff', 'f08228ff', 'fa3c3cff', 'f00082ff'/


! lat lon Year elev(m) yyyy mm dd snd(cm) swe(cm) 


       infile = '2016_DJF.bin'
       outfile = '2016_DJF.kml' 

       open(11, file=trim(infile), form="unformatted", &
                 access="direct", recl=nc*nr*4) 
          read(11, rec=1) data 
       close(11) 


!save kml 
       open(12, file=trim(outfile), form="formatted") 

! header 
       write(12, '(a)')'<?xml version="1.0" encoding="UTF-8"?>' 
       write(12, '(a)')'<kml xmlns="http://www.opengis.net/kml/2.2">'

	write(12, '(a)')'<Document>'
        write(12, '(a, a, a)')'	<name>', trim(outfile), '</name>'
        write(12, '(a)')'	<Style id="defaultStyles">'
        write(12, '(a)')'		<LineStyle>'
       	write(12, '(a)')'			<color>cc000000</color>'
       	write(12, '(a)')'		</LineStyle>'
        write(12, '(a)')'		<PolyStyle>'
        write(12, '(a)')'			<outline>0</outline>'
        write(12, '(a)')'		</PolyStyle>'
        write(12, '(a)')'	</Style>'
      ! define custome styles
      Do ic=1, 11
!        write(12, '(a, I0.0, a)')'	<Style id="st', ic, '">'
!        write(12, '(a)')'		<LineStyle>'
!       	write(12, '(a, a, a)')'			<color>', colors(ic), '</color>'
!       	write(12, '(a)')'		</LineStyle>'
!        write(12, '(a)')'		<PolyStyle>'
!       	write(12, '(a, a, a)')'			<color>', colors(ic), '</color>'
!        write(12, '(a)')'			<outline>1</outline>'
!        write(12, '(a)')'			<fill>1</fill>'
!        write(12, '(a)')'		</PolyStyle>'
!        write(12, '(a)')'	</Style>'
      End Do 
        
!X is varying   Lon = 80 to 130   X = 2080.5 to 2480.5
!Y is varying   Lat = 20 to 50   Y = 880.5 to 1120.5

       !Do j=1, nr 
       !  Do i=1, nc 
       Do j=890, 1020 
         Do i=2280, 2380 
            v = data(i, j) 
            if (v .GE. vmin .and. v .LE. vmax) then  ! plot it 
             h = (v-vmin) * hmax /(vmax-vmin) 
             ic = nint(h/hmax*10)+1    ! style index
             write(*, *) 'ic=', ic
             clat = lat0 + (j-1)* res 
             clon = lon0 + (i-1)* res 
       
	write(12, '(a)')'	<Placemark>'
!        write(12, '(a, I0.0, a)')'		<styleUrl>#st', ic, '</styleUrl>'
        write(12, '(a)')'		<styleUrl>#defaultStyles</styleUrl>'
        write(12, '(a)')'	<Style>'
!        write(12, '(a)')'		<LineStyle>'
!       	write(12, '(a, a, a)')'			<color>', colors(ic), '</color>'
!       	write(12, '(a)')'		</LineStyle>'
        write(12, '(a)')'		<PolyStyle>'
       	write(12, '(a, a, a)')'			<color>', colors(ic), '</color>'
!        write(12, '(a)')'			<outline>1</outline>'
!        write(12, '(a)')'			<fill>1</fill>'
        write(12, '(a)')'		</PolyStyle>'
        write(12, '(a)')'	</Style>'
        write(12, '(a)')'		<Polygon>'
        write(12, '(a)')'			<extrude>1</extrude>'
        write(12, '(a)')'			<tessellate>1</tessellate>'
        write(12, '(a)')'			<altitudeMode>absolute</altitudeMode>'
        write(12, '(a)')'			<outerBoundaryIs>'
        write(12, '(a)')'				<LinearRing>'
        write(12, '(a)')'	 				<coordinates>'
        ! important: goes counter-clockwise for correct shading
        write(12, '(F0.4, A, F0.4, A, F0.1)') clon + res*0.5, ',', clat + res*0.5, ',', h 
        write(12, '(F0.4, A, F0.4, A, F0.1)') clon - res*0.5, ',', clat + res*0.5, ',', h 
        write(12, '(F0.4, A, F0.4, A, F0.1)') clon - res*0.5, ',', clat - res*0.5, ',', h 
        write(12, '(F0.4, A, F0.4, A, F0.1)') clon + res*0.5, ',', clat - res*0.5, ',', h 
        write(12, '(F0.4, A, F0.4, A, F0.1)') clon + res*0.5, ',', clat + res*0.5, ',', h 
        write(12, '(a)')'	 				</coordinates>'
        write(12, '(a)')'				</LinearRing>'
        write(12, '(a)')'			</outerBoundaryIs>'
        write(12, '(a)')'		</Polygon>'
	write(12, '(a)')'	</Placemark>'
            end if ! if (v .GE. vmin .and. v .LE. vmax) then  ! plot it 
 
         End Do
       End Do 
       write(12, '(a)')'</Document>'
       write(12, '(a)')'</kml>'
       write(12, *) 
       close(12) 

	end 

