'' 'sizeof( T )' in a '#if'. The size of a BUILTIN is target data the preprocessor
'' legitimately knows; a user type is not, and stays unevaluable.
''
'' The table had two rows hardcoded at their win64 values and two types missing.
'' MEASURED on both targets:
''
''              win64   win32
''   integer      8       4
''   string      24      12
''   wstring      2       2
''   zstring      1       1
''   boolean      1       1
''
'' '#if sizeof( integer ) = 8' would have taken the wrong branch of every header on
'' win32 -- silently, because a wrong branch is not an error. WSTRING and ZSTRING were
'' simply absent, which is what '#if sizeof( wstring ) = 4' failed on.

#if sizeof( wstring ) = 2
#print WSTRING-2
#endif

#if sizeof( zstring ) = 1
#print ZSTRING-1
#endif

#if sizeof( boolean ) = 1
#print BOOLEAN-1
#endif

#if sizeof( longint ) = 8
#print LONGINT-8
#endif

'' typeof of two BUILTIN names is comparable without a symbol table.
#if typeof( long ) = typeof( long )
#print TYPEOF-SAME
#endif

print 1
