'' THE REST OF THE OUTSIDE-A-NAMESPACE RULE, measured against fbc. Only a DEFINITION of
'' something the namespace DECLARED may come from outside: a second 'declare' of a
'' declared procedure is error 158, and so is 'dim shared a.i1' over a member that was a
'' plain dim rather than an extern. An owner that names nothing at all -- neither a
'' namespace nor a type -- is error 147 on a variable and error 3 on a procedure.
'' And 'redim a' over something that is not an array is error 63.
namespace a
    declare sub declared( )
    extern ev as integer
    dim shared plain as integer
end namespace

sub a.declared( )
end sub
dim a.ev as integer

declare sub a.declared( )
dim shared a.plain as integer
dim shared nobody.i1 as integer
declare sub nobody2.f1( )

extern scalar as integer
redim scalar
