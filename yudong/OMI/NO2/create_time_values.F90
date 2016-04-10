	Program convert 

! Creat time values as x to for fitting y = delta + lambda * x 
! Usage: 

	implicit NONE
        integer, parameter :: nc=2880, nr=1440
! fields in file 
! lat lon Year elev(m) yyyy mm dd snd(cm) swe(cm) 

        integer :: idata(nc, nr) 

        integer i, j, it, iargc, ic, ir, ierr, ierr1, is, maxd, itype
        character*200 infile, outfile, ctmp

       outfile = '12-year.bin'

       open(12, file=trim(outfile), form="unformatted", &
                 access="direct", recl=nc*nr*4)

        Do it=1, 12
          idata=it 
          write(12, rec=it) real(idata) 
       end do 
       close(12) 

	end 

