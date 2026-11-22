'' An element reached through a byref 'operator []', assigned a value its 'let' does not take.
type V
    as long z
    declare operator let ( byref o as const V )
end type
operator V.let ( byref o as const V )
    z = o.z
end operator
type M
    as V slot
    declare operator [] ( byref k as string ) byref as V
end type
operator M.[] ( byref k as string ) byref as V
    return slot
end operator
dim as M out_
dim as V vv
out_["n"] = 3.0
out_["n"] = 3
out_["n"] = "tiko"
out_["n"] = vv
print out_["n"].z
