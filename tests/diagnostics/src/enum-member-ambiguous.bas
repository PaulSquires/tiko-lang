'' A bare member name two named enums declare: fbc's 255 at line 9 (fbc-modern 1.20). The
'' qualified spellings (line 10) and a member only one enum has (line 14) are fine.
enum E1
    Red = 1
end enum
enum E2
    Red = 2
end enum
print Red
print E1.Red, E2.Red
enum E3
    Blue = 3
end enum
print Blue
