'' 'field = N' INSIDE AN EXTERN BLOCK. The block ORs its linkage bit into the same slot
'' the packing lives in, so 'field = 1' under 'extern "Windows"' read as 33 and the type
'' was laid out naturally -- commctrl.bi's TASKDIALOGCONFIG was 176 bytes where fbc's is
'' 160, and TaskDialogIndirect answered E_INVALIDARG. Measured, fbc: A is 12 with p at 4,
'' B is 6 with p at 2, C is 12 with p at 4, and the anonymous union keeps its own clause.
extern "Windows"
type A field = 1
    x as long
    p as any ptr
end type
type B field = 2
    x as byte
    p as long
end type
end extern
extern "C++"
type C field = 1
    x as long
    p as any ptr
end type
end extern
extern "C"
type D field = 1
    x as long
    union field = 1
        q as any ptr
        r as long
    end union
    s as any ptr
end type
end extern
