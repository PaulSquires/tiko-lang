'' 'ON ERROR GOTO 0' CLEARS THE HANDLER -- fbc emits 'fb_ErrorSetHandler( (void*)0ull )'.
''
'' IT IS THE ONLY INTEGER SPELLING THAT MEANS ANYTHING HERE: a numeric label is fbc's
'' error 146 in the fb dialect, so there is no 'on error goto 5' to target. The parser
'' took the integer's LITERAL POOL INDEX for an intern id and came out naming a label
'' called 'chr' -- whatever id 0 happens to be -- so this would have installed a handler
'' at a label nobody wrote.
on error goto h
on error goto 0

dim as integer a(0 to 2)
dim as integer i = 9
a(i) = 1
print "no error"
end 0

h:
print "unreachable"
end 1
