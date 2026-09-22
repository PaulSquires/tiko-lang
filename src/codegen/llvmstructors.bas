'' llvmstructors.bas -- module constructors and destructors, in fbc's order.
''
'' Included from llvmemit.bas, after GlobalName; split out at the 1500-line cap.
''
'' MODULE-LIFETIME STRUCTORS. gcc spells them an attribute and LLVM a list; the third
'' field of a list entry -- the data a structor is associated with -- is null because
'' these belong to the module rather than to any one object.
''
'' Measured, fbc emits 'void CHECK( void ) __attribute__(( destructor ));' and the
'' program prints '1  1'. tiko once emitted no destructor list at all and printed
'' nothing -- which only build/runscan.sh could see, because it compiles, it links, and
'' it is silent. tests/vendor/fbc-tests/scopes/dtor_eol_eof1.bas is the corpus file.
''
'' THE ORDER IS THE PLATFORM'S, and fbc gets it for nothing: gcc writes every structor
'' in declaration order -- an unnumbered one into .ctors or .init_array, a numbered one
'' ('constructor 101') into a section named for its number -- and each platform's
'' start-up walks those its own way. Measured with fbc-modern's default backend, three
'' constructors a1 b2 c3, three destructors d1 d2 d3, 'constructor 101' / '200' /
'' 'destructor 101', and modules linked M A B:
''
''                       constructors              destructors      modules (ctors)
''     win64 (mingw)     101 200  c3 b2 a1        d1 d2 d3  101    B A M
''     linux-x86_64      101 200  a1 b2 c3        d3 d2 d1  101    M A B
''
'' -- mingw walks .ctors backwards and .dtors forwards, ELF walks .init_array forwards
'' and .fini_array backwards, and a NUMBERED group of either walks the same way as the
'' unnumbered: fbc prints 'b a' for two 'constructor 150's written a, b on win64. A
'' written 65535 IS unnumbered -- gcc puts 'constructor( 65535 )' and 'destructor(
'' 65535 )' in plain .ctors / .dtors / .init_array, checked on both. tiko ran everything
'' forwards and ignored the number, so fbc's own concurrency/sched.bas -- whose first
'' test needs a later test's goroutines to have started the pool -- failed on tiko
'' alone.
''
'' SO THIS WRITES WHAT gcc WRITES. A NUMBERED structor goes out as a pointer in gcc's
'' own section for its number, kept by @llvm.used, in declaration order -- not through
'' LLVM's list priority, which REVERSES a .ctors list on win64 and has no spelling for
'' the .CRT$X layout below. The UNNUMBERED keep the LLVM list, in the order that makes
'' each target's walk come out as fbc's:
''
''   linux-x86_64   .init_array / .fini_array.NNNNN (the number): as declared.
''   win64          .ctors / .dtors.NNNNN (65535 minus the number). LLVM reverses the
''                  .ctors/.dtors list, so it is written reversed to cancel that.
''   win64-msvc     .CRT$XCV / .CRT$XTY + (65535 minus the number) -- after the
''                  unnumbered .CRT$XCU / .CRT$XTX, which is where mingw's sorted
''                  .ctors.* sit relative to .ctors. tiko-rt's start-up walks .CRT$XC*
''                  backwards and .CRT$XT* forwards (lib/rt/src/c/msvccrt.c), as
''                  mingw walks .ctors and .dtors, so both lists go out as declared.
private function StructorSection_ _
    ( byref e as EmitCtx, byval isCtor as boolean, byval prio as long ) as string
    select case e.tgt->id
    case Tko.TARGET_LINUX_X86_64
        return iif( isCtor, ".init_array.", ".fini_array." ) & right( "0000" & str( prio ), 5 )
    case Tko.TARGET_WIN64
        return iif( isCtor, ".ctors.", ".dtors." ) & right( "0000" & str( 65535 - prio ), 5 )
    case else
        return iif( isCtor, ".CRT$XCV", ".CRT$XTY" ) & right( "0000" & str( 65535 - prio ), 5 )
    end select
end function

private function StructorLists_( byref e as EmitCtx, byref m as MirModule ) as string
    dim as string r, used
    dim as long nused = 0
    for pass as long = 0 to 1
        dim as boolean isCtor = (pass = 0)
        dim as FB.Array( of long ) dflt
        for fi as long = 0 to m.functions.Count - 1
            dim as MirFunction ptr f = m.functions[fi]
            if f = 0 then continue for
            dim as boolean want = iif( isCtor, f->isModuleCtor, f->isModuleDtor )
            if want = false then continue for
            dim as boolean unnumbered = (f->structorPrio = 0) orelse (f->structorPrio = 65535)
            if unnumbered then
                dflt.Push( fi )
                continue for
            end if
            '' WRITABLE, except on win64-msvc. The linker merges a section by name AND
            '' flags, and a read-only '.ctors.65434' did not join mingw's writable
            '' .ctors between __CTOR_LIST__ and __CTOR_END__, so it never ran; clang
            '' marks its own .ctors.NNNNN writable. The .CRT$X fragments are read-only,
            '' as tiko-rt's own brackets are.
            dim as string gn = "@__tko_" & iif( isCtor, "ctor.", "dtor." ) & str( nused )
            dim as string gk = iif( e.tgt->id = Tko.TARGET_WIN64_MSVC, "constant", "global" )
            r += gn & " = internal " & gk & " ptr " & GlobalName( e, f->name ) & _
                 ", section """ & StructorSection_( e, isCtor, f->structorPrio ) & _
                 """, align 8" & chr( 10 )
            if nused > 0 then used += ", "
            used += "ptr " & gn
            nused += 1
        next
        if dflt.Count = 0 then continue for
        dim as boolean rev = (e.tgt->id = Tko.TARGET_WIN64)
        dim as string items
        for k as long = 0 to dflt.Count - 1
            dim as long fi = dflt[iif( rev, dflt.Count - 1 - k, k )]
            if k > 0 then items += ", "
            items += "{ i32, ptr, ptr } { i32 65535, ptr " & _
                     GlobalName( e, m.functions[fi]->name ) & ", ptr null }"
        next
        r += "@llvm.global_" & iif( isCtor, "ctors", "dtors" ) & " = appending global [" & _
             str( dflt.Count ) & " x { i32, ptr, ptr }] [" & items & "]" & chr( 10 )
    next
    if nused > 0 then
        r += "@llvm.used = appending global [" & str( nused ) & " x ptr] [" & used & _
             "], section ""llvm.metadata""" & chr( 10 )
    end if
    return r
end function
