'' OPEN with a ustring filename converts it to a narrow string first.
dim as ustring p = "data.txt"
dim as long f = freefile( )
if open( p for binary access read as #f ) = 0 then close #f
open p for input as #f
close #f
