'' A LEADING '.' INSIDE A NAMESPACE IS THE GLOBAL-SCOPE SHORTHAND, so in
''
''     .OuterP .InnerP( h, 0 )
''
'' BOTH dots start a name and the second one begins an ARGUMENT. The postfix parser has
'' no symbols and read it as a member access of what the first call returns, which Check
'' then reported as TKO0630 -- '.' reaches a member of a value, this is a pointer. It is
'' what 180 of AfxNova's 409 examples reported first; AfxNova writes '.SetFocus
'' .GetNextDlgTabItem( GetParent( hwnd ), hwnd, 0 )' inside 'namespace AfxNova'.
''
'' WHAT DECIDES IS THE BASE, exactly as in fbc: a PROCEDURE takes an argument list, a
'' VARIABLE does not. Whitespace decides nothing -- measured, '.OuterP.InnerP( h, 0 )'
'' with no space still evaluates the inner call first, as the argument.
type U
    as long field1
end type
dim shared as U gvar

declare function OuterP( byval a as any ptr ) as any ptr
declare function InnerP( byval a as any ptr, byval b as long ) as any ptr
declare sub Take3( byval a as any ptr, byval b as long, byval c as long )

namespace NS
    '' the argument, spaced and unspaced
    sub run( byval h as any ptr )
        .OuterP .InnerP( h, 0 )
        .OuterP.InnerP( h, 0 )
    end sub

    '' ...and ahead of the paren-less arguments that follow it, which is AfxNova's shape
    sub run2( byval h as any ptr )
        .Take3 .InnerP( h, 0 ), 1, 2
    end sub

    '' A VARIABLE BASE IS STILL A MEMBER ACCESS, spaced or not, and assigning through it
    '' is the reading this rule must not take away.
    sub run3( )
        .gvar.field1 = 5
        .gvar .field1 = 7
    end sub
end namespace

function OuterP( byval a as any ptr ) as any ptr : return a : end function
function InnerP( byval a as any ptr, byval b as long ) as any ptr : return a : end function
sub Take3( byval a as any ptr, byval b as long, byval c as long ) : end sub

NS.run( 0 ) : NS.run2( 0 ) : NS.run3( )
print gvar.field1
