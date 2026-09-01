'' AN ENUM ITEM IS A CONSTANT, and assigning to one is fbc error 119 -- the same as any
'' other constant. Resolve refuses a bare CONST, but an enum item reached lowering and the
'' store went into the constant's slot.
enum E
    FOO = 1
    BAR = 2
end enum

dim as integer n = FOO
FOO = 3
E.BAR = 4
