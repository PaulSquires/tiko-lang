namespace ex
	extern i as integer
	extern byref ri as integer
	type SomeUDT
		dummy as integer
		static i as integer
		static byref ri as integer
	end type
end namespace
namespace ex
	dim shared i as integer = &h11223344
	dim shared byref ri as integer = i
	dim shared SomeUDT.i as integer = &h55667788
	dim shared byref SomeUDT.ri as integer = SomeUDT.i
end namespace
using ex
print @ri = @i, @SomeUDT.ri = @SomeUDT.i, hex( ri ), hex( SomeUDT.ri )
ri = 5
print i
