' A method named GET or PUT, called from a sibling method without 'this.': 'get( x )' is the member,
' not the file function, which always has a comma (fbc-examples r2ice10, fbfrog tk.bas).
type TB
    as integer v(3) = {10, 20, 30, 40}
    declare function get(byval x as integer) as integer
    declare function put(byval x as integer) as integer
    declare function twice(byval x as integer) as integer
end type
function TB.get(byval x as integer) as integer
    return v(x)
end function
function TB.put(byval x as integer) as integer
    v(x) += 1
    return v(x)
end function
function TB.twice(byval x as integer) as integer
    var id = get(x)
    if get(x) <> 20 then id += 1
    select case get(x)
    case 20 : id += 100
    end select
    id += put(x + 2)
    return id + get(x + 1)
end function
dim as TB t
print t.twice(1), t.get(2), t.get(3)

' ...while the file function form still parses as one.
dim as integer f = freefile, n = 77, r
open "getputmember.tmp" for binary as #f
dim as integer e1 = put(#f, , n)
dim as integer e2 = get(#f, 1, r)
close #f
kill "getputmember.tmp"
print e1; e2; r
