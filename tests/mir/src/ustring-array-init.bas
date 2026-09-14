'' A brace initialiser over a USTRING array: one fb_UStrInit per element, the unnamed
'' element left empty. ApexWealth's frmTxnDialog labels and apx_csv column names.
sub Labels( )
    dim as ustring labels_( 0 to 3 ) = { "Date", "Account", "Type" }
    print labels_( 0 ); "|"; labels_( 1 ); "|"; labels_( 2 ); "|"; len( labels_( 3 ) )
end sub

Labels( )
dim as ustring names_( 0 to 1 ) = { "quantity", "net amount" }
print names_( 0 ); "|"; names_( 1 )
