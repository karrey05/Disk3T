
! test if a pointer can be sent to a subroutine and gets allocated and filled
!http://www.tek-tips.com/viewthread.cfm?qid=1613318

     program testp

    implicit none

   interface
    subroutine fill_data(data, cdata, nx, ny) 
    implicit none
       real, allocatable, intent(out) :: data(:, :) 
       character*2, allocatable, intent(out) :: cdata(:, :) 
       integer, intent(out) :: nx, ny 
    end subroutine
   end interface

      !real, pointer, dimension(:, :) :: data 
      real, allocatable  :: data(:, :)  
      character*2, allocatable :: cdata(:, :) 
      integer :: nx, ny 

      call fill_data(data, cdata, nx, ny) 

      write(*, *) nx, ny, data(nx, ny)  
      write(*, *) nx, ny, cdata(nx, ny)  
   
      deallocate(data) 
      stop
      end 

      subroutine fill_data(data, cdata, nx, ny) 
       !real, pointer, dimension(:, :), intent(out) :: data 
       real, allocatable, intent(out) :: data(:, :) 
       character*2, allocatable, intent(out) :: cdata(:, :) 
       integer, intent(out) :: nx, ny 
       integer :: i, j

       nx=5
       ny=4

       if(allocated(data)) deallocate(data) 
       if(allocated(cdata)) deallocate(cdata) 
       allocate(data(nx, ny)) 
       allocate(cdata(nx, ny)) 

       Do i=1, nx
         Do j=1, ny
          data(i, j) = i*j*j
         End Do 
       End Do 
 
       return 
      end subroutine fill_data 
