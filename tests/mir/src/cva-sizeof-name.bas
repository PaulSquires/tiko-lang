'' See ../cva-sizeof-name.test and ../cva-sizeof-name-linux.test.
dim as integer named = sizeof( cva_list )
dim as integer viaLen = len( cva_list )
dim v as cva_list
dim as integer ofVar = sizeof( v )
print named; viaLen; ofVar
