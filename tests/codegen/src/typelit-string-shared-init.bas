dim shared   z as zstring * 32 = type<string>( "13" )
dim shared   w as wstring * 32 = type<string>( "14" )
dim shared   s as string * 8 = type<string>( "15" )
print z; "|"; w; "|"; s; "|"; len( z ), len( w ), len( s )
