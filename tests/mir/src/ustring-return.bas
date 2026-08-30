'' RETURNING A USTRING HAS ITS OWN TEMP-RESULT ENTRY POINT. Measured, fbc ends a
'' 'function f( ) as ustring' with
''
''     FBUSTRING* vr$7 = fb_UStrAllocTempResult( &fb$result$1 );
''
'' -- and tiko handed the FBUSTRING to the NARROW fb_StrAllocTempResult instead, which
'' books the wrong descriptor into the runtime's temp list. Every ustring-returning
'' procedure did it; the narrow case beside it was always right.
function Wide( ) as ustring
    dim as ustring u = "hi"
    return u
end function

function Narrow( ) as string
    dim as string s = "hi"
    return s
end function

dim as ustring a = Wide( )
dim as string b = Narrow( )
print a; b
