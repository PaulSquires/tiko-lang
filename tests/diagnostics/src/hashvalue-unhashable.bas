'' hashvalue-unhashable.bas -- see ../hashvalue-unhashable.test
type Opaque_
    as long x
end type
dim as Opaque_ o
print hashvalue( o )
