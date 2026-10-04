'' 24 nested calls over an untyped leaf: Check re-typed the leaf per overload attempt at
'' every level, 2x per level -- 89 s. One TKO0743, at once.
function f overload ( byval a as integer ) as integer : return a : end function
function f overload ( byval a as double ) as double : return a : end function
print f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(zzundeclared))))))))))))))))))))))))
