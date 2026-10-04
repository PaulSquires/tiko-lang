'' Fields named by keywords that fbc accepts as field names (T93).
type K
    as long constructor
    as long destructor
    as long rem
    alias as long
    as long dim
end type

dim k as K
k.constructor = 1
k.destructor = 2
k.rem = 3
k.alias = 4
k.dim = 5
print k.constructor; k.destructor; k.rem; k.alias; k.dim

dim as K ptr p = @k
p->rem += 10
print p->rem; p->constructor

dim as long x = 7 rem after a statement REM is still a comment
print x
