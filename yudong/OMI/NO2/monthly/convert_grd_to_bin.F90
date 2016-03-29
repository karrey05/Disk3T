	Program convert 

! Read the grd file and convert into binary for grads  
! Usage: 
! convert_grd_to_bin inputfile outputfile 

	implicit NONE
        integer, parameter :: nc=2880, nr=1440
! fields in file 
! lat lon Year elev(m) yyyy mm dd snd(cm) swe(cm) 

        integer :: idata(nc, nr) 

        integer i, j, it, iargc, ic, ir, ierr, ierr1, is, maxd, itype
        character*200 infile, outfile, ctmp

        i =  iargc()
        If (i.NE.2) Then
          call getarg(0, ctmp) !** get program name
          Write(*, *) "Usage: ", trim(ctmp), &
            " <inputfile> <output-file> " 
          Stop
        End If

       call getarg(1, infile)
       call getarg(2, outfile)

       open(15, file=infile, form="formatted")
         read(15, *)   ! read 7 header lines  
         read(15, *)   ! read 7 header lines  
         read(15, *)   ! read 7 header lines  
         read(15, *)   ! read 7 header lines  
         read(15, *)   ! read 7 header lines  
         read(15, *)   ! read 7 header lines  
         read(15, *)   ! read 7 header lines  
         Do ir = 1, nr 
          read(15, *) idata(:, ir) 
         End do 
       close(15) 

       open(12, file=trim(outfile), form="unformatted", &
                 access="direct", recl=nc*nr*4)
        write(12, rec=1) real(idata) 
       close(12) 

	end 

