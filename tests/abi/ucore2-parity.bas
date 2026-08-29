'' ucore2-parity.bas -- the rest of the UStr* family: search, misc, assign,
'' concat, case, tempres, len, comp. Eighteen entry points.
''
'' NEEDS-GEN-LLVM -- fb_UStrDelete and friends are reserved names in fbc's
'' rtlLookupTB, so aliasing them under -gen gcc gives conflicting C declarations.
''
'' THE CASES THIS FILE EXISTS FOR, none of which shows up in ordinary use:
''
''   TEMP STEALING, BY POINTER IDENTITY. fb_UStrAssignEx MOVES a temporary's
''   buffer into the destination instead of copying it. Comparing text cannot
''   tell the two apart; comparing the DATA POINTER can, and if the move ever
''   silently became a copy, `a = b + c + d` would go quadratic with every test
''   still passing.
''
''   LSET PADS WITH SPACES while USTRING * N assignment pads with NULs. That is
''   the one place this family breaks its own padding rule, on purpose -- LSET is
''   a fixed-record field-width operation -- so both are asserted side by side.
''
''   THE TWO INSTRREV CLAMPS DIFFER. The pattern form can start no later than
''   src_len - pat_len + 1, because the pattern has to fit; the Any form is one
''   unit wide and can start at src_len. Using one clamp for both is invisible
''   until the start argument is out of range.
#include once "fbc-int/string.bi"

extern "rtlib"
    declare function pLen   alias "fb_UStrLen"   ( byval s as any ptr, byval sz as integer ) as integer
    declare function pCmp   alias "fb_UStrCompare" ( byval a as any ptr, byval asz as integer, byval b as any ptr, byval bsz as integer ) as long
    declare function pAsc   alias "fb_UStrAsc"   ( byval s as any ptr, byval sz as integer, byval p as integer ) as long
    declare sub      pLset  alias "fb_UStrLset"  ( byval d as any ptr, byval dsz as integer, byval s as any ptr, byval ssz as integer )
    declare sub      pRset  alias "fb_UStrRset"  ( byval d as any ptr, byval dsz as integer, byval s as any ptr, byval ssz as integer )
    declare sub      pSwap  alias "fb_UStrSwap"  ( byval a as any ptr, byval asz as integer, byval b as any ptr, byval bsz as integer )
    declare function pInstr alias "fb_UStrInstr" ( byval st as integer, byval s as any ptr, byval sz as integer, byval p as any ptr, byval psz as integer ) as integer
    declare function pInstrAny alias "fb_UStrInstrAny" ( byval st as integer, byval s as any ptr, byval sz as integer, byval p as any ptr, byval psz as integer ) as integer
    declare function pInstrRev alias "fb_UStrInstrRev" ( byval s as any ptr, byval sz as integer, byval p as any ptr, byval psz as integer, byval st as integer ) as integer
    declare function pInstrRevAny alias "fb_UStrInstrRevAny" ( byval s as any ptr, byval sz as integer, byval p as any ptr, byval psz as integer, byval st as integer ) as integer
    declare function pConcat alias "fb_UStrConcat" ( byval d as any ptr, byval a as any ptr, byval asz as integer, byval b as any ptr, byval bsz as integer ) as any ptr
    declare function pConcatAsg alias "fb_UStrConcatAssign" ( byval d as any ptr, byval dsz as integer, byval s as any ptr, byval ssz as integer, byval fr as long ) as any ptr
    declare function pAssignEx alias "fb_UStrAssignEx" ( byval d as any ptr, byval dsz as integer, byval s as any ptr, byval ssz as integer, byval fr as long, byval ii as long ) as any ptr
    declare function pAssign alias "fb_UStrAssign" ( byval d as any ptr, byval dsz as integer, byval s as any ptr, byval ssz as integer, byval fr as long ) as any ptr
    declare function pInit  alias "fb_UStrInit"  ( byval d as any ptr, byval dsz as integer, byval s as any ptr, byval ssz as integer, byval fr as long ) as any ptr
    declare function pUcase alias "fb_UStrUcase" ( byval s as any ptr, byval sz as integer ) as any ptr
    declare function pLcase alias "fb_UStrLcase" ( byval s as any ptr, byval sz as integer ) as any ptr
    declare function pTempRes alias "fb_UStrAllocTempResult" ( byval s as any ptr ) as any ptr
    declare function pAllocTmp alias "fb_hUStrAllocTemp" ( byval s as any ptr, byval n as integer ) as any ptr
    declare function pDelTmp alias "fb_hUStrDelTemp" ( byval s as any ptr ) as long
    declare sub      pUDel  alias "fb_UStrDelete" ( byval s as any ptr )
end extern

type UDESC field = 1
    as ushort ptr data_
    as integer  len_
    as integer  size_
end type
#define ULN(d) cint( (d)->len_ and cast( integer, &h7fffffffffffffffull ) )
#define UTEMP(d) iif( ((d)->len_ and cast( integer, &h8000000000000000ull )) <> 0, 1, 0 )
#define VARLEN -1
#define FIXED(n) ((n) or cast( integer, &h8000000000000000ull ))

dim shared as ushort ua(0 to 63), ub(0 to 63), uc(0 to 63)
dim shared as UDESC da, db, dc
sub mku( byval p as ushort ptr, byval d as UDESC ptr, byref s as string )
    for i as integer = 0 to len(s) - 1
        p[i] = asc( mid( s, i + 1, 1 ) )
    next
    p[len(s)] = 0
    d->data_ = p : d->len_ = len(s) : d->size_ = len(s)
end sub
function ushow( byval p as any ptr ) as string
    dim as UDESC ptr d = cptr( UDESC ptr, p )
    if( d = 0 ) then return "<null>"
    dim as string o = "len=" + str( ULN(d) ) + " ["
    for i as integer = 0 to ULN(d) - 1
        o += right( "000" + hex$( d->data_[i] ), 4 ) + " "
    next
    return o + "]"
end function
function ushowraw( byval p as ushort ptr, byval n as integer ) as string
    dim as string o = ""
    for i as integer = 0 to n - 1
        o += right( "000" + hex$( p[i] ), 4 ) + " "
    next
    return o
end function

'' ---- LEN counts CODE UNITS: an astral character is 2.
mku( @ua(0), @da, "abc" )
print "Len bmp        = "; pLen( @da, VARLEN )
ua(0) = asc("a") : ua(1) = &hD83D : ua(2) = &hDE00 : ua(3) = 0
da.data_ = @ua(0) : da.len_ = 3 : da.size_ = 3
print "Len astral     = "; pLen( @da, VARLEN )
print "Len fixed walk = "; pLen( @ua(0), FIXED(8) )
print "Len NULL       = "; pLen( 0, VARLEN )

'' ---- COMPARE. Length breaks a common prefix, and code-unit order puts an
'' astral character BELOW U+E000.
mku( @ua(0), @da, "abc" ) : mku( @ub(0), @db, "abc" )
print "Cmp eq         = "; pCmp( @da, VARLEN, @db, VARLEN )
mku( @ub(0), @db, "ab" )
print "Cmp longer     = "; pCmp( @da, VARLEN, @db, VARLEN )
print "Cmp shorter    = "; pCmp( @db, VARLEN, @da, VARLEN )
ua(0) = &hD83D : ua(1) = 0 : da.data_ = @ua(0) : da.len_ = 1 : da.size_ = 1
ub(0) = &hE000 : ub(1) = 0 : db.data_ = @ub(0) : db.len_ = 1 : db.size_ = 1
print "Cmp astral<E000= "; pCmp( @da, VARLEN, @db, VARLEN )

'' ---- ASC yields a CODE UNIT, so a surrogate half comes back as itself.
ua(0) = asc("a") : ua(1) = &hD83D : ua(2) = &hDE00 : ua(3) = 0
da.data_ = @ua(0) : da.len_ = 3 : da.size_ = 3
print "Asc 1          = "; hex$( pAsc( @da, VARLEN, 1 ) )
print "Asc 2 (high)   = "; hex$( pAsc( @da, VARLEN, 2 ) )
print "Asc 0          = "; pAsc( @da, VARLEN, 0 )
print "Asc 9          = "; pAsc( @da, VARLEN, 9 )

'' ---- LSET / RSET PAD WITH SPACES -- not with NULs. The destination's current
'' length is the field width and is never grown.
mku( @ua(0), @da, "......" ) : mku( @ub(0), @db, "ab" )
pLset( @da, VARLEN, @db, VARLEN ) : print "Lset 6 <- ab   "; ushow( @da )
mku( @ua(0), @da, "......" )
pRset( @da, VARLEN, @db, VARLEN ) : print "Rset 6 <- ab   "; ushow( @da )
mku( @ua(0), @da, "..." ) : mku( @ub(0), @db, "abcdef" )
pLset( @da, VARLEN, @db, VARLEN ) : print "Lset 3 <- 6chr "; ushow( @da )
mku( @ua(0), @da, "..." ) : mku( @ub(0), @db, "" )
pLset( @da, VARLEN, @db, VARLEN ) : print "Lset 3 <- ''   "; ushow( @da )
pLset( 0, VARLEN, @db, VARLEN )

'' ---- SWAP. Two var-len operands EXCHANGE DESCRIPTORS: the data pointers move
'' and no text is copied. Asserted by identity, because comparing the text after
'' a swap cannot tell an exchange from a copy.
mku( @ua(0), @da, "aaa" ) : mku( @ub(0), @db, "bbbbb" )
dim as ushort ptr pa0 = da.data_, pb0 = db.data_
pSwap( @da, VARLEN, @db, VARLEN )
print "Swap var: ptrs exchanged = "; iif( (da.data_ = pb0) andalso (db.data_ = pa0), 1, 0 ); _
      "  a="; ushow( @da ); "  b="; ushow( @db )
'' One side fixed: the TEXT has to move, and the shorter operand's tail is
'' space-filled because a fixed field cannot shrink.
mku( @ua(0), @da, "aaa" ) : mku( @ub(0), @db, "bb" )
pSwap( @ua(0), FIXED(3), @ub(0), FIXED(2) )
print "Swap fixed: a="; ushowraw( @ua(0), 3 ); " b="; ushowraw( @ub(0), 2 )

'' ---- INSTR family. 0 means not found; positions are 1-based code units.
mku( @ua(0), @da, "abcabc" ) : mku( @ub(0), @db, "bc" )
print "Instr 1        = "; pInstr( 1, @da, VARLEN, @db, VARLEN )
print "Instr 3        = "; pInstr( 3, @da, VARLEN, @db, VARLEN )
print "Instr 0        = "; pInstr( 0, @da, VARLEN, @db, VARLEN )
print "Instr 9        = "; pInstr( 9, @da, VARLEN, @db, VARLEN )
mku( @ub(0), @db, "" )
print "Instr empty    = "; pInstr( 1, @da, VARLEN, @db, VARLEN )
mku( @ub(0), @db, "zz" )
print "Instr missing  = "; pInstr( 1, @da, VARLEN, @db, VARLEN )

mku( @ub(0), @db, "cb" )
print "InstrAny 1     = "; pInstrAny( 1, @da, VARLEN, @db, VARLEN )
print "InstrAny 4     = "; pInstrAny( 4, @da, VARLEN, @db, VARLEN )
mku( @ub(0), @db, "z" )
print "InstrAny miss  = "; pInstrAny( 1, @da, VARLEN, @db, VARLEN )

'' THE TWO CLAMPS DIFFER. For the pattern form the last usable start is
'' src_len - pat_len + 1 (the pattern must fit); for the Any form it is src_len.
'' An out-of-range start is where using one clamp for both becomes visible.
mku( @ub(0), @db, "bc" )
print "InstrRev -1    = "; pInstrRev( @da, VARLEN, @db, VARLEN, -1 )
print "InstrRev 99    = "; pInstrRev( @da, VARLEN, @db, VARLEN, 99 )
print "InstrRev 3     = "; pInstrRev( @da, VARLEN, @db, VARLEN, 3 )
print "InstrRev 0     = "; pInstrRev( @da, VARLEN, @db, VARLEN, 0 )
mku( @ub(0), @db, "c" )
print "InstrRevAny -1 = "; pInstrRevAny( @da, VARLEN, @db, VARLEN, -1 )
print "InstrRevAny 99 = "; pInstrRevAny( @da, VARLEN, @db, VARLEN, 99 )
print "InstrRevAny 3  = "; pInstrRevAny( @da, VARLEN, @db, VARLEN, 3 )
print "InstrRevAny 0  = "; pInstrRevAny( @da, VARLEN, @db, VARLEN, 0 )

'' ---- CONCAT.
mku( @ua(0), @da, "ab" ) : mku( @ub(0), @db, "cd" )
dim as any ptr cat = pConcat( 0, @ua(0), FIXED(2), @ub(0), FIXED(2) )
print "Concat         "; ushow( cat ); "  temp="; UTEMP( cptr( UDESC ptr, cat ) )
pDelTmp( cat )

'' &= on a var-len destination grows in place.
dim as UDESC acc
acc.data_ = 0 : acc.len_ = 0 : acc.size_ = 0
pAssignEx( @acc, VARLEN, @ua(0), FIXED(2), 0, 1 )
pConcatAsg( @acc, VARLEN, @ub(0), FIXED(2), 0 )
print "ConcatAsg var  "; ushow( @acc )
'' On a fixed destination it clamps to the capacity instead of growing.
mku( @uc(0), @dc, "ab" )
pConcatAsg( @uc(0), FIXED(4), @ub(0), FIXED(2), 0 )
print "ConcatAsg fix4 "; ushowraw( @uc(0), 5 )
mku( @uc(0), @dc, "ab" )
pConcatAsg( @uc(0), FIXED(3), @ub(0), FIXED(2), 0 )
print "ConcatAsg fix3 "; ushowraw( @uc(0), 5 )
pConcatAsg( 0, VARLEN, @ub(0), FIXED(2), 0 )
pUDel( @acc )

'' ---- ASSIGN, and the fast path that a text comparison cannot see.
''
'' A var-len TEMPORARY source is MOVED: the destination ends up owning the very
'' buffer the temporary held. Checked by POINTER IDENTITY -- if this ever became
'' a copy the text would still be right and `a = b + c + d` would go quadratic.
dim as UDESC dst
dst.data_ = 0 : dst.len_ = 0 : dst.size_ = 0
dim as any ptr tmp = pAllocTmp( 0, 4 )
dim as UDESC ptr tmpd = cptr( UDESC ptr, tmp )
for i as integer = 0 to 3 : tmpd->data_[i] = asc("W") + i : next
tmpd->data_[4] = 0
dim as ushort ptr stolen = tmpd->data_
pAssignEx( @dst, VARLEN, tmp, VARLEN, 0, 1 )
print "Assign steals buffer = "; iif( dst.data_ = stolen, 1, 0 ); "  "; ushow( @dst )
print "  source cleared     = "; iif( tmpd->data_ = 0, 1, 0 )

'' A NON-temp source is copied, not stolen.
mku( @ub(0), @db, "xyz" )
dim as ushort ptr srcbuf = db.data_
pAssignEx( @dst, VARLEN, @db, VARLEN, 0, 0 )
print "Assign copies non-temp= "; iif( dst.data_ <> srcbuf, 1, 0 ); "  "; ushow( @dst )

'' An empty source: is_init decides whether there is anything valid to free.
pAssignEx( @dst, VARLEN, 0, VARLEN, 0, 0 )
print "Assign empty         "; ushow( @dst ); " data0="; iif( dst.data_ = 0, 1, 0 )

'' A FIXED-LENGTH destination is NUL-padded, NOT space-padded -- the opposite of
'' LSET above, and the rule the trim helpers depend on.
for i as integer = 0 to 7 : uc(i) = &hEEEE : next
mku( @ub(0), @db, "ab" )
pAssignEx( @uc(0), FIXED(5), @db, VARLEN, 1, 0 )
print "Assign fix5 fill     "; ushowraw( @uc(0), 7 )
for i as integer = 0 to 7 : uc(i) = &hEEEE : next
pAssignEx( @uc(0), FIXED(5), @db, VARLEN, 0, 0 )
print "Assign fix5 nofill   "; ushowraw( @uc(0), 7 )
'' Truncation to the capacity.
mku( @ub(0), @db, "abcdefgh" )
for i as integer = 0 to 9 : uc(i) = &hEEEE : next
pAssignEx( @uc(0), FIXED(3), @db, VARLEN, 1, 0 )
print "Assign fix3 trunc    "; ushowraw( @uc(0), 6 )

'' The two thin callers must differ only in is_init.
dim as UDESC d2
d2.data_ = 0 : d2.len_ = 0 : d2.size_ = 0
mku( @ub(0), @db, "pq" )
pInit( @d2, VARLEN, @db, VARLEN, 0 )
print "Init                 "; ushow( @d2 )
pAssign( @d2, VARLEN, @db, VARLEN, 0 )
print "Assign               "; ushow( @d2 )
pAssign( 0, VARLEN, @db, VARLEN, 0 )
pUDel( @d2 )
pUDel( @dst )

'' ---- UCASE / LCASE use the GENERATED TABLE, not ASCII and not the locale.
'' The accented letters are the cases that separate the two.
ua(0) = asc("a") : ua(1) = &h00E9 : ua(2) = &h00FF : ua(3) = &h0430 : ua(4) = 0
da.data_ = @ua(0) : da.len_ = 4 : da.size_ = 4
print "Ucase                "; ushow( pUcase( @da, VARLEN ) )
ua(0) = asc("A") : ua(1) = &h00C9 : ua(2) = &h0178 : ua(3) = &h0410 : ua(4) = 0
da.data_ = @ua(0) : da.len_ = 4 : da.size_ = 4
print "Lcase                "; ushow( pLcase( @da, VARLEN ) )
mku( @ua(0), @da, "" )
print "Ucase empty          "; ushow( pUcase( @da, VARLEN ) )

'' ---- AllocTempResult MOVES the descriptor and sets the temp bit.
dim as UDESC res
res.data_ = 0 : res.len_ = 0 : res.size_ = 0
mku( @ub(0), @db, "result" )
pAssignEx( @res, VARLEN, @db, VARLEN, 0, 1 )
dim as ushort ptr resbuf = res.data_
dim as any ptr tr = pTempRes( @res )
dim as UDESC ptr trd = cptr( UDESC ptr, tr )
print "TempResult moved     = "; iif( trd->data_ = resbuf, 1, 0 ); _
      "  temp="; UTEMP( trd ); "  "; ushow( tr )
print "  source cleared     = "; iif( res.data_ = 0, 1, 0 ); " len="; res.len_; " size="; res.size_
pDelTmp( tr )
