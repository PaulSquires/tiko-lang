'' A qualified type name sees what its namespace imports with USING.
namespace A
	namespace B
		type T
			x as integer
		end type
	end namespace
	using B
end namespace
namespace C
	namespace D
		type U
			x as integer
		end type
	end namespace
end namespace
dim v as A.T                                    '' fine: through A's 'using B'
dim w as C.U                                    '' refused: C imports nothing
