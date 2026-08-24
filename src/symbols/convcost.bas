'' convcost.bas -- THE POINTER HALF OF CONVERSION COSTING.
''
'' How near two pointee types are, and what a pointer conversion costs. Split out of
'' check.bas at the 1500-line cap and included from it in the same place, before
'' ConversionCost, which is their only caller. Nothing in them changed in the move.

'' What a pointer costs on one side of a conversion or the other. Split out of
'' ConversionCost only because the pointer rules share none of its machinery: no rank,
'' no width distance, no signedness of the POINTER -- only of what it points at.
private function PointeeNear_ _
    ( byval a as Tko.TypeId, byval b as Tko.TypeId, _
      byref types as Tko.TypeContext ) as boolean

    '' Two pointees are near enough that fbc passes one for the other in silence when
    '' they are the same WIDTH and the same CLASS. Both halves are needed: 'ulong ptr'
    '' passes for 'long ptr' without a word, while 'single ptr' -- the same four bytes
    '' -- warns. WSTRING counts as an integer of its target width, which is what makes
    '' 'wstring ptr' and 'short ptr' interchangeable on Windows and not on Linux.
    if types.Kind( a ) <> Tko.TK_BUILTIN then return false
    if types.Kind( b ) <> Tko.TK_BUILTIN then return false
    dim as Tko.BuiltinType ab = types.BuiltinOf( a )
    dim as Tko.BuiltinType bb = types.BuiltinOf( b )
    if (ab = Tko.TY_ANY) orelse (bb = Tko.TY_ANY) then return false
    if IsFloat_( ab ) <> IsFloat_( bb ) then return false
    if types.Layout( a ).size <> types.Layout( b ).size then return false
    return types.Layout( a ).size > 0
end function

private function PointerCost_ _
    ( byval from_ as Tko.TypeId, byval to_ as Tko.TypeId, _
      byval srcP as boolean, byval dstP as boolean, _
      byref types as Tko.TypeContext, byval overloaded as boolean ) as long

    if srcP andalso dstP then
        '' Identical pointer types were already answered CONV_EXACT by the caller, so
        '' what is left is a mismatch.
        dim as Tko.TypeId di = types.Inner( to_ )
        if types.Kind( di ) = Tko.TK_BUILTIN then
            if types.BuiltinOf( di ) = Tko.TY_ANY then return CONV_PTR_ANY
        end if
        dim as Tko.TypeId si = types.Inner( from_ )
        if types.Kind( si ) = Tko.TK_BUILTIN then
            if types.BuiltinOf( si ) = Tko.TY_ANY then return CONV_PTR_NEAR
        end if
        if PointeeNear_( si, di, types ) then return CONV_PTR_NEAR
        '' The warning-3 tier. Accepted on its own; gone the moment there is a choice.
        if overloaded then return CONV_NONE
        return CONV_PTR_OTHER
    end if

    if srcP then
        '' A pointer reaches an integer of POINTER WIDTH and nothing else -- not
        '' 'long', not 'double', not 'boolean', and not 'string'. It reaches none of
        '' them at all once the procedure is overloaded: offered 'string' and
        '' 'integer', a pointer argument makes fbc refuse rather than take integer.
        if overloaded then return CONV_NONE
        if types.Kind( to_ ) <> Tko.TK_BUILTIN then return CONV_NONE
        if IsPointerSized_( types.BuiltinOf( to_ ), types ) = false then return CONV_NONE
        return CONV_PTR_CLASS
    end if

    '' A non-pointer reaching a pointer. The string family reaches ONLY a pointer to a
    '' string, which is the conversion fbcunit's CU_ASSERT_ is built out of.
    if types.Kind( from_ ) <> Tko.TK_BUILTIN then return CONV_NONE
    dim as Tko.BuiltinType srcB = types.BuiltinOf( from_ )
    dim as Tko.TypeId pointee = types.Inner( to_ )
    dim as Tko.BuiltinType dstB = Tko.TY_NONE
    if types.Kind( pointee ) = Tko.TK_BUILTIN then dstB = types.BuiltinOf( pointee )

    if IsStringy_( srcB ) then
        if (dstB <> Tko.TY_ZSTRING) andalso (dstB <> Tko.TY_WSTRING) then return CONV_NONE
        '' A ZSTRING * n -- which is what a string LITERAL is -- prefers 'zstring ptr';
        '' a WSTRING * n prefers 'wstring ptr'. A var-len STRING is neither, and takes
        '' zstring before wstring.
        if srcB = dstB then return CONV_STRPTR_SAME
        if srcB = Tko.TY_STRING then
            if dstB = Tko.TY_ZSTRING then return CONV_STRPTR_OTHER
            return CONV_STRPTR_OTHER + 10
        end if
        return CONV_STRPTR_OTHER
    end if

    '' An integer of pointer width. This one stays viable when overloaded -- it is
    '' warning 1, 'Passing scalar as pointer', and fbc treats the two warnings
    '' differently: offered 'any ptr' and 'string', the argument 1 takes any ptr.
    if IsPointerSized_( srcB, types ) = false then return CONV_NONE
    return CONV_PTR_CLASS
end function
