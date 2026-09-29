'' 'any' cannot leave a new STRING uninitialized -- fbc's error 24 on the refused lines.
dim p1 as string ptr = new string( any )        '' 24
dim p2 as string ptr = new string[10] { any }   '' 24
dim p3 as integer ptr = new integer( any )      '' fine
dim p4 as integer ptr = new integer[10] { any } '' fine
