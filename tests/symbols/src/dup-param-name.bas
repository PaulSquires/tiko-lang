'' TWO PARAMETERS MAY SHARE A NAME. Measured, fbc accepts
''
''     declare function f cdecl ( byval size as uinteger, _
''                                byval size as uinteger = 1 ) as any ptr
''
'' -- and the SHIPPED HEADER fbc-int/memory.bi writes exactly that for callocate, so
'' reporting it as a duplicate broke every file that includes it. The second one wins
'' for the body, which is what re-declaring it gives.
declare function f cdecl ( byval size as uinteger, byval size as uinteger = 1 ) as any ptr
declare sub g( byval n as long, byval n as long )

'' AND ONLY IN A PROTOTYPE. The same duplicate in a DEFINITION is fbc error 4,
'' measured -- 'sub g( byval n as long, byval n as long )' with a body -- so the
'' allowance is gated on the procedure having no body. The first version of this
'' change allowed both, which would have accepted a program fbc rejects.
sub g( byval n as long, byval m as long )
end sub
