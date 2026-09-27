'' Constants in a cycle, which only order freedom lets a module write; one of them used.
#module "cycle"
const A = B + 1
const B = C
const C = A
public function F( ) as long
    return A
end function
