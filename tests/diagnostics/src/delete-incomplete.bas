'' DELETE over a pointer to a type not yet complete -- fbc's error 71 on the refused lines.
type T as FWDREF
type N as NEVER
type D as DONE
type DONE
    a as integer
end type

sub f( byval a as T ptr )
    delete a                     '' 71: FWDREF is declared below
end sub

dim a as T ptr
dim b as N ptr
dim d as D ptr
dim v as any ptr
delete[] a                       '' 71
delete b                         '' 71: nothing declares NEVER
delete d                         '' fine: DONE is above
delete v                         '' fine

type FWDREF
    a as integer
end type
delete a                         '' fine: complete by now
