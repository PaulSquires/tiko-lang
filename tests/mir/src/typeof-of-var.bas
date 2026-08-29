'' 'typeof( x )' OVER AN INFERRED 'var'. Resolve takes it from the SYMBOL, which is right
'' for a declared variable and empty for a 'var' -- so 'dim bar as typeof( foo )' left bar
'' untyped, its slot void, and every store through it declined.
''
'' THE POINTER FORM NEEDS THE SAME REPAIR, and needed one more thing: it resolves to a
'' NON-NONE pointer whose pointee is missing, so the symbol LOOKED typed and the repair
'' pass skipped it. '*baz = ...' then had an untyped target.
''
'' The symbol a bare name resolved to is recorded on the TYPEREF by Resolve, because an
'' expression node inside a procedure has no recorded scope to look one up FROM.
var foo = cast( integer, 0 )
dim bar as typeof( foo )
dim baz as typeof( foo ) ptr = @bar
*baz = &Hbaddf00d
print ( bar = &Hbaddf00d )
