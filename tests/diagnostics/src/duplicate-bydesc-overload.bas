'' TWO OVERLOADS WITH ONE SIGNATURE ARE A DUPLICATE DEFINITION -- fbc error 4. MEASURED
'' over BYDESC parameters, where the ARRAY RANK is the interesting part: '()' is UNKNOWN
'' rank and collides with any, while two KNOWN ranks collide only when equal.
''
'' A DEFINITION OF AN ALREADY-DECLARED OVERLOAD IS NOT A SECOND ONE, and neither is a pair
'' that differs in element type or in result type.
declare sub okRank overload( a(any,any) as integer )
declare sub okRank overload( a(any) as integer )

declare sub okElem overload( a(any) as integer )
declare sub okElem overload( a(any) as single )

declare sub okDefined overload( a(any) as integer )
sub okDefined overload( a(any) as integer )
end sub

declare sub badSame overload( a(any) as integer )
declare sub badSame overload( a(any) as integer )

declare sub badUnknown overload( a(any) as integer )
declare sub badUnknown overload( a() as integer )
