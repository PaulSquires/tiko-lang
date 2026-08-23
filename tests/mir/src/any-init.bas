'' 'dim x as T = ANY' INITIALISES NOTHING. It is the explicit request for an
'' uninitialised variable, and fbc emits the declaration and no store at all --
'' measured, for a scalar, a float and a UDT alike.
''
'' Treating 'any' as an ordinary initialiser expression left it with no value to
'' store, so the DECLARATION declined: 32 corpus lines, every one of them a statement
'' that is meant to produce no code. 'any' is a keyword, so no variable can be spelled
'' that way.
type U
    as integer a
    as double  b
end type

dim d as double = any
dim n as integer = any
dim p as any ptr = any
dim u as U = any

'' The runtime QUERIES that had no declaration at all. fbc predeclares them; tiko-lang
'' declares them in its prelude, and all three return a 32-bit LONG on both targets.
dim f as long = freefile
dim e as long = err
dim l as long = erl

print d, n, u.a, f, e, l
