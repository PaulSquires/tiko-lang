'' ABS, SGN, LEN and IIF IN A '#if'. None of them needs a symbol table, which is the
'' only thing this evaluator is short of -- and without them every '#if' naming one was
'' "invalid expression" and the whole condition unevaluable. That is most of the
'' TKO0308 bucket: 100 occurrences apiece in qb/literal_types.bas,
'' optimizations/consteval.bas and fbc-int/query-symbol.bas.
''
'' SAFE DESPITE THE PP VALUE BEING INTEGER-ONLY: a float literal in a '#if' is already
'' refused outright rather than truncated, so none of these can be handed one and
'' quietly answer for a number it did not get.
#if abs( -3 ) <> 3
    #error abs of a negative
#endif
#if abs( 3 ) <> 3
    #error abs of a positive
#endif
#if sgn( -3 ) <> -1
    #error sgn negative
#endif
#if sgn( 0 ) <> 0
    #error sgn zero
#endif
#if sgn( 7 ) <> 1
    #error sgn positive
#endif
#if len( "ab" ) <> 2
    #error len
#endif
#if len( "" ) <> 0
    #error len empty
#endif
#if iif( 1, 2, 3 ) <> 2
    #error iif true
#endif
#if iif( 0, 2, 3 ) <> 3
    #error iif false
#endif
#if abs( sgn( -5 ) ) <> 1
    #error nested
#endif
#if iif( len( "abc" ) > 2, 10, 20 ) <> 10
    #error iif over len
#endif
'' SIZEOF is unchanged.
#if sizeof( integer ) <> 8
    #error sizeof
#endif
print "ok"
