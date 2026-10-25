'' '@F( )' over a procedure is '@F' -- fbc-modern 1.20 prints -1 for each comparison
'' (2026-10-25). tiko declined it (TKO0994), with a ustring result too (tiko-editor TE-008).
function G( ) as long
    return 42
end function
function F( ) as ustring
    return "a"
end function
dim as any ptr p = @G( ), q = @G
print p = q
dim as any ptr pf = @F( ), qf = @F
print pf = qf
dim as function( ) as long fp = @G( )
print fp( )
