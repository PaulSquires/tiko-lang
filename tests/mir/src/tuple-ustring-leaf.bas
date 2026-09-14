'' A USTRING LEAF OF A TUPLE LITERAL is written as a ustring. The store had only the
'' field's address, which names no type, so 'return (k, 1)' emitted fb_UStrAssignToA and
'' the key came back as UTF-16 read from narrow bytes -- every key fb/map.bi's Pairs( )
'' produced. Measured, fbc-modern prints '[key] 1'.
function F( byref k as ustring ) as (ustring, long)
    return (k, 1)
end function
dim as ustring k0 = "key"
scope
    var t = F( k0 )
    print "["; t._1; "]"; t._2
end scope
