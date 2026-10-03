'' See ../field-named-function.test: a header whose lambda argument's 'end function' closes a
'' block its head, inside an argument list, never opened -- as fb/sort.bi's Sort does.
private function Apply( byval f as function( byval n as long ) as long, _
                        byval n as long ) as long
    return f( n )
end function

private function Twice( byval n as long ) as long
    return Apply( _
        function( byval k as long ) as long
            return k * 2
        end function, n )
end function
