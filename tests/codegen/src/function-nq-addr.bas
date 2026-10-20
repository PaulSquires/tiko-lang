' '@__FUNCTION_NQ__' is the address of the enclosing procedure: __FUNCTION_NQ__ is its
' name unquoted.
dim shared as any ptr seen
sub s()
    seen = @__FUNCTION_NQ__
end sub
function f() as integer
    return (@__FUNCTION_NQ__ = @f)
end function
s()
print (seen = @s); f()
