'' INPUT and LINE INPUT separators, each measured with fbc-modern 1.20 -r -gen gcc
'' (syntax/input-f.bas and syntax/line-input.bas exercise them all):
''
''   line input , a       empty prompt, no "? "       fb_LineInput( "", a, -1, 0, 0, -1 )
''   line input ; b       no newline                  fb_LineInput( "", b, -1, 0, 0, 0 )
''   line input ;; c      empty prompt, "? "          fb_LineInput( "", c, -1, 0, -1, 0 )
''   line input d         neither                     fb_LineInput( "", d, -1, 0, 0, -1 )
''   input ;#1, e         the ';' comes before the '#'
''   input #1; f          and a ';' may follow the file number
dim as string a, b, c, d, e, f
line input , a
line input ; b
line input ;; c
line input d
input ;#1, e
input #1; f
