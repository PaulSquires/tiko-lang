'' 'const N = sizeof( T )' -- A CONSTANT WHOSE VALUE THE EVALUATOR CANNOT FOLD.
''
'' sizeof's answer comes from the UDT LAYOUT, which is computed after Check and which
'' the constant evaluator therefore has no way to reach. So the symbol carried no value,
'' every READ of it was silently valueless, and the statement that read it declined --
'' while 'print sizeof( T )' written out in full lowered on the line above, because
'' lowering has the layout.
''
'' A constant's initialiser is a constant expression, so lowering it at the use site
'' emits a constant and not work. Run under fbc this prints ' 16 16 15 32'.

type U
	dim as integer a, b
end type

const A = sizeof( U )
const B = A
const C = A - 1
dim d as integer = A * 2

print sizeof( U ); A; C; d
