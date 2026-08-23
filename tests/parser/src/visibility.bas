'' Access-section labels in a TYPE body. Every rule here was measured against fbc,
'' including the two that symmetry would get wrong:
''
''   default is PUBLIC        an unlabelled member takes no flag
''   a label is a keyword + ':'   'private' alone is fbc error 203, not a label
''   labels are TYPE-only     'private:' in a UNION is fbc error 17, a syntax error
''   a label reaches into a nested anonymous union
''   'public:' restores after 'private:'
''
'' The colon is not a TK_COLON: the lexer folds ':' into a TK_EOL marked TF_COLON.

type T
	as integer pub0
private:
	as integer priv1
	declare sub PrivMethod( )
protected:
	as integer prot1
	union
		as integer inUnion
	end union
public:
	as integer pub1
	declare function PubMethod( ) as integer
end type

'' PRIVATE still modifies a procedure, which is why the label test needs the colon.
private sub ModuleStatic( )
end sub

'' A UNION takes no labels, so this member is named 'private' -- fbc rejects it, and
'' what matters here is that tiko-lang does not silently invent an access section.
union U
	as integer only1
end union
