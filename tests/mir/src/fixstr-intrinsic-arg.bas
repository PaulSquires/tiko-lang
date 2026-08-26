'' A 'string * N' IS A STRING ARGUMENT, and the intrinsic type table did not think so.
''
'' FixedStringElem answers TY_FIXSTR for one -- that is what it is for -- and IsStringy_
'' does not list TY_FIXSTR, so every intrinsic in that table refused a fixed narrow
'' string and left the call UNTYPED.
''
'' MEASURED: fbc takes all of them over one, with the same result types the var-length
'' forms give --
''
''   wstr( fs )      WSTRING * 1        val( fs )       DOUBLE
''   asc( fs )       ULONG              left( fs, 2 )   STRING
''   trim( fs )      STRING             ucase( fs )     STRING
''
'' THE COST OF THE OMISSION WAS NOT A DIAGNOSTIC. An untyped argument makes the
'' ENCLOSING call untypable too, so 'proc( wstr( fs ) )' declined with the failure three
'' layers from its cause: the call's argument path asks IsWideString_ of the argument's
'' type, there was none, so the wide-pointer push never happened and the call produced
'' nothing. Finding it took a marker in LowerCall, one in LowerCallParts and one on the
'' wide-pointer push -- an earlier pass had put a single marker where it could not tell
'' the first two apart and drew the wrong conclusion from it.
''
'' NARROWED TO THE INTRINSIC TABLE deliberately. IsStringy_ also feeds assignment
'' legality, binary-result typing and conversion cost, all of which are gated at 100%
'' against fbc and reach a fixed string by another route; widening it there is a
'' separate question with its own measurements to make.
function pw( byval b as wstring ptr ) as long
    return 1
end function

function pz( byval b as zstring ptr ) as long
    return 2
end function

dim fs as string * 10 = "abcdef"
dim as long r

print wstr( fs )
print val( fs )
print asc( fs )
print left( fs, 2 )
print trim( fs )
print ucase( fs )

r = pw( wstr( fs ) )
r = pz( fs )
print r
