'' A GOTO INTO A SELECT CASE OR A FOR, over the TEMPORARY the statement defines -- fbc's error
'' 105, on the GOTO line (fbc-modern 1.20). A SELECT CASE copies a string subject into one
'' unless it is a literal or a variable's own name; a FOR over a UDT needing construction has
'' its counter, its end value and its step value. tiko accepted each. The SELECT and FOR at the
'' end are fbc's and accepted. See symbols/branchcross.bas.
type UDT
    i as integer
    declare constructor( byval i as integer )
    declare operator for( )
    declare operator for( byref stp as UDT )
    declare operator step( )
    declare operator step( byref stp as UDT )
    declare operator next( byref cond as UDT ) as integer
    declare operator next( byref cond as UDT, byref stp as UDT ) as integer
end type
constructor UDT( byval i as integer )
    this.i = i
end constructor
operator UDT.for( )
end operator
operator UDT.for( byref stp as UDT )
end operator
operator UDT.step( )
end operator
operator UDT.step( byref stp as UDT )
end operator
operator UDT.next( byref cond as UDT ) as integer
    operator = 0
end operator
operator UDT.next( byref cond as UDT, byref stp as UDT ) as integer
    operator = 0
end operator
type TS
    s as string
end type
dim as string s
dim as TS ts
dim as string sa( 0 to 1 )
goto L1
select case s + "1"
case "1"
    L1:
end select
goto L2
select case ts.s
case else
    L2:
end select
goto L3
select case sa( 1 )
case "1"
    scope
        L3:
    end scope
end select
goto L4
for x as UDT = 1 to 2 step 1
    L4:
next
'' accepted from here
goto M1
select case s
case "1"
    M1:
end select
goto M2
select case s + "1"
case "1"
end select
M2:
select case s + "1"
case "1"
    goto M3
case "2"
    M3:
end select
goto M4
for i as long = 1 to 2
    M4:
next
print "end"
