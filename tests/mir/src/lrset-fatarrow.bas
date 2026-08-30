'' LSET AND RSET TAKE AN ASSIGNMENT, and '=>' spells one. Measured by running fbc: all
'' four spellings below pad identically, and 'if x => 3 then' is fbc error 31 -- so '=>'
'' is an ASSIGNMENT token and never a comparison, which is why it does NOT belong in the
'' infix precedence table beside '='.
''
'' The '=' form needed nothing: Expression reads 's = "x"' as one N_BINARY, which is what
'' LowerLrset expects. The arrow has no infix entry, so the expression stopped at 's' and
'' the rest of the line was dropped SILENTLY -- no diagnostic, the statement counted as
'' an LSET of one operand and declined. quirk/assignment-token.bas writes one of each.
''
'' The call sets below are byte-identical to fbc's: 4 fb_StrLset, 3 fb_StrRset,
'' 3 fb_StrAllocTempDescZ, 16 fb_StrAllocTempDescZEx, 6 fb_StrAssign, 2 fb_StrDelete.
dim s as string

s = "   " : lset s = "x"  : print "["; s; "]"
s = "   " : lset s => "x" : print "["; s; "]"
s = "   " : rset s = "x"  : print "["; s; "]"
s = "   " : rset s => "x" : print "["; s; "]"

'' A ZSTRING destination borrows a temporary descriptor, and the arrow changes nothing
'' about that.
dim as zstring * 8 z = "abcdefg"
lset z => "Q"
print "["; z; "]"
