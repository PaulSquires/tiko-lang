'' A graphics target UDT needs exactly one cast to a pointer: none is fbc's 99, two its 98.
type NoPtr
    p as any ptr
    declare operator cast( ) as string
end type
type TwoPtr
    p as any ptr
    declare operator cast( ) as ubyte ptr
    declare operator cast( ) as ulong ptr
end type
type OnePtr
    p as any ptr
    declare operator cast( ) as any ptr
    declare operator cast( ) as string
end type
dim a as NoPtr
dim b as TwoPtr
dim c as OnePtr
line a, (0, 0) - (31, 31), rgb(0,0,0), bf           '' 99
line b, (0, 0) - (31, 31), rgb(0,0,0), bf           '' 98
line c, (0, 0) - (31, 31), rgb(0,0,0), bf           '' fine
