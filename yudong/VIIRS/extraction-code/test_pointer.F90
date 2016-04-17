
! test if a pointer can be sent to a subroutine and gets allocated and filled
!http://www.tek-tips.com/viewthread.cfm?qid=1613318

     program testp

    implicit none

   interface
    subroutine fill_data(data, nx, ny) 
    implicit none
       real, allocatable, intent(out) :: data(:, :) 
       integer, intent(out) :: nx, ny 
    end subroutine
   end interface

      !real, pointer, dimension(:, :) :: data 
      real, allocatable  :: data(:, :)  
      integer :: nx, ny 

      call fill_data(data, nx, ny) 

      write(*, *) nx, ny, data(nx, ny)  
   
      deallocate(data) 
      stop
      end 

      subroutine fill_data(data, nx, ny) 
       !real, pointer, dimension(:, :), intent(out) :: data 
       real, allocatable, intent(out) :: data(:, :) 
       integer, intent(out) :: nx, ny 
       integer :: i, j

       nx=5
       ny=4

       if(allocated(data)) deallocate(data) 
       allocate(data(nx, ny)) 

       Do i=1, nx
         Do j=1, ny
          data(i, j) = i*j*j
         End Do 
       End Do 
 
       return 
      end subroutine fill_data 
