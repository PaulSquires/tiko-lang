'' A FIXED 'ustring * N' AGAINST A BYREF USTRING PARAMETER IS A COPY, not an address.
'' Measured -- fbc emits, for the ustring call below:
''
''   memset( &TMP, 0, 24 );
''   fb_UStrAssign( &TMP, -1, UF, <tag>, 0 );
''   G( &TMP );
''   fb_UStrAssign( UF, <tag>, &TMP, -1, -1 );
''   fb_UStrDelete( &TMP );
''
'' There is no ustring temp-descriptor borrow in the runtime at all: libfb has
'' fb_StrAllocTempDescF and no fb_UStrAllocTempDescF, which is why the narrow twin
'' borrows and this one copies.
declare function G overload ( byref v as const string ) as long
declare function G overload ( byref v as const ustring ) as long

function G overload ( byref v as const string ) as long
	return 1
end function

function G overload ( byref v as const ustring ) as long
	return 2
end function

dim as string  * 24 nf = "x"
dim as ustring * 24 uf = "x"
'' The overload set picks one each: fbc's own answers, run, are 1 and 2.
print G( nf ), G( uf )
