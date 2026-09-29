'' A GOTO OVER A DEFINITION THAT NEEDS CONSTRUCTING -- fbc's error 105, on the GOTO line, once
'' per variable (fbc-modern 1.20). tiko accepted each, and at the label a string or an object
'' nobody constructed was in scope. Everything from line 40 on is fbc's and accepted. See
'' symbols/branchcross.bas.
type WithStr
    s as string
end type
type Pod
    a as long
end type
type Obj extends object
    a as long
end type
goto L1
dim as string s1, s2
L1:
goto L2
dim as long a2( 0 to 3 )
redim as long r2( 3 )
L2:
goto L3
dim as WithStr w3
dim as Obj o3
var v3 = "abc"
L3:
goto L4
scope
    dim as ustring u4
    L4:
end scope
sub F( )
    goto L5
    dim as string s5
    L5:
end sub
dim as long c = 1
if c then goto L6
dim as string s6
L6:
'' accepted from here
goto M1
dim as long i1
dim as zstring * 8 z1
dim as string * 8 f1
dim as Pod p1
dim as string ptr ps1
dim shared as string sh1
M1:
goto M2
scope
    dim as string s2b
end scope
M2:
M3:
dim as string s3b
goto M3
print "end"
