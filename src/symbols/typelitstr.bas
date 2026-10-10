'' typelitstr.bas -- 'type( ... )' OVER A RECORD THAT HOLDS TEXT (T30).
''
'' Included from latesweeps2.bas, below braceinit.bas, in the same namespace and over the
'' same Ctx.
''
'' Measured on fbc-modern 1.20, 2026-10-02, over a type with a var-len 'string' or 'ustring'
'' field -- directly, or in a record field -- and no constructor:
''
''     r = type( "south", 1.0 )          error 99, "No matching overloaded function,
''     a( 1 ) = type( "x", 2.0 )         R.constructor()" -- every position, the
''     r.inner = type( "a", 1.0 )        initialiser included
''     r = type<R>( "south", 1.0 )
''     f( type( "a", 1.0 ) )
''     return type( "b", 2.0 )
''     dim as R r = type( "s", 1.0 )     (TKO0757 already, for a 'string' field)
''
''     r = type( )                       accepted: nothing to fill
''     the same over a type WITH a constructor -- accepted: the literal is a call
''
'' tiko refused only the 'dim' form, and only for 'string'. The rest compiled: an assignment
'' copied the literal's string descriptor into the record and freed it twice --
'' 0xC0000374 at exit on Windows, 'free(): double free' on Linux -- and a 'ustring' field
'' read back as CJK. TKO0929 now refuses every one of them, as fbc does: here for a literal
'' Check typed as the record itself -- an argument, 'type<T>( ... )' -- and in
'' tupleconv.bas's TypeLitTextBad_ for one it typed as a tuple and the destination names.

private sub CheckTypeLiteralText_ ( byref c as Ctx )
    dim as long total = c.ast->Count( )
    '' THE 'dim' FORM OVER A 'string' FIELD IS TKO0757's already, from
    '' CheckAggregateInitFields_; it is not reported twice.
    dim as containers.Array( of ubyte ) dimInit
    for n as long = 0 to total
        dimInit.Push( 0 )
    next
    for n as long = 1 to total - 1
        if c.ast->Kind( cast( NodeId, n ) ) <> N_VAR_ITEM then continue for
        dim as NodeId b = c.ast->stmts[cast( long, c.ast->nodes[n].data )].b
        if (b > 0) andalso (cast( long, b ) < total) then dimInit[cast( long, b )] = 1
    next
    for n as long = 1 to total - 1
        dim as NodeId id = cast( NodeId, n )
        if c.ast->Kind( id ) <> N_TUPLE then continue for
        if (c.ast->nodes[n].flags and NF_TYPE_LITERAL) = 0 then continue for
        if c.ast->lists[cast( long, c.ast->nodes[n].data )].count = 0 then continue for
        dim as TypeId t = ValueType_( c, c.info->TypeOf_( id ) )
        if t = TYPE_NONE then continue for
        if c.types->Kind( t ) <> TK_UDT then continue for
        dim as Symbol ptr tf = TlTextField_( c, t, 0, true )      '' tupleconv.bas
        if tf = 0 then continue for
        if (dimInit[n] <> 0) andalso (TlTextField_( c, t, 0, false ) <> 0) then continue for
        c.diags->Report( TKO0929, PointRange( c.ast->Loc( id ) ), _
                         c.types->Name( t ), c.names->Spelling( tf->name ) )
    next
end sub
