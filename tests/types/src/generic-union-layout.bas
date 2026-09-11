'' A GENERIC UNION INSTANTIATES AS A UNION.
''
'' Collect marks an ordinary union from the declaration's NF_IS_UNION and the layout
'' pass reads SYMF_UNION_KIND off the symbol. InstantiateGeneric_ declared the
'' instantiation's symbol itself and set neither, so every generic union laid out as a
'' STRUCT: the fields did not overlap and sizeof came out double, silently.
union Pun( of T )
	as T a
	as integer b
end union

union PlainPun
	as double a
	as integer b
end union

dim as Pun( of double ) u
dim as PlainPun p
