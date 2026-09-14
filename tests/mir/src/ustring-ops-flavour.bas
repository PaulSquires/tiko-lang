'' FOUR USTRING OPERATIONS THAT REACHED A NARROW ENTRY POINT. Each lowered, verified and
'' dropped nothing, and each answered wrongly, because the operand was a ustring the
'' site did not recognise as one:
''
''   select case tok      the subject's slot is a bare pointer, and the flavour was read
''                        off the slot: fb_StrCompare over UTF-16 matched no case at all.
''                        tracks' trade database refused its own '#tradedb' header.
''   print "[" & u & "]"  the chain built a USTRING temporary; PRINT chose by the checked
''                        type, STRING, and printed its bytes as "[ t r a d e d b ]".
''   trim( "  " & u )     the same checked type sent the temporary to the narrow fb_TRIM.
''   asc( h, 2 )          fb_ASC read UTF-16 as bytes: 0 where the answer is 116.
''
'' Measured from fbc-modern's C: fb_UStrCompare per case value, fb_PrintUStr,
'' fb_UStrTrim( v, -1 ) and fb_UStrAsc( h, -1, 2 ). Run, it prints HIT, [tradedb], -1
'' and 116.
sub Sel( byref tok as ustring )
    select case tok
    case "#tradedb" : print "HIT"
    case else       : print "MISS"
    end select
end sub

sub PCat( byref u as ustring )
    print "[" & u & "]"
end sub

function Tr( byref u as ustring ) as long
    return ( trim( "  " & u & "  " ) = u )
end function

function A2( byref h as ustring ) as long
    return asc( h, 2 )
end function

Sel( "#tradedb" )
PCat( "tradedb" )
print Tr( "tradedb" )
print A2( "#tradedb" )
