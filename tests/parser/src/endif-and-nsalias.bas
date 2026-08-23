'' Two spellings the parser did not know, both measured against fbc.
''
'' ENDIF is 'END IF' written as ONE WORD, and closes a block exactly as the two-word
'' form does -- with or without ELSEIF and ELSE branches before it.
''
'' NAMESPACE ... ALIAS is a MANGLING control, exactly as ALIAS is on a procedure. The
'' alias REPLACES the namespace's name in every mangled symbol under it and keeps its
'' CASE, where a plain namespace is uppercased:
''
''   namespace aaa alias "zzz"    _ZN3zzz1FEv
''   namespace aaa                _ZN3AAA1FEv
''
'' Parsing the clause without carrying it into the mangler would have emitted the wrong
'' name for every procedure in the namespace, silently -- which is why the alias reaches
'' the namespace SYMBOL and not just the AST.
''
'' fbc REJECTS an empty alias, error 304 'ALIAS name string is empty'. tiko-lang accepts it;
'' that diagnostic is owed.

dim i as long

if i then
	i = 1
endif

if i then
	i = 1
elseif i = 2 then
	i = 3
else
	i = 4
endif

namespace aaa alias "zzz"
	declare sub f( )
end namespace

sub aaa.f( )
end sub
