'' A VAR-LEN STRING WITH STATIC STORAGE CANNOT BE INITIALISED (fbc error 87). The symbol
'' sweep reads the initialiser off the symbol's FIRST declaration, so two shapes escaped
'' it: a type's static member DEFINED outside the type, and a namespace variable defined
'' by a qualified name. Both are static storage and both are refused.
type Holder
    dummy as integer
    static s as string
    static fixed as zstring * 8
end type

namespace ns
    extern ss as string
end namespace

'' A FIXED string has storage of its own and the loader can fill it -- accepted.
dim Holder.fixed as zstring * 8 = "ok"

var Holder.s = "foo"
dim ns.ss as string = "bar"
