Program Part2
    implicit none
    integer, dimension(10,10) :: octopuses
    character(10) :: digit
    integer :: numRows, numCols, col, row
    integer :: rem, step, steps, flashes
    integer :: flashesPerStep, remainingFlashes, totalFlashes
  
    numRows = 10
    numCols = 10
    flashes = 0
    flashesPerStep = 0
  
    open(12, file="input.txt")
  
    do row = 1, numRows
      ! read in values
      read(12,*) digit
  
      do col = 1, numCols
        ! conver from char to integer
        rem = ICHAR(digit(col:col)) - 48
        octopuses(col, row) = rem
      END do
    END do
  
    close(12)
    
    ! take a step
    steps = 500
    
    do step = 1, steps 
      flashesPerStep = 0
  
      ! increase energy
      do row = 1, numRows
        do col = 1, numCols
          octopuses(col, row) = octopuses(col, row) + 1
        end do
      end do
  
      ! if flashed, up the energy for surrounding values
      remainingFlashes = 1
      do while (remainingFlashes > 0)
        remainingFlashes = 0
        do row = 1, numRows
          do col = 1, numCols
            if (octopuses(col, row) > 9) then
              if (octopuses(col, row) < 99) then
                if (col-1 > 0) then
                  if (row+1 <= numRows) then
                    octopuses(col-1, row+1) = octopuses(col-1, row+1) + 1
                  end if
                  octopuses(col-1, row) = octopuses(col-1, row) + 1
                  if (row-1 > 0) then
                    octopuses(col-1, row-1) = octopuses(col-1, row-1) + 1
                  end if
                end if
                  if (row-1 > 0) then
                    octopuses(col, row-1) = octopuses(col, row-1) + 1
                  end if
                  if (row+1 <= numRows) then
                    octopuses(col, row+1) = octopuses(col, row+1) + 1
                  end if
                if (col+1 <= numCols) then 
                  if (row-1 > 0) then
                    octopuses(col+1, row-1) = octopuses(col+1, row-1) + 1
                  end if
                    octopuses(col+1, row) = octopuses(col+1, row) + 1
                  if (row+1 <= numRows) then
                    octopuses(col+1, row+1) = octopuses(col+1, row+1) + 1
                  end if
                end if
      
                flashes = flashes + 1
                flashesPerStep = flashesPerStep + 1
                remainingFlashes = remainingFlashes + 1
                octopuses(col, row) = 99
              end if
            end if
          end do
        end do
      end do 
  
      ! reset flashes to zero
      do row = 1, numRows
        do col = 1, numCols
          if (octopuses(col, row) >= 99) then
            octopuses(col, row) = 0
          end if
        end do
      end do

      ! calculate how many flashes there were
      totalFlashes = 0
      do row = 1, numRows
        do col = 1, numCols
          if (octopuses(col, row) == 0) then
            totalFlashes = totalFlashes + 1
          end if
        end do
      end do

      if (totalFlashes == 100) then
        print*, "Part 2 answer"
        print*, step

        exit
      end if
    end do 
  End Program Part2
