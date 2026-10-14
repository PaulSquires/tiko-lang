'' See tests/driver/shared-ustring-ctor.test.
type T
    as ustring p
    declare constructor( byref fpath as ustring )
end type
constructor T( byref fpath as ustring )
    p = fpath
end constructor
type B
    as ustring u
    declare constructor( byval x as ustring )
end type
constructor B( byval x as ustring ) : u = x : end constructor
type M
    as string n
    as ustring u
    as long k
    declare constructor( byref a as string, byref b as ustring, byval k as long )
end type
constructor M( byref a as string, byref b as ustring, byval k as long ) : n = a : u = b : this.k = k : end constructor

dim shared as T ga = T( "shared-init" )
dim shared as T gw = T( wstr( "wide" ) )
dim shared as T gv = wstr( "conv" )
dim shared as B gb = B( "byval" )
dim shared as M gm = M( "narrow", "ustr", 7 )
dim as T ld = T( "module-dim" )
print ga.p : print gw.p : print gv.p : print gb.u
print gm.n; "|"; gm.u; "|"; gm.k
print ld.p; len( ga.p )
