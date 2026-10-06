'' type<T>( type<T>( ... ) ) builds one object; a derived literal sliced into a base is its own temporary
type t1            : dim as integer i : declare destructor() : end type
type t2 extends t1 : dim as integer j : declare destructor() : end type
type t3 extends t2 : dim as integer k : declare destructor() : end type
type t4 extends t3 : dim as integer l : declare destructor() : end type
dim shared as integer d1, d2, d3, d4
destructor t1() : d1 += 1 : end destructor
destructor t2() : d2 += 1 : end destructor
destructor t3() : d3 += 1 : end destructor
destructor t4() : d4 += 1 : end destructor
sub show() : print d1; d2; d3; d4 : d1 = 0 : d2 = 0 : d3 = 0 : d4 = 0 : end sub
scope : dim as t3 u3 = type<t3>(1,2,3) : end scope : show()
scope : dim as t3 u3 = type<t3>(type<t3>(1,2,3)) : print u3.i; u3.j; u3.k : end scope : show()
scope : dim as t3 u3 = type<t3>(type<t3>(type<t3>(1,2,3))) : end scope : show()
scope : dim as t1 u1 = type<t2>(type<t3>(type<t4>(1, 2, 3, 4))) : print u1.i : end scope : show()
