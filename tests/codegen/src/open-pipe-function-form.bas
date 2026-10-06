'' the function form 'open pipe( ... )' opens a pipe, like the statement form
dim as integer r = open pipe ( "echo hello" for input As #1)
print r
dim as string text
line input #1, text
print text
close #1
