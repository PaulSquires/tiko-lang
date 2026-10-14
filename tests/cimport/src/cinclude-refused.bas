'' Records the layout check refuses (see refused.h) are incomplete types: a pointer to one
'' compiles, as a variable, a field, and a parameter of a function the binding kept.
#cinclude "tests/cimport/src/refused.h"
dim as ref_over ptr o
dim as ref_pun ptr p
dim as ref_late ptr l
dim as ref_points r
r.o = o
print sizeof( r ), o = 0, p = 0, l = 0
