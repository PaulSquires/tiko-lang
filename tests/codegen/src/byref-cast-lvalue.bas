' 'cast( integer, u ) = 78' over 'operator cast( ) byref as integer': the cast is an lvalue.
type UT
    as integer i
    as double d
    declare operator cast() byref as integer
    declare operator cast() byref as double
end type
operator UT.cast() byref as integer
    return this.i
end operator
operator UT.cast() byref as double
    return this.d
end operator
dim as UT u
cast(integer, u) = 78
cast(double, u) = 2.5
cast(integer, u) += 1
print u.i; u.d
