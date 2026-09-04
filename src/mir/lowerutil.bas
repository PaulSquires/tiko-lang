'' lowerutil.bas -- the small MIR builders every lowering file uses: block and
'' instruction emission, constants, the numeric COERCION rules and temporaries.
'' Split out of lower.bas, which reached the 1500-line cap. Nothing here changed in
'' the move. Included by lower.bas, INSIDE namespace Tko.Mir.

function StmtOf _
    ( byref c as Ctx, byval id as Tko.NodeId ) as Tko.StmtPayload ptr
    return @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
end function

'' -------------------------------------------------------------- construction

function NewBlock( byref c as Ctx, byref label as string ) as long
    dim as MirBlock b
    b.label = c.names->GetString( label & str( c.f->blocks.Count ) )
    b.term = cast( ubyte, MTERM_NONE )
    b.target = -1
    b.target2 = -1
    c.f->blocks.Push( b )
    c.st->blocks += 1
    return c.f->blocks.Count - 1
end function

'' Instructions are appended to the FUNCTION's list and the current block's extent is
'' widened. That only works while blocks are built in order, which is why lowering
'' never returns to a finished block -- it opens a new one instead.
function Emit( byref c as Ctx, byref ins as MirInst ) as MirValue
    dim as MirValue v
    if c.curBlock < 0 then return v
    dim as MirOp op = cast( MirOp, ins.op )
    '' An instruction that would produce a VOID result is not emitted at all. It
    '' means the frontend could not type the expression, and a well-formed IR with a
    '' gap in it is far more useful than a complete one that is malformed.
    if OpHasResult( op ) andalso (ins.ty = cast( ubyte, MT_VOID )) then
        if (op <> M_CALL) andalso (op <> M_CALL_RTL) andalso _
           (op <> M_CALL_IND) then
            SkipHere( c )
            return v
        end if
    end if
    '' A call returning void produces no value, so it gets no result temp. Giving it
    '' one made every constructor call read as '%2 = call void', which is noise in a
    '' listing the golden tests assert on.
    dim as boolean makesValue = OpHasResult( op )
    if ins.ty = cast( ubyte, MT_VOID ) then makesValue = false
    if makesValue then
        ins.result = c.f->nextTemp
        c.f->nextTemp += 1
    end if
    c.f->blocks[c.curBlock].insts.Push( ins )
    c.st->insts += 1
    if makesValue then
        v.kind = cast( ubyte, MV_TEMP )
        v.ty = ins.ty
        v.id = ins.result
    end if
    return v
end function

'' An empty value, for the terminators that carry none. FreeBASIC will not take a
'' constructed default argument, so it is spelled once here rather than at every call.
function NoVal( ) as MirValue
    dim as MirValue v
    return v
end function

sub Terminate _
    ( byref c as Ctx, byval k as MirTermKind, byval t1 as long, _
      byval t2 as long, byref cond as MirValue )

    if c.curBlock < 0 then return
    dim as MirBlock ptr b = @c.f->blocks[c.curBlock]
    '' A block already terminated is left alone: the second terminator would be
    '' unreachable, and silently dropping it is what 'return' inside an IF needs.
    if b->term <> cast( ubyte, MTERM_NONE ) then return
    b->term = cast( ubyte, k )
    b->target = t1
    b->target2 = t2

    '' A RETURNED VALUE IS COERCED TO THE FUNCTION'S DECLARED RETURN TYPE.
    ''
    '' FreeBASIC's promotions make an expression wider than what it is returned as --
    '' 'function f( ) as long' whose body is 'a * 100 + b' computes in INTEGER, because
    '' long + long is integer. fbc truncates at the return: '(int32)((int64)A * 100 +
    '' (int64)B)'. Without this the emitted IR says 'ret i64' from a function declared
    '' i32, which LLVM rejects outright -- "value doesn't match function result type".
    ''
    '' Scalars only. An aggregate is copied rather than converted, a pointer return is
    '' already the shape the ABI wants, and a void return has no value to coerce.
    dim as MirValue rv = cond
    if k = MTERM_RET then
        if rv.kind <> cast( ubyte, MV_NONE ) then
            dim as MirType want = cast( MirType, c.f->retTy )
            dim as MirType have = cast( MirType, rv.ty )
            dim as boolean bothScalar = _
                (want <> MT_VOID) andalso (want <> MT_AGG) andalso _
                (have <> MT_VOID) andalso (have <> MT_AGG)
            if bothScalar andalso (want <> have) then
                rv = Coerce( c, rv, want, false )
            end if
        end if
    end if
    b->cond = rv
end sub

function ConstInt _
    ( byref c as Ctx, byval v as longint, byval t as MirType ) as MirValue
    dim as MirInst ins
    ins.op = cast( ushort, M_CONST )
    ins.ty = cast( ubyte, t )
    ins.imm = v
    return Emit( c, ins )
end function

function ConstFloat _
    ( byref c as Ctx, byval v as double, byval t as MirType ) as MirValue
    dim as MirInst ins
    ins.op = cast( ushort, M_CONST )
    ins.ty = cast( ubyte, t )
    ins.fimm = v
    return Emit( c, ins )
end function

'' A typed zero. A float result slot must be zeroed with a FLOAT constant: an integer
'' zero stored into an f64 slot is a type mismatch the verifier catches, and would be a
'' reinterpreted bit pattern if it did not.
function ZeroOf( byref c as Ctx, byval t as MirType ) as MirValue
    if IsFloatTy( t ) then return ConstFloat( c, 0.0, t )
    return ConstInt( c, 0, t )
end function

function IsFloatTy( byval t as MirType ) as boolean
    return (t = MT_F32) orelse (t = MT_F64)
end function

'' A MIR type's size in BYTES, for the temporaries that hold one.
function TyWidthBytes_( byval t as MirType ) as long
    select case t
    case MT_I8  : return 1
    case MT_I16 : return 2
    case MT_I32, MT_F32 : return 4
    case MT_I64, MT_F64, MT_PTR : return 8
    end select
    return 8
end function

private function TyWidth( byval t as MirType ) as long
    select case t
    case MT_I8  : return 8
    case MT_I16 : return 16
    case MT_I32, MT_F32 : return 32
    case MT_I64, MT_F64, MT_PTR : return 64
    end select
    return 0
end function

'' MIR has NO implicit conversions (docs/plan/09 section 5, rule 4), so a value whose
'' type differs from the one an instruction needs gets an explicit one. Without this
'' an integer literal -- which FreeBASIC types as INTEGER, so i64 -- is compared
'' against an i32 counter, and the IR states something the backend cannot honour.
'' THE CONVERSION, TOLD WHAT THE SOURCE ACTUALLY WAS.
''
'' TRUE CONVERTS TO -1, NOT 1, IN EVERY NUMERIC TYPE. Measured against fbc:
''
''     bool -> byte   -1     bool -> integer   -1     bool -> single  -1
''     bool -> ubyte 255     bool -> uinteger 2^64-1  bool -> double  -1
''
'' and the STORED BYTE is 1 in both compilers, so the representation was never the
'' problem -- only the widening. Getting this wrong is invisible: 'dim as integer w =
'' someBool' gave 1, every comparison against fbc's TRUE (-1) went the wrong way, and
'' 136 of 244 assertions in fbc's own boolean-conversions test failed while 574 unit
'' tests and 16 gates stayed green.
''
'' ONE NEGATE COVERS THE WHOLE TABLE. 0 - b over the 0/1 byte gives 0 or 0xFF, and the
'' ordinary SIGNED conversion then produces -1, 255, 2^64-1 and -1.0 respectively --
'' so this needs no per-target-type cases.
''
'' MT_I8 IS LEFT ALONE, and that is a known residue rather than an oversight: a
'' boolean and a byte are the same MirType, so 'bool -> byte' cannot be told from
'' 'bool -> bool' here. fbc gives -1 for the first and leaves the second as true;
'' tiko currently leaves both. Closing it needs the DESTINATION's frontend type,
'' which most call sites do not have.
function CoerceTy _
    ( byref c as Ctx, byref v as MirValue, byval want as MirType, _
      byval srcTid as Tko.TypeId, _
      byval dstTid as Tko.TypeId = Tko.TYPE_NONE ) as MirValue

    dim as boolean srcBool = IsBooleanType( c, srcTid )
    dim as boolean dstBool = IsBooleanType( c, dstTid )
    dim as boolean haveVal = (v.kind <> cast( ubyte, MV_NONE ))

    '' NARROWING TO BOOLEAN IS NOT DONE HERE, and that is a known gap rather than an
    '' oversight. fbc NORMALISES -- every value stored into a BOOLEAN becomes 0 or 1,
    '' measured: byte -1 -> 1, integer -1 -> 1, integer 5 -> 1, where tiko truncates
    '' the low byte and stores 255, 255 and 5. It is invisible until the boolean is
    '' widened again, when '0 - 255' is 1 rather than -1.
    ''
    '' AN ATTEMPT AT IT WAS REVERTED. Emitting 'v <> 0' here fixed 39 more assertions
    '' in fbc's boolean-conversions but MISCOMPILED three MIR tests -- wide-concat-mixed
    '' printed 'false' where fbc prints 'true' -- because the rule is not uniform: a
    '' STRING reaching a boolean is not a compare-against-zero, and restricting it to
    '' numeric sources did not fix those three either. The narrowing needs its own
    '' investigation, not a guard bolted onto this one.
    '' A BOOLEAN SOURCE NEGATES. MT_I8 is included ONLY when the destination type is
    '' known and is not itself a boolean -- 'bool -> byte' is -1 in fbc, and without
    '' dstTid it cannot be told apart from 'bool -> bool', which must stay as it is.
    dim as boolean negate = srcBool andalso (dstBool = false) andalso haveVal
    if negate andalso (want = MT_I8) andalso (dstTid = Tko.TYPE_NONE) then negate = false
    if negate then
        dim as MirInst ng
        ng.op = cast( ushort, M_SUB )
        ng.ty = cast( ubyte, MT_I8 )
        ng.a = ConstInt( c, 0, MT_I8 )
        ng.b = v
        dim as MirValue nv = Emit( c, ng )
        return Coerce( c, nv, want, false )
    end if
    '' Coerce, NOT CoerceTy. The mechanical rewrite that introduced this function
    '' ran over this file too and turned its own tail call into a call to itself --
    '' infinite recursion, and the compiler segfaulted on the first boolean it saw.
    return Coerce( c, v, want, IsUnsignedType( c, srcTid ) )
end function

function Coerce _
    ( byref c as Ctx, byref v as MirValue, byval want as MirType, _
      byval srcUnsigned as boolean = false, _
      byval dstUnsigned as boolean = false ) as MirValue

    if v.kind = cast( ubyte, MV_NONE ) then return v
    dim as MirType have = cast( MirType, v.ty )
    if have = want then return v
    if (have = MT_VOID) orelse (want = MT_VOID) then return v

    '' A POINTER IS NOT AN INTEGER, even where the two are the same width. TyWidth
    '' gives MT_PTR and MT_I64 both 64, so the integer branch below saw "same width"
    '' and returned the value UNCHANGED -- 700 corpus stores of an i64 straight into a
    '' ptr slot, and the verifier was right about every one of them.
    ''
    '' 'dim p as integer ptr : p = 0' is the commonest shape by far. fbc accepts it
    '' silently, and warns only on a non-zero integer (warning 4, "Suspicious pointer
    '' assignment") -- so a conversion is the correct thing to emit here, not a refusal.
    ''
    '' Width FIRST, then the cast. A 32-bit value bitcast straight to a pointer would
    '' state a 32-bit quantity in a 64-bit slot; going through the pointer-sized
    '' integer makes the widening explicit and leaves the bitcast width-preserving.
    if (have = MT_PTR) orelse (want = MT_PTR) then
        dim as MirType intPtrTy = MT_I64
        if c.types->target.pointerBits = 32 then intPtrTy = MT_I32
        if want = MT_PTR then
            dim as MirValue w = Coerce( c, v, intPtrTy, srcUnsigned )
            if w.kind = cast( ubyte, MV_NONE ) then return w
            dim as MirInst bc
            bc.op = cast( ushort, M_BITCAST )
            bc.ty = cast( ubyte, MT_PTR )
            bc.a = w
            return Emit( c, bc )
        end if
        dim as MirInst bc
        bc.op = cast( ushort, M_BITCAST )
        bc.ty = cast( ubyte, intPtrTy )
        bc.a = v
        dim as MirValue w = Emit( c, bc )
        if w.kind = cast( ubyte, MV_NONE ) then return w
        return Coerce( c, w, want )
    end if

    dim as MirInst ins
    ins.ty = cast( ubyte, want )
    ins.a = v
    dim as boolean hf = IsFloatTy( have )
    dim as boolean wf = IsFloatTy( want )

    if hf andalso wf then
        ins.op = cast( ushort, iif( TyWidth( want ) < TyWidth( have ), M_FPTRUNC, M_FPEXT ) )
    elseif hf then
        '' ROUND FIRST. FreeBASIC converts a float to an integer by rounding to the
        '' nearest, halves to even -- measured by running fbc: 1.4 -> 1, 1.6 -> 2,
        '' 2.5 -> 2, 3.5 -> 4, -2.5 -> -2. A bare fptosi truncates toward zero and is
        '' wrong for three of those five, silently, in every conversion in the tree.
        '' fbc's own C says the same thing: 'fb_D2I( v )' is '(int32)nearbyint( v )'.
        dim as MirInst rn
        rn.op = cast( ushort, M_NEARBYINT )
        rn.ty = cast( ubyte, have )
        rn.a = v
        dim as MirValue rv = Emit( c, rn )
        if rv.kind <> cast( ubyte, MV_NONE ) then ins.a = rv
        '' AN UNSIGNED 64-BIT TARGET TAKES ITS OWN CONVERSION. fbc calls fb_D2UL for
        '' 'culngint( d )' and '(uint32)fb_D2L( d )' for 'culng( d )': only at 64
        '' bits does the unsigned range run past what the signed conversion can
        '' express, so that is the only width that changes. Without it 'culngint(
        '' 2^63 )' was a signed conversion of a value one past its maximum.
        if dstUnsigned andalso (TyWidth( want ) = 64) then
            ins.op = cast( ushort, M_FPTOUI )
        else
            ins.op = cast( ushort, M_FPTOSI )
        end if
    elseif wf then
        '' An UNSIGNED source goes through uitofp. sitofp reads the top bit as a sign,
        '' so a ULONGINT near its maximum came out as -1 instead of 1.8e19.
        ins.op = cast( ushort, iif( srcUnsigned, M_UITOFP, M_SITOFP ) )
    else
        if TyWidth( want ) < TyWidth( have ) then
            ins.op = cast( ushort, M_TRUNC )
        elseif TyWidth( want ) > TyWidth( have ) then
            '' ZERO-extend an unsigned source. Sign-extending one turns every value
            '' with its top bit set negative: a UBYTE of 200 widened to a LONG gave
            '' -56, and fbc prints 200.
            ins.op = cast( ushort, iif( srcUnsigned, M_ZEXT, M_SEXT ) )
        else
            return v
        end if
    end if
    return Emit( c, ins )
end function

'' ------------------------------------------------------------------- locals

'' A local is a slot, addressed by an alloca in the entry block. Locals are found by
'' SYMBOL, so the same name in two scopes gets two slots.



'' An anonymous slot, for a value with no name in the source. The alloca goes in the
'' entry block like any other local, so nothing downstream has to treat it specially.
function NewTempLocal _
    ( byref c as Ctx, byval ty as MirType, byval sizeBytes as long ) as long

    dim as MirLocal l
    l.name = c.names->GetString( "$tmp" & str( c.f->locals.Count ) )
    l.ty = cast( ubyte, ty )
    l.size = sizeBytes
    c.f->locals.Push( l )

    dim as long saved = c.curBlock
    c.curBlock = 0
    dim as MirInst ins
    ins.op = cast( ushort, M_ALLOCA )
    ins.ty = cast( ubyte, MT_PTR )
    ins.imm = c.f->locals.Count - 1
    Emit( c, ins )
    c.curBlock = saved
    return c.f->locals.Count - 1
end function

'' ------------------------------------------------------------- expressions

declare function LowerShortCircuit _
    ( byref c as Ctx, byval id as Tko.NodeId, byval bp as Tko.BinaryPayload ptr, _
      byval mt as MirType ) as MirValue
declare function LowerCall _
    ( byref c as Ctx, byval id as Tko.NodeId, byval mt as MirType ) as MirValue
