'' A whole array as the data of a file GET or PUT -- fbc's error 73 on the refused lines.
dim values(0 to 3) as integer
dim dyn() as integer
dim z as zstring * 8
put #1, , values                               '' 73
get #1, , dyn                                  '' 73
put #1, , values( )                            '' fine: the whole array, written so
put #1, , values( 0 )                          '' fine: one element
put #1, , z                                    '' fine: a fixed string
