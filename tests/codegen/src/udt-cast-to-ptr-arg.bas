#lang "fb"
dim shared as integer id_count, id_ctor, id_cast_ptr, id_cast_str

type TU extends object
end type

type TV
    o as TU ptr
    declare constructor( byval p as TU ptr )
    declare operator cast( ) as TU ptr
    declare operator cast( ) as string
end type

constructor TV( byval p as TU ptr )
    o = p
    id_count += 1 : id_ctor = id_count
end constructor

operator TV.cast( ) as TU ptr
    id_count += 1 : id_cast_ptr = id_count
    return o
end operator

operator TV.cast( ) as string
    id_count += 1 : id_cast_str = id_count
    return ""
end operator

sub test_byval( byval p as TU ptr )
    print "byval "; (p = cast( TU ptr, &hBAD00DBA ))
end sub

sub test_byref( byref p as TU ptr )
    print "byref "; (p = cast( TU ptr, &hBAD00DBA ))
end sub

dim as TV x = cast( TU ptr, &hBAD00DBA )
print id_count; id_ctor; id_cast_ptr; id_cast_str

id_count = 0 : id_ctor = 0 : id_cast_ptr = 0 : id_cast_str = 0
test_byval( x )
print id_count; id_ctor; id_cast_ptr; id_cast_str

id_count = 0 : id_ctor = 0 : id_cast_ptr = 0 : id_cast_str = 0
test_byref( x )
print id_count; id_ctor; id_cast_ptr; id_cast_str
