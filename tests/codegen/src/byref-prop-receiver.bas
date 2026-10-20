' A method called on a BYREF property's result runs on the referent itself (fbc-examples r2ir01):
' it was copied into a temporary through an unsized aggregate load -- invalid IR.
type JB
    as JB ptr _parent
    as integer n = 7
    declare property Parent() byref as JB
    declare function GetP() byref as JB
    declare function Has(byref k as string) as boolean
    declare sub SetN(byval v as integer)
end type
property JB.Parent() byref as JB
    return *this._parent
end property
function JB.GetP() byref as JB
    return *this._parent
end function
function JB.Has(byref k as string) as boolean
    return len(k) = n
end function
sub JB.SetN(byval v as integer)
    n = v
end sub
dim as JB root, mid_, c
mid_._parent = @root
c._parent = @mid_
print c.Parent.Has("1234567"); c.Parent.Parent.Has("12")
c.Parent.SetN(9)
c.Parent.Parent.SetN(11)
c.GetP().SetN(13)
print root.n; mid_.n; c.n
