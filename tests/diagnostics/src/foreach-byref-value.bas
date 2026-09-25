'' 'for each byref' needs the iterator's Value( ) to return byref -- fbc's error 345 on
'' line 39 (fbc-modern 1.20). A byref Value( ) (line 41), a plain loop (43) and an array
'' (45) are accepted.
type ItV
    as long i
    declare function IsValid( ) as boolean
    declare function Value( ) as long
    declare sub MoveNext( )
end type
function ItV.IsValid( ) as boolean
    return this.i < 2
end function
function ItV.Value( ) as long
    return this.i
end function
sub ItV.MoveNext( )
    this.i += 1
end sub
type ItR
    as long i
    declare function IsValid( ) as boolean
    declare function Value( ) byref as long
    declare sub MoveNext( )
end type
function ItR.IsValid( ) as boolean
    return this.i < 2
end function
function ItR.Value( ) byref as long
    return this.i
end function
sub ItR.MoveNext( )
    this.i += 1
end sub
type CV : as long u : declare function GetIterator( ) as ItV : end type
function CV.GetIterator( ) as ItV : dim r as ItV : return r : end function
type CR : as long u : declare function GetIterator( ) as ItR : end type
function CR.GetIterator( ) as ItR : dim r as ItR : return r : end function
dim as CV vals : dim as CR refs
for each byref v as long in vals : next
dim as long a(2) = {1, 2, 3}
for each byref w as long in refs : next

for each x as long in vals : next

for each byref y as long in a : next
