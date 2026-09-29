'' 'this.X' names a member or nothing -- fbc's error 18 on the refused lines, even where
'' X is a global or a name a USING opened.
dim shared as integer dupv
sub dupp( )
end sub
namespace m
    dim as integer dupm
end namespace
type udt
    i as integer
    declare sub test( )
    declare sub other( )
end type
sub udt.other( )
end sub
sub udt.test( )
    using m
    print this.dupv                        '' 18
    this.dupp( )                           '' 18
    print this.dupm                        '' 18
    print this.nothere                     '' 18
    print this.i                           '' fine
    this.other( )                          '' fine
end sub
