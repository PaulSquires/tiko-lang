'' LINE INPUT's four entry points. The split is not where the keyword suggests: a WIDE
'' destination is a DIFFERENT FUNCTION rather than a flag, and the CONSOLE form is
'' different again, taking a prompt descriptor and two trailing flags the file form has
'' not got. Every shape below was read out of the C fbc generates.
dim as string s, ps
dim as zstring * 20 fz
dim as wstring * 20 fw, pfw
dim as zstring ptr z
dim as wstring ptr w

'' The file form. A wide destination through the narrow entry point would read bytes
'' into a uint16 buffer.
line input #1, s
line input #1, fz
line input #1, fw

'' THE LENGTH IS THE WRITTEN MAXIMUM WHEN THERE IS ONE: an unsized zstring has no
'' length of its own, so without it the runtime would be told 0.
line input #1, *z, 10
line input #1, *w, 10

'' The console form. An absent prompt is the EMPTY STRING, not a null pointer.
line input "", s
line input "", fw
line input ps, s

'' A NARROW PROMPT ON THE WIDE PATH IS CONVERTED -- fb_StrToWstr, and the result is
'' deleted -- and a WIDE prompt on the narrow path is converted the other way.
line input ps, *w, 10
line input pfw, s

'' A LEADING ';' makes the last argument 0 rather than -1: no echoed newline.
line input; "", s
