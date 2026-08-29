'' A CAPTURING LAMBDA IS AN OBJECT, and its type is the closure UDT Resolve built for it.
'' Only the NON-capturing form was answered when inferring a generic's type argument --
'' that one is '@' over a generated name -- so a capturing lambda inferred nothing, the
'' generic never instantiated, and the call went out as 'declare void APPLYR()': a name
'' with no body and no result type, WITH NO DECLINE to say so. tests/mir/lambda-byref-arg
'' recorded exactly that, 'call void APPLY(...)' against nothing.
''
'' fbc instantiates over the closure struct and the program prints 5.
function ApplyR( of F )( byval v as long, byref f as F ) as long
	return f( v )
end function

dim as long bias = 2
dim as long got = ApplyR( 3, function[ byval bias ]( byval v as long ) as long
	return v + bias
end function )
print got

'' The non-capturing form beside it, which always inferred.
dim as long got2 = ApplyR( 3, function( byval v as long ) as long
	return v + 100
end function )
print got2
