'' A CONCATENATION INTO A FIELD THAT A LATER TERM READS goes through a temporary.
''
'' 's = w & mid( s, 5 )' was already right for a plain variable; a FIELD target matched
'' nothing, so the chain was built in place -- "Z" went into st.text and mid( ) read
'' THAT. Measured, fbc prints 'ZB' for each line below and tiko printed 'Z'.
'' fb/tuiform.bi's backspace, delete, paste and selection are all
'' 'state->text = left( state->text, p ) & mid( state->text, ... )'.
''
'' In the golden, every assignment is fb_StrConcat / fb_UStrConcat into a temporary and
'' then one assign; none is an in-place fb_StrConcatAssign.

type S
	as string text
	as ustring utext
end type

dim as S st
st.text = "AxyB"
st.utext = "AxyB"
st.text = "Z" & mid( st.text, 4 )
st.utext = "Z" & mid( st.utext, 4 )
print st.text; st.utext

dim as S ptr ps = @st
ps->text = left( ps->text, 1 ) & mid( ps->text, 2 )
ps->utext = left( ps->utext, 1 ) & mid( ps->utext, 2 )
print st.text; st.utext
