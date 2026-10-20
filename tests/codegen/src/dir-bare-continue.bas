' A bare 'dir' -- no parentheses -- continues the walk 'dir( pattern )' started, as
' 'dir( )' does. Three files, then the empty string.
dim as string base_ = "tests/codegen/dirbare.tmp"
mkdir base_
for i as integer = 1 to 3
    open base_ & "/f" & i & ".txt" for output as #1 : close #1
next
dim as integer n = 0
dim as string f = dir(base_ & "/*.txt")
while len(f)
    n += 1
    f = dir
wend
print "found"; n; " last=["; f; "] next=["; dir; "]"
for i as integer = 1 to 3
    kill base_ & "/f" & i & ".txt"
next
rmdir base_
