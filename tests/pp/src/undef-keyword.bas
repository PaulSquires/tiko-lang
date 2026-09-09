'' '#undef' OF A KEYWORD. fbc's reserved words are SYMBOL TABLE entries, so '#undef
'' short' deletes one and the word is an ordinary identifier from there on.
''
'' MEASURED against C:\dev\fbc-modern\toolchains\fbc-modern-windows\fbc64.exe,
'' 2026-09-09, one probe per line:
''
''   #undef short : type short as integer : dim x as short : print sizeof(x)
''       fbc prints 8. tiko-lang printed 2 before this: the 'type' alias was
''       ignored SILENTLY -- nothing declined, nothing warned, the corpus file
''       quirk/undef.bas did not even count it as a decline.
''
''   #undef short : dim short as integer = 5 : print short
''       fbc prints 5. The word is a plain identifier, not a removed type.
''
''   #undef short : dim x as short
''       fbc: error 14, Expected identifier. Nothing puts the keyword back.
''
''   #undef mod : dim mod as integer = 7 : print mod
''       fbc prints 7. OPERATOR-class words de-reserve as well as type names.
''
''   #define short 5
''       fbc: error 4, Duplicated definition. A keyword and a macro can NEVER
''       share a name, so '#undef NAME' never has to choose between them.
''
''   sub s( ) : #undef short : ... : end sub    then    dim y as short
''       fbc: error 14. The de-reservation is NOT block-scoped, unlike a '#define'
''       inside a sub, which dies with the sub.
''
''   #undef short   then   #include a file writing 'type short as double'
''       sizeof( short ) = 8. It survives crossing into another file.
''
''   #undef NeverExisted
''       accepted, no diagnostic.
''
'' NOT covered here, and NOT implemented: the other half of quirk/undef.bas, where
'' '#undef f1' removes a PROCEDURE and '#undef N' a NAMESPACE. Those need the
'' preprocessor to share the symbol table -- see HANDOFF, "The PREPROCESSOR CANNOT
'' SEE DECLARED SYMBOLS".

#undef short
type short as integer

dim x as short          '' i64: the alias, not the 2-byte keyword
dim aShort as short = sizeof( short )

'' the de-reserved word is usable as an ORDINARY IDENTIFIER
#undef mod
dim mod as integer = 7

'' a name that was never anything at all
#undef NeverExisted

print sizeof( x )
print mod
