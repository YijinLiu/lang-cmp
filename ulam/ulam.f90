! 426960367 ns used to find                 7584  Ulam numbers <=                100000

module class_UlamNumbers
    implicit none
    private

    type, public :: UlamNumbers
        integer(kind = 8), allocatable :: list(:)
        integer(kind = 8) :: n
    contains
        procedure :: init => init_ulam_numbers
        procedure :: check => is_ulam_number
        procedure :: add => add_ulam_number
    end type UlamNumbers

contains
    subroutine init_ulam_numbers(this, capacity)
        class(UlamNumbers), intent(inout) :: this
        integer(kind = 8), intent(in) :: capacity

        allocate(this%list(capacity))
        this%list(1) = 1
        this%list(2) = 2
        this%n = 2
    end subroutine init_ulam_numbers

    function is_ulam_number(this, num) result(is_ulam)
        class(UlamNumbers), intent(in) :: this
        integer(kind = 8), intent(in) :: num
        logical :: is_ulam
        integer(kind = 8) :: i, j, s
        is_ulam = .false.
        i = 1
        j = this%n
        do while (i < j)
            s = this%list(i) + this%list(j)
            if (s == num) then
                if (is_ulam) then
                    is_ulam = .false.
                    return
                end if
                is_ulam = .true.
                i = i + 1
                j = j - 1
            else if (s < num) then
                i = i + 1
            else
                j = j - 1
            end if
        enddo
    end function is_ulam_number

    subroutine add_ulam_number(this, num)
        class(UlamNumbers), intent(inout) :: this
        integer(kind = 8), intent(in) :: num
        integer(kind = 8), allocatable :: tmp(:)

        if (this%n == size(this%list)) then
            call move_alloc(this%list, tmp)
            allocate(this%list(this%n * 2))
            this%list(1:this%n) = tmp
        end if

        this%n = this%n + 1
        this%list(this%n) = num
    end subroutine add_ulam_number
end module class_UlamNumbers

program ulam
    use class_UlamNumbers
    implicit none

    type(UlamNumbers) :: ulam_numbers
    real :: start_time, end_time
    integer(kind = 8) :: i, limit
    integer(kind = 8) :: elapsed_ns, total_elapsed_ns
    call ulam_numbers%init(10_8)

    open(10, file = "ulam_100k_f90.csv", status = 'new')
    write(10,"(a)") "ulam_num,elapsed_ns"
    write(10,"(a)") "1,0"
    write(10,"(a)") "2,0"

    limit = 100000_8
    call cpu_time(start_time)
    do i = 3, limit
        if (ulam_numbers%check(i)) then
            call cpu_time(end_time)
            elapsed_ns = int((end_time - start_time) * 1e9)
            total_elapsed_ns = total_elapsed_ns + elapsed_ns
            write(10,"(i0 a i0)") i, ",", elapsed_ns
            print *, elapsed_ns, "ns used to find Ulam number", i
            call cpu_time(start_time)
            call ulam_numbers%add(i)
        end if
    end do
    call cpu_time(end_time)
    total_elapsed_ns = total_elapsed_ns + int((end_time - start_time) * 1e9)

    close(10)

    print *, total_elapsed_ns, "ns used to find", ulam_numbers%n, " Ulam numbers <= ", limit

end program ulam
