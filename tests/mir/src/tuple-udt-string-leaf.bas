'' A WHOLE UDT ELEMENT WHOSE FIRST FIELD IS A STRING, in a tuple literal. The field walk
'' flattens (string, Ent) to string leaves at 0 and 24, so 'kv.value' -- the whole Ent --
'' was handed to the STRING store for the leaf at 24, which declined; the return was
'' dropped and fb/map.bi's Pairs( ) yielded empty values. Measured, fbc-modern prints
'' 'k va vb' and 'done'.
type Ent
    as string a
    as string b
end type
type KV
    as string key
    as Ent value
end type
function F( byref kv as KV ) as (string, Ent)
    return (kv.key, kv.value)
end function
dim as KV k0
k0.key = "k" : k0.value.a = "va" : k0.value.b = "vb"
scope
    var t = F( k0 )
    print t._1; " "; t._2.a; " "; t._2.b
end scope
print "done"
