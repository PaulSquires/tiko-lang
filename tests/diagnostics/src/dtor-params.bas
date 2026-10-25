'' A destructor with a parameter: fbc's 159 on the declare (line 5) and the definition
'' (line 7), fbc-modern 1.20. tiko accepted it and never ran it.
type T
    a as long
    declare destructor( byval x as long )
end type
destructor T( byval x as long )
end destructor
