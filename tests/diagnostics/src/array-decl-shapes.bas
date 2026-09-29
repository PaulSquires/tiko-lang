'' Array declarations fbc refuses: bounds on a COMMON array (136), an ellipsis bound with no
'' initializer to count (281), and an ellipsis bound on a REDIM (76).
common c1(0) as integer                        '' 136
common c2() as integer                         '' fine
extern e1(0 to ...) as integer                 '' 281
dim d1(0 to ...) as integer                    '' 281
dim d2(0 to ...) as integer = { 1, 2 }         '' fine
dim r1() as integer
redim r1(0 to ...) as integer                  '' 76
