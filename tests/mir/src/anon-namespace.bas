'' AN ANONYMOUS NAMESPACE IS ITS OWN NAMESPACE, and two of them are two different ones.
''
'' Unnamed, every one of them was the module scope, so a macro that wraps its helpers in
'' one -- which is exactly what warnings/const-overflow does, 508 times -- declared 'f'
'' again and again under a single name: clang's "invalid redefinition of function F".
''
'' Measured: fbc emits '_ZN7LABEL$21FEi' and '_ZN7LABEL$71FEd' for a private 'f' in each
'' of two anonymous namespaces. Its numbers are 2 and 7 for namespaces on lines 1 and 8,
'' so LABEL$ is a SEQUENCE and not a location -- and a line number would not do anyway,
'' because every token of a macro expansion carries the INVOCATION's location and 508
'' expansions all report the same one.
''
'' THE SPELLING NEED NOT MATCH FBC'S. These are PRIVATE symbols: unique within the
'' module, and linked against by nothing outside it -- fbc will not even let one be
'' CALLED from outside its namespace ("Variable not declared"), which is how the shape
'' of this test was settled. What is asserted is that the three names are DISTINCT.
#macro mk( T )
	namespace
		private function f( byval x as T ) as T
			return x + x
		end function
	end namespace
#endmacro

mk( long )
mk( double )
mk( short )
