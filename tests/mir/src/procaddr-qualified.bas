'' '@NS.Proc' -- THE ADDRESS OF A QUALIFIED PROCEDURE. It is an N_MEMBER, so it fell
'' through to the FIELD path, found no field of that name and declined -- while the
'' unqualified '@Proc' beside it lowered, because the address-of-a-symbol path has
'' answered SYM_PROC all along.
''
'' Measured, and the namespace changes only the mangled name:
''
''     PW$0  = (tmp$1)&_ZN2NS5TRAMPEPv;
''     PW2$0 = (tmp$1)&_ZN2NS6TRAMP2EPv;
''     PW3$0 = (tmp$1)&TRAMP3;
namespace NS
    sub Tramp stdcall( byval p as any ptr )
    end sub
    sub Tramp2( byval p as any ptr )
    end sub
end namespace

sub Tramp3 stdcall( byval p as any ptr )
end sub

dim as sub stdcall( byval as any ptr ) pw = @NS.Tramp
dim as sub( byval as any ptr ) pw2 = @NS.Tramp2
dim as sub stdcall( byval as any ptr ) pw3 = @Tramp3
print (pw <> 0), (pw2 <> 0), (pw3 <> 0)
