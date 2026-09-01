'' A MODULE-LEVEL 'static' HAS INTERNAL LINKAGE, and the initialiser of a SHARED variable
'' is emitted where that name is not visible: fbc error 272. MEASURED, and the boundary is
'' narrow enough that guessing gets it wrong both ways -- a SHARED source is fine, a
'' module-level plain 'dim' target is fine, a 'static' target is fine, and merely READING
'' the static is fine. Only a static-storage TARGET initialised from one is refused.
static as integer si
dim shared as integer shi

dim as integer ptr okPlain = @si
static as integer ptr okStatic = @si
dim shared as integer ptr okShared = @shi
print @si

dim shared as integer ptr bad1 = @si

type Holder
    dummy as integer
    static hp as integer ptr
end type

dim Holder.hp as integer ptr = @si
