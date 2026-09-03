'' TWO WAYS TO GET fbc's ERROR 158 FROM OUTSIDE A NAMESPACE OR TYPE, each measured with
'' its accepted twin -- and each measured IN ISOLATION, because fbc's first error can mask
'' every later one in the same file.
''
''   SHARED re-declares rather than re-dimensions, so a qualified declaration carrying it
''   is a declaration from outside; and a qualified DEFINITION -- one that writes a type
''   and no bounds -- may appear once and no more. A qualified statement WITH bounds is a
''   re-dimensioning and may repeat freely.
namespace ns
    dim shared arr( ) as integer
    extern ext as integer
    extern extArr( ) as integer
end namespace
type Holder
    foo as integer
    static stat( ) as integer
end type
'' Accepted: re-dimensioning an existing member, as often as you like.
redim ns.arr( 4 to 5 ) as integer
redim ns.arr( 6 to 7 ) as integer
'' Accepted: defining each extern exactly once, and the static member once.
dim ns.ext as integer
redim ns.extArr( ) as integer
redim Holder.stat( ) as integer
'' Accepted: a bounds-carrying redim after the definition re-dimensions it.
redim ns.extArr( 0 to 2 ) as integer
'' Refused: SHARED on a qualified declaration.
redim shared ns.arr( 8 to 9 ) as integer
'' Refused: a second definition of the same name.
dim ns.ext as integer
redim ns.extArr( ) as integer
redim Holder.stat( ) as integer
