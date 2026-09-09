'' '= ANY' ON A FIELD SUPPRESSES MORE THAN THE STORE. Four probes on fbc, and the
'' third is the one that decides where the check has to go:
''
''   type t1 : a as long = any : b as long : end type
''       the synthesised constructor memsets ONLY b -- 4 bytes at offset 4
''
''   type t3 : a as long = any : b as long = any : end type
''       a constructor is still SYNTHESISED and its body is EMPTY, so 'dim as t3 z'
''       calls it and does NOT memset at the declaration the way a type with no
''       initialisers at all is memset by its caller
''
''   type t6 : i as inner = any : ... : end type, inner declaring a constructor
''       inner's constructor is NOT called. Skipping only the store would still have
''       called it
''
''   type t7 : the same, plus a destructor
''       the DESTRUCTOR still runs. Construction is suppressed and destruction is not
''
'' A DYNAMIC ARRAY field is the one exception, and it is measured rather than reasoned:
'' fbc builds its whole descriptor regardless.
type t1
	as long a = any
	as long b
end type

type t3
	as long a = any
	as long b = any
end type

type inner
	as long q
	declare constructor( )
end type

constructor inner( )
	this.q = 9
end constructor

type t6
	as inner i = any
	as long n = any
end type

type withdyn
	d( any ) as long = any
	as long n = any
end type

dim as t1 v1
dim as t3 v3
dim as t6 v6
dim as withdyn vd
print v1.b, v3.a, v6.n, vd.n
