type T
    as string seen
    declare constructor( byval p as zstring ptr )
    declare constructor( byval p as wstring ptr, byval k as long )
    declare constructor( byval p as wstring ptr, byval k as long, byval j as long = 0 )
end type
constructor T( byval p as zstring ptr ) : seen = *p : end constructor
constructor T( byval p as wstring ptr, byval k as long ) : seen = *p : end constructor
constructor T( byval p as wstring ptr, byval k as long, byval j as long = 0 ) : seen = *p : end constructor
dim as ustring u = "u"
dim as T d = T( u )
dim as T e = T( u, 1, 2 )
