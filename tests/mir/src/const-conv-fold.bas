'' A CONVERSION OVER A NAMED CONSTANT folds, which needs the symbol table.
const K = 300
const BF as boolean = cbool( false )
const BT as boolean = cbool( true )
const CB = cbyte( K )
const CL = clng( K )
const CI = iif( K > 0, K, -K )

dim as long a = cbyte( K )
dim as long b = clng( BF )
dim as long c = CB
dim as long d = CL
dim as long e_ = CI
dim as byte bb
dim as long f = ( bb = cbyte( BT ) )

print a, b, c, d, e_, f
