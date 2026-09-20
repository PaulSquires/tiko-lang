'' llvmemit.bas -- see the header.

#include once "codegen/llvmemit.bi"
#include once "codegen/llvmtype.bi"
#include once "codegen/llvmdebug.bi"
#include once "codegen/llvmrefs.bi"
#include once "codegen/irtext.bi"

namespace Tko.Codegen

using Tko.Mir

'' The emission state. 'ice' is set once and never cleared: the first failure is the
'' one worth reporting, and everything after it is downstream of a module that was
'' already known to be wrong.
type EmitCtx
    as MirModule ptr    m
    as Tko.Interner ptr names
    as TargetDescription ptr tgt
    as IrText           outp        '' appended to, never re-copied -- see irtext.bi
    as string           ice
    as MirFunction ptr  f
    '' A temp that is really a CONSTANT. M_CONST has no LLVM counterpart -- a constant
    '' in LLVM is an operand, not an instruction -- so the instruction emits nothing
    '' and its uses substitute the literal. That produces the IR a C frontend would
    '' write instead of a pile of 'add i64 0, 5'.
    as FB.Array( of string ) constText
    as FB.Array( of ubyte )  isConst
    '' A temp produced by M_ALLOCA names a SLOT. The slot has its own stable name, so
    '' both spellings of the same address print the same way and the IR does not carry
    '' two names for one alloca.
    as FB.Array( of long )   allocaSlot
    '' THE TYPE EACH TEMP WAS PRODUCED WITH. Needed only for a VARIADIC TAIL, where
    '' there is no declared parameter to take the type from and the argument pool
    '' carries a (kind, id) pair and no type at all. Defaulting the tail to i64 is
    '' right for a character code and for a REDIM bound, and wrong for fb_ThreadCall,
    '' whose tail is the user's own arguments and may hold a double -- 'i64 %t7' over
    '' a double is not a coercion, it is IR clang rejects.
    as FB.Array( of ubyte )  tempTy
    '' AND ITS SIZE, when that type is an aggregate. A temp has no slot to be sized
    '' by, so the only place the width is known is the instruction that DEFINED it --
    '' the load's address, the callee's declared return. Without this every aggregate
    '' that lived in a temp reached ValType with nothing to measure and became
    '' "an aggregate value with no size", which is the largest single class the
    '' codegen scan reports.
    as FB.Array( of long )   tempAggSize
    '' WHERE THE EMITTER IS, so an ICE names it. "an aggregate value with no size" is
    '' true and useless on its own: the corpus file it came from has three thousand
    '' instructions and the message pointed at none of them.
    as string                curFn
    as string                curOp
    '' '-g': the line tables, when asked for, and the line the next body line is on.
    as DebugInfo ptr         dbg
    as long                  dbgLine
end type

'' Forward, because EmitGlobal dispatches to it and FreeBASIC resolves a private
'' procedure only after it has been declared.
declare sub EmitVarGlobal _
    ( byref e as EmitCtx, byref g as MirGlobal, byref nm as string )
'' Forward for the same reason: a CALL carries the sret attribute too, and call
'' emission comes before the signature emission that defines it.
declare function SretAttr _
    ( byref e as EmitCtx, byval f as MirFunction ptr ) as string
declare function ByvalAttr _
    ( byref e as EmitCtx, byval f as MirFunction ptr, byval i as long ) as string

private sub Ice( byref e as EmitCtx, byref why as string )
    if len( e.ice ) > 0 then return
    e.ice = why
    if len( e.curFn ) > 0 then e.ice += " (in " & e.curFn & ", " & e.curOp & ")"
end sub

'' ---------------------------------------------------------------- names
''
'' EVERY EMITTED NAME IS QUOTED. MIR names are frontend names -- '$str0', 'a$3',
'' '_ZN1T2S1Ev' -- and LLVM's bare identifier syntax accepts only some of them. Quoting
'' is uniform, does not change the symbol the linker sees, and removes a whole class of
'' "works until a name has a dollar in it" bug.
private function GlobalName( byref e as EmitCtx, byval nm as Tko.InternId ) as string
    return "@""" & e.names->Spelling( nm ) & """"
end function

'' VALUES ARE NAMED, NOT NUMBERED. LLVM requires UNNAMED values to be numbered in
'' strict sequence from the function's first argument, so a numbered scheme has to
'' count parameters, allocas and every instruction that happens to yield a value, and
'' silently miscompiles the moment one of them stops producing one. Named values have
'' no such rule, and 'source temp 5' stays '%t5' wherever it lands.
private function TempName( byval id as ulong ) as string
    return "%t" & str( id )
end function
private function SlotName( byval id as long ) as string
    return "%s" & str( id )
end function
private function ParamName( byval id as ulong ) as string
    return "%p" & str( id )
end function
private function BlockName( byval id as long ) as string
    return "L" & str( id )
end function

'' ---------------------------------------------------------------- operands
'' HOW MANY BYTES AN AGGREGATE LOAD OR STORE MOVES.
''
'' Three sources, in order. The INSTRUCTION's own 'imm' wins where it is set, because
'' whoever built the instruction knew the size and wrote it down -- the ABI pass copies
'' aggregates whose address is a global or a computed field, and neither of those can be
'' sized by looking at a slot. Then the local's slot, then the global's own size.
''
'' Deriving it from the address alone was the bug: only MV_LOCAL was handled, so every
'' copy through a global or a field address emitted '[0 x i8]' -- a zero-byte load,
'' which clang rejects as a type mismatch against the thing it feeds.
private function AggSizeOfAddr _
    ( byref e as EmitCtx, byref v as MirValue, byval immSize as longint ) as long

    if immSize > 0 then return cast( long, immSize )
    if v.kind = cast( ubyte, MV_LOCAL ) then
        dim as long slot = cast( long, v.id )
        if e.f <> 0 then
            if (slot >= 0) andalso (slot < e.f->locals.Count) then
                return e.f->locals[slot].size
            end if
        end if
    elseif v.kind = cast( ubyte, MV_GLOBAL ) then
        if cast( long, v.id ) < e.m->globals.Count then
            return e.m->globals[cast( long, v.id )].size
        end if
    end if
    return 0
end function

private function SlotSizeOf( byref e as EmitCtx, byval slot as long ) as long
    if e.f = 0 then return 0
    if (slot < 0) orelse (slot >= e.f->locals.Count) then return 0
    return e.f->locals[slot].size
end function

'' The LLVM type of a value, which for an aggregate needs the size of the thing it
'' came from -- MIR carries that beside the slot and not in the type.
private function ValType( byref e as EmitCtx, byref v as MirValue ) as string
    dim as MirType t = cast( MirType, v.ty )
    '' A TEMP IS TYPED BY WHAT PRODUCED IT, not by what the use site recorded. MirValue
    '' carries a 'ty' filled in at each use, and where the two disagree LLVM refuses the
    '' module outright -- "'%t7' defined with type 'i32' but expected 'i64'". There is
    '' exactly one definition of a temp and it is the authority; a use that wants
    '' another width has to convert, and if MIR did not emit a conversion then the
    '' disagreement is a frontend bug that this makes visible rather than papers over.
    if v.kind = cast( ubyte, MV_TEMP ) then
        dim as long tid = cast( long, v.id )
        if (tid >= 0) andalso (tid < e.tempTy.Count) then
            dim as MirType tt = cast( MirType, e.tempTy[tid] )
            if tt <> MT_VOID then t = tt
        end if
    end if
    if t <> MT_AGG then return LlvmType( t )
    if v.kind = cast( ubyte, MV_LOCAL ) then
        return AggType( SlotSizeOf( e, cast( long, v.id ) ) )
    end if
    if v.kind = cast( ubyte, MV_GLOBAL ) then
        if cast( long, v.id ) < e.m->globals.Count then
            return AggType( e.m->globals[cast( long, v.id )].size )
        end if
    end if
    if v.kind = cast( ubyte, MV_TEMP ) then
        dim as long tid2 = cast( long, v.id )
        if (tid2 >= 0) andalso (tid2 < e.tempAggSize.Count) then
            if e.tempAggSize[tid2] > 0 then return AggType( e.tempAggSize[tid2] )
        end if
    end if
    '' An aggregate VALUE with no storage behind it to size. The ABI pass is what
    '' removes these; until it runs, saying so is better than guessing a width.
    Ice( e, "an aggregate value with no size" )
    return "void"
end function

'' AN INTEGER CONSTANT IS NOT A POINTER. MIR carries a null pointer as the number 0 --
'' at its level a pointer IS an integer -- and LLVM will not take one: 'store ptr 0' is
'' rejected with "integer constant must have integer type". A zero is 'null'; anything
'' else is a genuine address literal and needs the conversion spelled out.
private function IntAsPtr( byval n as longint ) as string
    if n = 0 then return "null"
    return "inttoptr (i64 " & str( n ) & " to ptr)"
end function

'' Does this rendered constant read as a plain integer? A folded temp carries TEXT,
'' not a kind, so this is the only way to tell one from a float or an expression.
private function IsIntegerText_( byref t as string ) as boolean
    if len( t ) = 0 then return false
    for i as long = 0 to len( t ) - 1
        dim as ubyte ch = t[i]
        if (i = 0) andalso ((ch = 45) orelse (ch = 43)) then continue for
        if (ch < 48) orelse (ch > 57) then return false
    next
    return true
end function

private function ValStr( byref e as EmitCtx, byref v as MirValue ) as string
    select case v.kind
    case MV_TEMP
        dim as long id = cast( long, v.id )
        if (id >= 0) andalso (id < e.isConst.Count) then
            if e.isConst[id] <> 0 then
                '' A FOLDED CONSTANT IN A POINTER POSITION IS STILL A POINTER.
                '' MV_CONST_INT below already knows this; a temp whose value was
                '' folded to a number carries its text and not its kind, so a
                '' null argument came out 'ptr 0' and clang refused the module:
                '' "integer constant must have integer type". Measured on
                '' 'FBQLCDNUMBER( 0 )' against a 'byval as FBQWIDGET ptr'.
                if cast( MirType, v.ty ) = MT_PTR then
                    dim as string ct = e.constText[id]
                    if IsIntegerText_( ct ) then
                        return IntAsPtr( vallng( ct ) )
                    end if
                end if
                return e.constText[id]
            end if
            if e.allocaSlot[id] >= 0 then return SlotName( e.allocaSlot[id] )
        end if
        return TempName( v.id )
    '' SIGNED. The id field is 32 bits and the -1 that marks a var-length string
    '' descriptor must read back as -1 rather than as 4294967295 -- the same trap the
    '' MIR dump documents.
    case MV_CONST_INT
        dim as longint iv = cast( longint, cast( long, v.id ) )
        if cast( MirType, v.ty ) = MT_PTR then return IntAsPtr( iv )
        return str( iv )
    case MV_LOCAL       : return SlotName( cast( long, v.id ) )
    case MV_PARAM       : return ParamName( v.id )
    case MV_GLOBAL
        if cast( long, v.id ) < e.m->globals.Count then
            return GlobalName( e, e.m->globals[cast( long, v.id )].name )
        end if
        Ice( e, "a global operand out of range" )
        return "undef"
    case MV_UNDEF       : return "undef"
    case MV_BLOCKADDR
        '' 'blockaddress(@fn, %label)'. It names the function it is IN, which is why
        '' this needs the emitter's current function rather than the value alone -- a
        '' block address is meaningless outside the function that owns the block, and
        '' LLVM spells that ownership in the operand.
        if e.f = 0 then Ice( e, "a block address outside a function" )
        return "blockaddress(" & GlobalName( e, e.f->name ) & ", %" & _
               BlockName( cast( long, v.id ) ) & ")"
    end select
    Ice( e, "an operand with no kind" )
    return "undef"
end function

'' A typed operand, which is how LLVM spells nearly every one of them.
private function Operand( byref e as EmitCtx, byref v as MirValue ) as string
    return ValType( e, v ) & " " & ValStr( e, v )
end function

'' ---------------------------------------------------------------- alignment
''
'' STATED AT EVERY MEMORY OPERATION, because the byte-array aggregate type carries an
'' alignment of 1 and a scalar's type carries the natural one only by convention. An
'' over-statement is safe and an under-statement is a fault on some paths, so an
'' aggregate takes the target's maximum rather than a computed field alignment: the
'' frontend's layout already placed the fields, and this is only about the block.
private function AlignOf _
    ( byref e as EmitCtx, byval t as MirType, byval sizeBytes as long ) as long

    select case t
    case MT_I8  : return 1
    case MT_I16 : return 2
    case MT_I32, MT_F32 : return 4
    case MT_I64, MT_F64 : return 8
    case MT_PTR : return e.tgt->layout.pointerBits \ 8
    end select
    dim as long a = e.tgt->layout.maxAlign
    if sizeBytes < a then
        '' A block smaller than the maximum alignment cannot need more than its own
        '' size, and asking for more of a field inside a larger object is wrong.
        a = 1
        while (a * 2) <= sizeBytes
            a *= 2
        wend
    end if
    if a < 1 then a = 1
    return a
end function


'' ---------------------------------------------------------------- instructions
''
'' One MIR instruction in, one or two LLVM lines out. The second line appears only
'' where LLVM's shape genuinely differs from MIR's -- a comparison yields i1 and MIR's
'' yields an integer -- and never to work around something this file could have got
'' right the first time.

private sub Line( byref e as EmitCtx, byref t as string )
    '' EVERY body line carries a location under '-g', because the verifier refuses a
    '' call without one in a function that has a subprogram.
    if e.dbg <> 0 then
        e.outp += "  " & t & DbgLocSuffix( *e.dbg, e.dbgLine ) & chr( 10 )
        return
    end if
    e.outp += "  " & t & chr( 10 )
end sub

'' CmpPred, MathIntrinsic and LibmName -- opcode spellings -- live in llvmtype.bas.

'' The argument list of a call, read out of the module's argument pool. The pool holds
'' (kind, id) pairs and NO types, so each argument's type comes from the CALLEE's
'' signature -- which is exactly why the signature had to exist before this file could.
private function CallArgs _
    ( byref e as EmitCtx, byref ins as MirInst, byval callee as MirFunction ptr ) as string

    dim as string r
    for i as long = 0 to ins.count - 1
        dim as long k = (ins.first + i) * 2
        if (k + 1) >= e.m->argPool.Count then
            Ice( e, "a call argument past the end of the pool" )
            return r
        end if
        dim as MirValue v
        v.kind = cast( ubyte, e.m->argPool[k] )
        v.id = e.m->argPool[k + 1]
        dim as string attr
        '' MT_I64 IS ONLY A FALLBACK, and reaching it used to be a silent mistype.
        '' An INDIRECT call has no callee, so every argument took this default and was
        '' emitted as 'i64' whatever it really was -- LLVM then refused the module on
        '' the first pointer passed through a function pointer: "'%t58' defined with
        '' type 'ptr' but expected 'i64'". A virtual method call is exactly that
        '' shape, since the object pointer is argument zero.
        ''
        '' So an argument with no declared parameter type is typed BY ITS PRODUCER,
        '' which is the same authority ValType uses for a temp and the same rule the
        '' variadic tail below already followed. The two cases are one rule and are
        '' now written once.
        dim as MirType pt = MT_I64
        if (callee = 0) andalso (v.kind = cast( ubyte, MV_TEMP )) then
            dim as long tid0 = cast( long, v.id )
            if (tid0 >= 0) andalso (tid0 < e.tempTy.Count) then
                dim as MirType tt0 = cast( MirType, e.tempTy[tid0] )
                if tt0 <> MT_VOID then pt = tt0
            end if
        end if
        if callee <> 0 then
            '' ...and so does the CALL, because LLVM matches the two and lowers from
            '' what the call says.
            if i = 0 then attr = SretAttr( e, callee )
            attr += ByvalAttr( e, callee, i )
            if i < callee->paramTys.Count then
                pt = cast( MirType, callee->paramTys[i] )
            elseif v.kind = cast( ubyte, MV_TEMP ) then
                '' PAST THE DECLARED PARAMETERS: a variadic tail. The value's own
                '' producer is the only thing that knows its type.
                dim as long tid = cast( long, v.id )
                if (tid >= 0) andalso (tid < e.tempTy.Count) then
                    dim as MirType tt = cast( MirType, e.tempTy[tid] )
                    if tt <> MT_VOID then pt = tt
                end if
            end if
        end if
        '' A SLOT OR A GLOBAL IS ITS ADDRESS, whatever it holds -- the pool records
        '' where the argument lives, and for those two that is a pointer.
        if (v.kind = cast( ubyte, MV_LOCAL )) orelse _
           (v.kind = cast( ubyte, MV_GLOBAL )) then
            pt = MT_PTR
        end if
        '' AN AGGREGATE ARGUMENT NEEDS ITS SIZE. Without one it rendered '[0 x i8]',
        '' and LLVM matches a call's argument type against the value's own
        '' definition: passing a 16-byte temp through a virtual method emitted
        '' 'call void %t58(..., [0 x i8] %t55)' against a %t55 defined as
        '' '[16 x i8]'. The callee records the size where there is a callee; an
        '' INDIRECT call has none, so the value's producer is the authority -- the
        '' same rule the type above already follows.
        dim as long asz = 0
        if pt = MT_AGG then
            if callee <> 0 then
                if i < callee->paramAggs.Count then
                    asz = cast( long, callee->paramAggs[i] )
                end if
            end if
            if (asz <= 0) andalso (v.kind = cast( ubyte, MV_TEMP )) then
                dim as long tsz = cast( long, v.id )
                if (tsz >= 0) andalso (tsz < e.tempAggSize.Count) then
                    asz = e.tempAggSize[tsz]
                end if
            end if
        end if
        v.ty = cast( ubyte, pt )
        if len( r ) > 0 then r += ", "
        r += LlvmType( pt, asz ) & attr & " " & ValStr( e, v )
    next
    return r
end function

private sub EmitInst( byref e as EmitCtx, byref ins as MirInst )
    dim as MirOp op = cast( MirOp, ins.op )
    e.curOp = OpName( op ) & " %" & str( ins.result )
    if ins.dbgLine > 0 then e.dbgLine = ins.dbgLine
    dim as MirType rt = cast( MirType, ins.ty )
    dim as string res = TempName( ins.result )
    dim as string ty = LlvmType( rt )
    dim as boolean isFlt = (rt = MT_F32) orelse (rt = MT_F64)

    '' Recorded before the dispatch, so it holds for every opcode that yields a value --
    '' including the ones that emit nothing and substitute a literal.
    if OpHasResult( op ) then
        dim as long rid = cast( long, ins.result )
        if (rid >= 0) andalso (rid < e.tempTy.Count) then
            e.tempTy[rid] = cast( ubyte, rt )
            '' See tempAggSize: recorded HERE, beside the type, because this is the
            '' one point that sees the defining instruction.
            if rt = MT_AGG then
                dim as long asz = 0
                select case op
                case M_LOAD
                    asz = AggSizeOfAddr( e, ins.a, ins.imm )
                '' AN INDIRECT CALL CARRIES ITS OWN. There is no callee to ask, so
                '' lowering writes the aggregate return's size into 'imm'.
                case M_CALL_IND
                    asz = ins.imm
                case M_CALL, M_CALL_RTL
                    dim as long ci2 = cast( long, ins.callee )
                    if (ci2 >= 0) andalso (ci2 < e.m->functions.Count) then
                        dim as MirFunction ptr cf2 = e.m->functions[ci2]
                        if cf2 <> 0 then asz = cf2->retSize
                    end if
                end select
                if rid < e.tempAggSize.Count then e.tempAggSize[rid] = asz
            end if
        end if
    end if

    select case op

    '' A CONSTANT IS AN OPERAND, not an instruction: LLVM has no place to put one on
    '' its own. Nothing is emitted and the uses substitute the literal, which produces
    '' the IR a C frontend would write instead of a pile of 'add i64 0, 5'.
    case M_CONST
        dim as long id = cast( long, ins.result )
        if (id >= 0) andalso (id < e.isConst.Count) then
            e.isConst[id] = 1
            if isFlt then
                e.constText[id] = LlvmFloatConst( ins.fimm, (rt = MT_F32) )
            elseif rt = MT_PTR then
                '' ...and the same for a constant that is CARRIED as a temp rather than
                '' written inline. A pointer-typed M_CONST is how a null literal
                '' reaches here.
                e.constText[id] = IntAsPtr( ins.imm )
            else
                e.constText[id] = str( ins.imm )
            end if
        end if

    case M_ALLOCA
        '' Emitted under the SLOT's name; the instruction's own temp is recorded as
        '' another spelling of that address rather than given a second name.
        dim as long slot = cast( long, ins.imm )
        dim as long rid = cast( long, ins.result )
        if (rid >= 0) andalso (rid < e.allocaSlot.Count) then
            e.allocaSlot[rid] = slot
        end if
        if (slot < 0) orelse (e.f = 0) then
            Ice( e, "an alloca with no slot" )
            return
        end if
        if slot >= e.f->locals.Count then
            Ice( e, "an alloca of a slot that does not exist" )
            return
        end if
        dim as MirType st = cast( MirType, e.f->locals[slot].ty )
        dim as long sz = e.f->locals[slot].size
        '' A VOID SLOT has no storage and no type. It is what a declined declaration
        '' leaves behind; 'alloca void' is not legal IR and would be a worse answer
        '' than saying so.
        if st = MT_VOID then
            Ice( e, "an alloca of a void slot" )
            return
        end if
        Line( e, SlotName( slot ) & " = alloca " & LlvmType( st, sz ) & _
                 ", align " & str( AlignOf( e, st, sz ) ) )

    case M_LOAD
        if rt = MT_VOID then
            Ice( e, "a load of a void" )
            return
        end if
        dim as long sz = AggSizeOfAddr( e, ins.a, ins.imm )
        Line( e, res & " = load " & LlvmType( rt, sz ) & ", ptr " & ValStr( e, ins.a ) & _
                 ", align " & str( AlignOf( e, rt, sz ) ) )

    case M_STORE
        dim as MirType vt = cast( MirType, ins.b.ty )
        dim as long sz = AggSizeOfAddr( e, ins.a, ins.imm )
        '' THE STORED TYPE IS THE VALUE'S, not the destination's. Where the address is
        '' a TEMP there is no slot to size it by, and LLVM compares the two: a store of
        '' an 8-byte temp through an unsized address emitted 'store [0 x i8] %t6' and
        '' was rejected against the temp's own definition. The value knows its width;
        '' the address does not have to.
        '' ...AND IT WINS OVER THE DESTINATION'S, not only where there is none. A
        '' store into the BASE SUBOBJECT of a derived variable -- 'cast( udt1, u21 )
        '' = u11', which is how the corpus writes it -- has a 16-byte value and a
        '' 48-byte slot, and taking the slot's size emitted 'store [48 x i8] %t41'
        '' against a %t41 defined as '[16 x i8]'. LLVM compares the two and refuses
        '' the module. The destination is a POINTER and the write is the value's
        '' width; a partial store is exactly what an upcast assignment is.
        if (vt = MT_AGG) andalso (ins.b.kind = cast( ubyte, MV_TEMP )) then
            dim as long bt = cast( long, ins.b.id )
            if (bt >= 0) andalso (bt < e.tempAggSize.Count) then
                if e.tempAggSize[bt] > 0 then sz = e.tempAggSize[bt]
            end if
        end if
        Line( e, "store " & LlvmType( vt, sz ) & " " & ValStr( e, ins.b ) & _
                 ", ptr " & ValStr( e, ins.a ) & _
                 ", align " & str( AlignOf( e, vt, sz ) ) )

    '' BOTH ADDRESS OPCODES ARE A BYTE GEP. MIR's offsets are already in BYTES -- which
    '' is the whole reason M_PTR_ADD is not M_ADD -- so the element type is i8 and LLVM
    '' does no scaling of its own. A typed gep here would scale the offset a second
    '' time by the element size.
    case M_FIELD_ADDR
        Line( e, res & " = getelementptr i8, ptr " & ValStr( e, ins.a ) & _
                 ", i64 " & str( ins.imm ) )
    case M_PTR_ADD
        Line( e, res & " = getelementptr i8, ptr " & ValStr( e, ins.a ) & _
                 ", " & Operand( e, ins.b ) )

    case M_ADD, M_SUB, M_MUL
        dim as string o = "add"
        if op = M_SUB then o = "sub"
        if op = M_MUL then o = "mul"
        if isFlt then o = "f" & o
        Line( e, res & " = " & o & " " & ty & " " & ValStr( e, ins.a ) & _
                 ", " & ValStr( e, ins.b ) )

    case M_SDIV, M_UDIV, M_FDIV, M_SREM, M_UREM
        dim as string o = "sdiv"
        select case op
        case M_UDIV : o = "udiv"
        case M_FDIV : o = "fdiv"
        case M_SREM : o = "srem"
        case M_UREM : o = "urem"
        end select
        Line( e, res & " = " & o & " " & ty & " " & ValStr( e, ins.a ) & _
                 ", " & ValStr( e, ins.b ) )

    case M_AND, M_OR, M_XOR, M_SHL, M_LSHR, M_ASHR
        dim as string o = "and"
        select case op
        case M_OR   : o = "or"
        case M_XOR  : o = "xor"
        case M_SHL  : o = "shl"
        case M_LSHR : o = "lshr"
        case M_ASHR : o = "ashr"
        end select
        Line( e, res & " = " & o & " " & ty & " " & ValStr( e, ins.a ) & _
                 ", " & ValStr( e, ins.b ) )

    '' NEGATION IS A SUBTRACTION FROM ZERO on an integer and its own instruction on a
    '' float, where 'fsub 0.0, x' is NOT the same thing: it gets -0.0 wrong.
    case M_NEG
        if isFlt then
            Line( e, res & " = fneg " & ty & " " & ValStr( e, ins.a ) )
        else
            Line( e, res & " = sub " & ty & " 0, " & ValStr( e, ins.a ) )
        end if

    '' LLVM HAS NO 'not'. It is an exclusive-or with all ones.
    case M_NOT
        Line( e, res & " = xor " & ty & " " & ValStr( e, ins.a ) & ", -1" )

    case M_ICMP_EQ, M_ICMP_NE, M_ICMP_SLT, M_ICMP_SGT, M_ICMP_SLE, M_ICMP_SGE, _
         M_ICMP_ULT, M_ICMP_UGT, M_ICMP_ULE, M_ICMP_UGE, _
         M_FCMP_EQ, M_FCMP_NE, M_FCMP_LT, M_FCMP_GT, _
         M_FCMP_LE, M_FCMP_GE
        dim as boolean cmpFloat = false
        dim as string pred = CmpPred( op, cmpFloat )
        if len( pred ) = 0 then
            Ice( e, "a comparison with no predicate" )
            return
        end if
        dim as string i1 = res & ".c"
        dim as string opc = "icmp "
        if cmpFloat then opc = "fcmp "
        Line( e, i1 & " = " & opc & pred & " " & Operand( e, ins.a ) & _
                 ", " & ValStr( e, ins.b ) )
        '' WIDENED, because MIR's comparison yields an integer and every use expects
        '' that width. ZERO extension: a MIR comparison is 0 or 1, and FreeBASIC's own
        '' -1 for true is produced above this by lowering, not here.
        Line( e, res & " = zext i1 " & i1 & " to " & ty )

    case M_TRUNC, M_SEXT, M_ZEXT, M_FPTRUNC, M_FPEXT, M_FPTOSI, M_FPTOUI, _
         M_SITOFP, M_UITOFP, M_BITCAST
        dim as string o = "trunc"
        select case op
        case M_SEXT    : o = "sext"
        case M_ZEXT    : o = "zext"
        case M_FPTRUNC : o = "fptrunc"
        case M_FPEXT   : o = "fpext"
        case M_FPTOSI  : o = "fptosi"
        case M_FPTOUI  : o = "fptoui"
        case M_SITOFP  : o = "sitofp"
        case M_UITOFP  : o = "uitofp"
        case M_BITCAST : o = "bitcast"
        end select
        '' A POINTER IS NOT BITCASTABLE TO AN INTEGER. LLVM has three distinct
        '' instructions here and 'bitcast' is only the one for two values of the same
        '' KIND and the same width -- 'bitcast ptr %x to i64' is rejected outright with
        '' "invalid cast opcode for cast". MIR has one opcode for all three because at
        '' its level they are the same operation: reinterpret these bits.
        ''
        '' This was the single largest reason emitted IR failed to compile.
        if op = M_BITCAST then
            dim as MirType st = cast( MirType, ins.a.ty )
            if (st = MT_PTR) andalso (rt <> MT_PTR) then
                o = "ptrtoint"
            elseif (st <> MT_PTR) andalso (rt = MT_PTR) then
                o = "inttoptr"
            end if
        end if
        '' A CONVERSION BETWEEN TWO IDENTICAL TYPES IS NOT LEGAL LLVM -- 'trunc i64 to
        '' i64' is rejected outright -- and MIR produces them wherever a coercion was a
        '' no-op on this target, which is common: INTEGER and LONGINT are one type
        '' here. The value passes through instead of being converted.
        dim as string src = ValType( e, ins.a )
        if src = ty then
            dim as long rid = cast( long, ins.result )
            if (rid >= 0) andalso (rid < e.isConst.Count) then
                e.isConst[rid] = 1
                e.constText[rid] = ValStr( e, ins.a )
            end if
            return
        end if
        Line( e, res & " = " & o & " " & src & " " & ValStr( e, ins.a ) & " to " & ty )

    case M_IABS
        '' llvm.abs takes a second, CONSTANT argument saying whether the minimum signed
        '' value is poison. It is not: FreeBASIC's abs of the minimum is itself, which
        '' is what 'false' here means.
        Line( e, res & " = call " & ty & " @llvm.abs." & ty & "(" & _
                 Operand( e, ins.a ) & ", i1 false)" )

    case M_FLOOR, M_SQRT, M_SIN, M_COS, M_LOG, M_EXP, M_FABS, M_NEARBYINT
        Line( e, res & " = call " & ty & " @" & MathIntrinsic( op ) & "." & ty & _
                 "(" & Operand( e, ins.a ) & ")" )

    case M_TAN, M_ASIN, M_ACOS, M_ATAN
        dim as string nm = LibmName( op )
        if rt = MT_F32 then nm += "f"
        Line( e, res & " = call " & ty & " @""" & nm & """(" & Operand( e, ins.a ) & ")" )

    '' THE ADDRESS OF A FUNCTION IS A CONSTANT, so like M_CONST it emits nothing and
    '' its uses substitute the name.
    case M_FUNC_ADDR
        dim as long ci = cast( long, ins.callee )
        if (ci < 0) orelse (ci >= e.m->functions.Count) then
            Ice( e, "the address of a function that does not exist" )
            return
        end if
        dim as long rid = cast( long, ins.result )
        if (rid >= 0) andalso (rid < e.isConst.Count) then
            e.isConst[rid] = 1
            e.constText[rid] = GlobalName( e, e.m->functions[ci]->name )
        end if

    case M_CALL, M_CALL_RTL, M_CALL_IND
        dim as MirFunction ptr cf = 0
        dim as string target_
        if op = M_CALL_IND then
            target_ = ValStr( e, ins.a )
            '' ...AND ITS SIGNATURE, where lowering knew one. The call still goes
            '' THROUGH THE POINTER; the declaration is only there to type the
            '' arguments, which LLVM matches against each value's own definition.
            '' Recorded PLUS ONE, because zero is function 0.
            dim as long si2 = cast( long, ins.callee ) - 1
            if (si2 >= 0) andalso (si2 < e.m->functions.Count) then
                cf = e.m->functions[si2]
            end if
        else
            dim as long ci = cast( long, ins.callee )
            if (ci < 0) orelse (ci >= e.m->functions.Count) then
                Ice( e, "a call to a function that does not exist" )
                return
            end if
            cf = e.m->functions[ci]
            target_ = GlobalName( e, cf->name )
        end if
        '' AN AGGREGATE RETURN NEEDS ITS SIZE TOO, and an INDIRECT call has no callee
        '' to ask. 'call [0 x i8] %t79(ptr %t76)' through a vtable slot was refused
        '' against the 8-byte slot its result was stored into. The RESULT TEMP's
        '' recorded size is the same authority the argument rule above uses.
        if rt = MT_AGG then
            dim as long rsz2 = 0
            if cf <> 0 then rsz2 = cast( long, cf->retSize )
            if rsz2 <= 0 then
                dim as long rti = cast( long, ins.result )
                if (rti >= 0) andalso (rti < e.tempAggSize.Count) then
                    rsz2 = e.tempAggSize[rti]
                end if
            end if
            if rsz2 > 0 then ty = LlvmType( rt, rsz2 )
        end if
        dim as string args = CallArgs( e, ins, cf )
        '' A VARIADIC CALLEE NEEDS ITS FULL SIGNATURE AT THE CALL SITE, not just the
        '' return type: LLVM has to be told where the fixed parameters stop, and on
        '' win64 that is what decides whether a float argument is duplicated into a
        '' general-purpose register as well as an XMM one.
        dim as string sig = ty
        if (cf <> 0) andalso (op <> M_CALL_IND) then
            if cf->isVariadic then
                sig = ty & " ("
                for i as long = 0 to cf->paramTys.Count - 1
                    if i > 0 then sig += ", "
                    sig += LlvmType( cast( MirType, cf->paramTys[i] ) )
                next
                if cf->paramTys.Count > 0 then sig += ", "
                sig += "...)"
            end if
        end if
        '' A PAIR RETURN: the ABI pass left the destination slot in 'b', and both
        '' registers are written through it -- the first at 0, the second at 8.
        if (cf <> 0) andalso (op <> M_CALL_IND) andalso (ins.b.kind = cast( ubyte, MV_LOCAL )) then
            if cast( MirType, cf->retTy2 ) <> MT_VOID then
                dim as MirType p0 = cast( MirType, cf->retTy )
                dim as MirType p1 = cast( MirType, cf->retTy2 )
                dim as string pty = LlvmPairType( p0, p1 )
                dim as string dst = ValStr( e, ins.b )
                Line( e, res & ".pair = call " & pty & " " & target_ & "(" & args & ")" )
                Line( e, res & " = extractvalue " & pty & " " & res & ".pair, 0" )
                Line( e, res & ".1 = extractvalue " & pty & " " & res & ".pair, 1" )
                Line( e, "store " & LlvmType( p0 ) & " " & res & ", ptr " & dst & _
                         ", align " & str( AlignOf( e, p0, 0 ) ) )
                Line( e, res & ".p1 = getelementptr i8, ptr " & dst & ", i64 8" )
                Line( e, "store " & LlvmType( p1 ) & " " & res & ".1, ptr " & res & _
                         ".p1, align " & str( AlignOf( e, p1, 0 ) ) )
                return
            end if
        end if
        if rt = MT_VOID then
            Line( e, "call " & sig & " " & target_ & "(" & args & ")" )
        else
            Line( e, res & " = call " & sig & " " & target_ & "(" & args & ")" )
        end if

    '' llvm.va_start takes ONLY the list pointer. MIR carries the last named parameter
    '' as a second operand because fbc emits it; LLVM has nowhere to put it, so it is
    '' dropped HERE rather than in lowering, where it is the only record of which
    '' signature the cursor walks.
    case M_VA_START
        Line( e, "call void @llvm.va_start.p0(ptr " & ValStr( e, ins.a ) & ")" )
    case M_VA_END
        Line( e, "call void @llvm.va_end.p0(ptr " & ValStr( e, ins.a ) & ")" )
    case M_VA_COPY
        Line( e, "call void @llvm.va_copy.p0(ptr " & ValStr( e, ins.a ) & _
                 ", ptr " & ValStr( e, ins.b ) & ")" )
    case M_VA_ARG
        Line( e, res & " = va_arg ptr " & ValStr( e, ins.a ) & ", " & ty )

    case else
        Ice( e, "no emission for opcode '" & OpName( op ) & "'" )
    end select
end sub

'' ---------------------------------------------------------------- blocks
''
'' MIR has no implicit fallthrough and every block carries exactly one terminator, so
'' this is a transcription rather than a control-flow reconstruction.
private sub EmitBlock _
    ( byref e as EmitCtx, byref b as MirBlock, byval bi as long )

    e.outp += BlockName( bi ) & ":" & chr( 10 )
    for i as long = 0 to b.insts.Count - 1
        EmitInst( e, b.insts[i] )
    next

    select case cast( MirTermKind, b.term )
    case MTERM_RET
        if b.cond.kind = cast( ubyte, MV_NONE ) then
            Line( e, "ret void" )
        elseif (e.f <> 0) andalso (b.ret2.kind <> cast( ubyte, MV_NONE )) then
            '' TWO REGISTERS, packed into the literal struct the signature declares.
            dim as string pty = LlvmPairType( cast( MirType, e.f->retTy ), _
                                              cast( MirType, e.f->retTy2 ) )
            dim as string rv = "%rv" & str( bi )
            Line( e, rv & ".a = insertvalue " & pty & " undef, " & Operand( e, b.cond ) & ", 0" )
            Line( e, rv & ".b = insertvalue " & pty & " " & rv & ".a, " & Operand( e, b.ret2 ) & ", 1" )
            Line( e, "ret " & pty & " " & rv & ".b" )
        else
            Line( e, "ret " & Operand( e, b.cond ) )
        end if
    case MTERM_BR
        Line( e, "br label %" & BlockName( b.target ) )
    case MTERM_CONDBR
        '' NARROWED TO i1. MIR's condition is an integer of whatever width the
        '' comparison produced, and LLVM's branch takes an i1 and nothing else. The
        '' test is against ZERO rather than against one, because FreeBASIC's true is
        '' -1 and any non-zero value is true.
        ''
        '' AND THE COMPARISON DEPENDS ON THE CONDITION'S TYPE. This was one
        '' hard-coded `icmp ne ..., 0` -- the only hard-coded zero in this file --
        '' and it was wrong for two of the three cases it has to serve. Every other
        '' constant reaches LLVM through ValStr, which has spelled both correctly all
        '' along; only this line bypassed it.
        ''
        ''   POINTER   `icmp ne ptr %p, null`. An integer literal against a pointer
        ''             operand is rejected outright -- "integer constant must have
        ''             integer type" -- so `if p then` and `while p` emitted IR that
        ''             would not assemble. Found 2026-09-04 compiling fbcunit, the
        ''             first thing this compiler was asked to build that tests a
        ''             pointer for truth.
        ''   FLOAT     `fcmp une <ty> %f, 0.0`. Wrong twice over before: `icmp` does
        ''             not accept a float operand at all, and the literal needed a
        ''             point. `if d then` on a DOUBLE is ordinary FreeBASIC and could
        ''             never have compiled.
        ''   INTEGER   `icmp ne <ty> %i, 0`, which is what it always did.
        ''
        '' UNE, NOT ONE, AND THAT IS MEASURED. `une` is unordered-or-not-equal and is
        '' TRUE for a NaN; `one` is ordered and is false. fbc was asked, with a NaN
        '' built from its bit pattern:
        ''
        ''     NaN is TRUE   0.0 is FALSE   1.5 is TRUE
        ''
        '' so `une` is the one that agrees. Choosing `one` would have made
        '' `if nan then` silently take the other branch.
        dim as string c1 = "%b" & str( bi ) & ".c"
        dim as string ct = ValType( e, b.cond )
        dim as string cmpOp = "icmp ne ", zero = "0"
        select case ct
        case "ptr"
            zero = "null"
        case "double", "float"
            cmpOp = "fcmp une " : zero = "0.0"
        end select
        Line( e, c1 & " = " & cmpOp & ct & " " & ValStr( e, b.cond ) & ", " & zero )
        Line( e, "br i1 " & c1 & ", label %" & BlockName( b.target ) & _
                 ", label %" & BlockName( b.target2 ) )
    case MTERM_UNREACHABLE
        Line( e, "unreachable" )
    case MTERM_INDIRECTBR
        '' 'goto *p'. EVERY REACHABLE BLOCK MUST BE LISTED: LLVM verifies the set and
        '' an omitted destination is a module it refuses, while an empty list would let
        '' the optimiser delete the handler as unreachable and leave the jump pointing
        '' at nothing.
        dim as string dsts = ""
        for ti as long = 0 to b.indirectTargets.Count - 1
            if len( dsts ) > 0 then dsts += ", "
            dsts += "label %" & BlockName( cast( long, b.indirectTargets[ti] ) )
        next
        Line( e, "indirectbr ptr " & ValStr( e, b.cond ) & ", [ " & dsts & " ]" )
    case else
        Ice( e, "a block with no terminator" )
    end select
    e.outp += chr( 10 )
end sub

'' ---------------------------------------------------------------- functions
'' THE HIDDEN RESULT POINTER IS MARKED 'sret', which is not decoration. On win64 the
'' callee must also return that pointer in RAX, and LLVM only knows to do that when the
'' attribute is there -- measured against what clang emits for the same shape:
''
''     declare dso_local void @r12(ptr dead_on_unwind writable sret(%struct.S12) align 4)
''
'' The type inside sret(...) is the object's, which here is its byte array. clang also
'' writes 'dead_on_unwind' and 'writable'; both are optimisation permissions that depend
'' on unwinding semantics tiko-lang does not have, so they are left off rather than
'' copied for resemblance.
function SretAttr( byref e as EmitCtx, byval f as MirFunction ptr ) as string
    if f->hasSretParam = false then return ""
    if f->retSize <= 0 then return ""
    return " sret(" & AggType( f->retSize ) & ") align " & _
           str( AlignOf( e, MT_AGG, f->retSize ) )
end function

'' BYVAL, for a SysV MEMORY-class aggregate.
''
'' Not a spelling of "pass a pointer": it says the argument travels ON THE STACK by
'' value, which is what the SysV MEMORY class means. A plain pointer parameter would
'' put an address in a register instead -- a different ABI, and one that links happily
'' against a C callee and then reads the wrong bytes.
''
'' Like sret it must appear identically on the signature and at the call site, which is
'' why both go through here.
function ByvalAttr _
    ( byref e as EmitCtx, byval f as MirFunction ptr, byval i as long ) as string

    if f = 0 then return ""
    if i >= f->paramAttrs.Count then return ""
    if f->paramAttrs[i] <> TKO_PA_BYVAL then return ""
    dim as long sz = 0
    if i < f->paramAggs.Count then sz = cast( long, f->paramAggs[i] )
    if sz <= 0 then return ""
    return " byval(" & AggType( sz ) & ") align " & str( AlignOf( e, MT_AGG, sz ) )
end function

private function ParamList _
    ( byref e as EmitCtx, byval f as MirFunction ptr, byval named as boolean ) as string

    dim as string r
    for i as long = 0 to f->paramTys.Count - 1
        if i > 0 then r += ", "
        r += LlvmType( cast( MirType, f->paramTys[i] ) )
        if i = 0 then r += SretAttr( e, f )
        r += ByvalAttr( e, f, i )
        if named then r += " " & ParamName( cast( ulong, i ) )
    next
    if f->isVariadic then
        if f->paramTys.Count > 0 then r += ", "
        r += "..."
    end if
    return r
end function

private sub EmitFunction( byref e as EmitCtx, byval f as MirFunction ptr )
    e.f = f
    e.curFn = e.names->Spelling( f->name )
    dim as string ret = LlvmType( cast( MirType, f->retTy ) )
    '' AN AGGREGATE RETURN HAS NO SIZE HERE. Returning one by value is what the ABI
    '' pass removes -- it becomes a hidden pointer -- so reaching this with one means
    '' the pass has not run, and inventing a width would emit a function whose callers
    '' disagree with it.
    if cast( MirType, f->retTy ) = MT_AGG then
        Ice( e, "a function returning an aggregate by value; the ABI pass has not run" )
        return
    end if
    '' AND NEITHER DOES AN AGGREGATE PARAMETER. Its size lives in the frontend's layout
    '' store, which this file does not have, and the ABI pass is what removes these --
    '' every one becomes a pointer or a coerced integer. Emitting '[0 x i8]' instead
    '' produced a signature whose own body disagreed with it.
    for i as long = 0 to f->paramTys.Count - 1
        if cast( MirType, f->paramTys[i] ) = MT_AGG then
            Ice( e, "an aggregate parameter passed by value; the ABI pass has not run" )
            return
        end if
    next
    '' A SysV RETURN IN TWO REGISTERS -- see RetDirect_ in abi.bas.
    if cast( MirType, f->retTy2 ) <> MT_VOID then
        ret = LlvmPairType( cast( MirType, f->retTy ), cast( MirType, f->retTy2 ) )
    end if

    if f->isDefinition = false then
        e.outp += "declare " & ret & " " & GlobalName( e, f->name ) & _
                  "(" & ParamList( e, f, false ) & ")" & chr( 10 )
        return
    end if

    '' 'nounwind' ON EVERYTHING: FreeBASIC does not unwind, and saying so lets LLVM
    '' drop the landing-pad machinery it would otherwise have to assume.
    ''
    '' AND 'uwtable(sync)' ON EVERY DEFINITION, which is not the same thing. nounwind
    '' says no exception passes through; uwtable says a DEBUGGER or the OS can still
    '' walk the stack through this frame. Without it LLVM wrote no .pdata/.xdata for a
    '' tiko procedure on win64, and gdb stopped in one with frame #1 at 0x0 -- 'finish'
    '' could not find the return address and a backtrace ended where it began
    '' (Phase 14). fbc asks for the same thing: its gcc line carries '-funwind-tables'
    '' ('fbc -v'), whose LLVM spelling is uwtable(sync). Every -g build needs it and
    '' so does every crash dump, so it is not tied to -g.
    dim as string linkage = ""
    if f->isPrivate then linkage = "internal "
    '' dllexport, which is what actually puts a name in a DLL's export table.
    '' fbc emits it for a procedure written EXPORT and so does this now; before,
    '' the keyword reached here as nothing at all.
    ''
    '' AFTER the internal test and not beside it: 'internal dllexport' is not a
    '' combination LLVM accepts, and a private procedure has no external name to
    '' export. If both were somehow set, internal wins and the export is dropped
    '' rather than producing a module clang rejects.
    if f->isExported andalso (f->isPrivate = false) then linkage = "dllexport "
    '' AN INSTANTIATED GENERIC GOES OUT WEAK AND FOLDABLE. Every translation unit
    '' that names 'Array( of long )' instantiates it, so the same definition is
    '' emitted by each of them; with external linkage the linker sees duplicates and
    '' refuses -- twenty of them on the first attempt to compile tiko-lang with
    '' tiko-lang, every one an Array( of T ) member.
    ''
    '' 'linkonce_odr' is the linkage and COMDAT is what COFF needs to act on it: the
    '' key is declared beside the definition and every copy after the first is
    '' dropped. A PRIVATE instantiation is already module-local and needs neither.
    dim as string cmdt = ""
    if f->isWeak andalso (f->isPrivate = false) then
        linkage = "linkonce_odr "
        dim as string gn = GlobalName( e, f->name )
        dim as string key = "$" & mid( gn, 2 )
        e.outp += key & " = comdat any" & chr( 10 )
        '' AFTER the function attributes, which is where LLVM's grammar puts it:
        '' 'define ... ( args ) nounwind comdat {'. Written before them it is
        '' "expected '{' in function body", 71 modules deep.
        cmdt = " comdat"
    end if
    '' The subprogram goes after the attributes and the comdat, LLVM's order.
    dim as string dbgAttr = ""
    if e.dbg <> 0 then
        dbgAttr = " !dbg !" & str( DbgSubprogram( *e.dbg, e.names->Spelling( f->name ), _
                                                  f->dbgFile, f->dbgLine ) )
        e.dbgLine = f->dbgLine
    end if
    e.outp += "define " & linkage & ret & " " & GlobalName( e, f->name ) & _
              "(" & ParamList( e, f, true ) & ") nounwind uwtable(sync)" & cmdt & dbgAttr & " {" & chr( 10 )

    '' Per-function value bookkeeping. Sized to nextTemp because that is the highest
    '' temp the function can name.
    e.constText.Clear( )
    e.isConst.Clear( )
    e.allocaSlot.Clear( )
    e.tempTy.Clear( )
    e.tempAggSize.Clear( )
    for i as long = 0 to f->nextTemp
        e.constText.Push( "" )
        e.isConst.Push( 0 )
        e.allocaSlot.Push( -1 )
        e.tempTy.Push( cast( ubyte, MT_VOID ) )
        e.tempAggSize.Push( 0 )
    next

    for bi as long = 0 to f->blocks.Count - 1
        EmitBlock( e, f->blocks[bi], bi )
    next
    e.outp += "}" & chr( 10 ) & chr( 10 )
    e.f = 0
    if e.dbg <> 0 then e.dbg->curSp = -1
end sub

'' ---------------------------------------------------------------- globals
''
'' EVERY BYTE IS ESCAPED THAT IS NOT PLAINLY PRINTABLE. LLVM's c"..." accepts raw bytes
'' and a backslash-hex escape, and the set that MUST be escaped is smaller than the set
'' that SHOULD be: a literal newline inside a constant is legal and unreadable, and a
'' stray quote or backslash ends or corrupts the string. Escaping conservatively costs
'' nothing and removes the whole question.
private function CString( byref b as string ) as string
    dim as string r = "c"""
    for i as long = 0 to len( b ) - 1
        dim as long ch = b[i]
        dim as boolean plain = (ch >= 32) andalso (ch <= 126)
        if (ch = 34) orelse (ch = 92) then plain = false
        if plain then
            r += chr( ch )
        else
            r += "\" & hex( ch, 2 )
        end if
    next
    return r & """"
end function

'' A wide literal's code units, as an array of the target's wchar. THE WIDTH IS THE
'' TARGET'S -- 2 bytes on Windows, 4 on Linux -- which is why MIR keeps the units and
'' not the bytes: baking a width in would have made the IR target-specific.
private function WideArray _
    ( byref e as EmitCtx, byref g as MirGlobal ) as string

    dim as long w = e.tgt->layout.wcharBytes
    if g.isUtf16 then w = 2
    dim as string ety = "i16"
    if w = 4 then ety = "i32"
    dim as long n = g.wcharCount + 1        '' the terminating NUL
    dim as string r = "[" & str( n ) & " x " & ety & "] ["
    for i as long = 0 to g.wcharCount - 1
        if i > 0 then r += ", "
        r += ety & " " & str( e.m->wcharPool[g.wcharFirst + i] )
    next
    if g.wcharCount > 0 then r += ", "
    r += ety & " 0]"
    return r
end function

private sub EmitGlobal( byref e as EmitCtx, byref g as MirGlobal )
    dim as string nm = GlobalName( e, g.name )

    '' DECLARED HERE, DEFINED ELSEWHERE -- 'object's RTTI record lives in the runtime.
    '' Without 'external' an empty table would read as a real one with no entries.
    if g.isExternal then
        '' ...AND AN EXTERN VARIABLE, whose type is its own rather than a pointer:
        '' 'extern CLSID_ShellLink as const GUID' is 16 bytes, and declaring it as a
        '' pointer would let a read of it take 8.
        dim as string ety = "ptr"
        if g.isVar then ety = LlvmType( cast( MirType, g.ty ), g.size )
        e.outp += nm & " = external global " & ety & chr( 10 )
        return
    end if

    '' A WIDE LITERAL IS TESTED FIRST, and it is a STRING TOO -- AddWideStringUnits
    '' sets isString AND isWide, because the merge lists and the dump both ask "is
    '' this a string" before asking how wide it is. Testing isString first therefore
    '' returned on every wide literal and this branch, and WideArray with it, was
    '' dead code from the day it was written: every wstring literal reached the
    '' linker as its SOURCE BYTES, one per character, and the runtime read those
    '' bytes as uint16 code units. 'dim as string k = wstr( "fOoBaR" )' printed
    '' '????' -- three CJK characters made out of six ASCII ones, none of which
    '' converts back to narrow -- and a 'wstring * N' field read past the end of a
    '' global half the size it should be.
    if g.isWide then
        e.outp += nm & " = private unnamed_addr constant " & WideArray( e, g ) & _
                  ", align " & str( iif( g.isUtf16, 2, e.tgt->layout.wcharBytes ) ) & chr( 10 )
        return
    end if

    '' 'private' because a literal is not a symbol anyone links against, and
    '' 'unnamed_addr' because two identical literals may share storage -- which is
    '' what MIR has already done by merging them.
    if g.isString then
        dim as long n = len( g.bytes ) + 1
        e.outp += nm & " = private unnamed_addr constant [" & str( n ) & " x i8] " & _
                  CString( g.bytes & chr( 0 ) ) & ", align 1" & chr( 10 )
        return
    end if

    '' A VTABLE OR AN RTTI RECORD: a run of pointer-sized words, each a null, another
    '' global's address, or a FUNCTION's address BY NAME -- by name because the
    '' function may be defined in another module and have no index here.
    if g.isPtrTable then
        dim as string body
        for i as long = 0 to g.ptrCount - 1
            if i > 0 then body += ", "
            dim as long k = e.m->ptrKinds[g.ptrFirst + i]
            dim as ulong ref = e.m->ptrRefs[g.ptrFirst + i]
            select case k
            case 0
                body += "ptr null"
            case 1
                if cast( long, ref ) >= e.m->globals.Count then
                    Ice( e, "a pointer table entry naming a global that does not exist" )
                    return
                end if
                body += "ptr " & GlobalName( e, e.m->globals[cast( long, ref )].name )
            case 2
                body += "ptr @""" & e.names->Spelling( cast( Tko.InternId, ref ) ) & """"
            case else
                Ice( e, "a pointer table entry of an unknown kind" )
                return
            end select
        next
        e.outp += nm & " = global [" & str( g.ptrCount ) & " x ptr] [" & body & _
                  "], align " & str( e.tgt->layout.pointerBits \ 8 ) & chr( 10 )
        return
    end if

    '' A DATA BLOCK is a packed array of { int16 TYPE; ptr NODE }. PACKED, because the
    '' pair is 2 + 8 bytes with no padding between entries -- an unpacked struct would
    '' align each one to 8 and the runtime walks the block by stride.
    if g.isData then
        dim as string body
        for i as long = 0 to g.dataCount - 1
            if i > 0 then body += ", "
            dim as long dt = e.m->dataTypes[g.dataFirst + i]
            dim as long dr = e.m->dataRefs[g.dataFirst + i]
            dim as string p = "ptr null"
            if dr >= 0 then
                if dr >= e.m->globals.Count then
                    Ice( e, "a data entry naming a global that does not exist" )
                    return
                end if
                p = "ptr " & GlobalName( e, e.m->globals[dr].name )
            end if
            body += "<{ i16, ptr }> <{ i16 " & str( dt ) & ", " & p & " }>"
        next
        e.outp += nm & " = global [" & str( g.dataCount ) & " x <{ i16, ptr }>] [" & _
                  body & "], align 8" & chr( 10 )
        return
    end if

    if g.isVar = false then
        Ice( e, "a global that is neither storage nor a literal" )
        return
    end if
    EmitVarGlobal( e, g, nm )
end sub

'' A DIM SHARED VARIABLE. The initialiser is part of the DEFINITION and not a store
'' executed in main -- 'static int32 H$ = 5;' is what fbc writes -- so it appears here
'' or nowhere.
sub EmitVarGlobal _
    ( byref e as EmitCtx, byref g as MirGlobal, byref nm as string )

    dim as MirType vt = cast( MirType, g.ty )
    dim as string ty = LlvmType( vt, g.size )
    dim as string init_ = "zeroinitializer"

    '' A VARIABLE MAY CARRY A POINTER TABLE TOO, and only the vtable branch above
    '' knew how to write one. 'static as fntype fn = ( @subr_cb, @func_cb )' over a
    '' UDT of two procedure pointers reaches lowering as ptrKinds/ptrRefs -- the
    '' MIR dump prints '= [ SUBR_CB, FUNC_CB ]' -- and then came out here as
    '' 'zeroinitializer', because the byte-image branch below cannot hold a
    '' relocation and the single-relocation branch after it holds exactly one.
    ''
    '' So the record was all zeroes and 'fn.s( )' called a null pointer. Nothing
    '' said so: tests/mir/static-ptr-record checks the MIR, where the words are
    '' present, and stops there.
    ''
    '' ONLY WHEN THE WORDS ARE THE WHOLE OBJECT. A UDT with a pointer field and an
    '' integer one is not a table, and writing it as '[n x ptr]' would shorten it.
    if g.ptrCount > 0 then
        dim as long pw = e.tgt->layout.pointerBits \ 8
        if (g.ptrCount * pw) = g.size then
            dim as string tbody
            for i as long = 0 to g.ptrCount - 1
                if i > 0 then tbody += ", "
                dim as long k = e.m->ptrKinds[g.ptrFirst + i]
                dim as ulong ref = e.m->ptrRefs[g.ptrFirst + i]
                select case k
                case 0
                    tbody += "ptr null"
                case 1
                    if cast( long, ref ) >= e.m->globals.Count then
                        Ice( e, "a pointer word naming a global that does not exist" )
                        return
                    end if
                    tbody += "ptr " & GlobalName( e, e.m->globals[cast( long, ref )].name )
                case 2
                    tbody += "ptr @""" & e.names->Spelling( cast( Tko.InternId, ref ) ) & """"
                case else
                    Ice( e, "a pointer word of an unknown kind" )
                    return
                end select
            next
            e.outp += nm & " = global [" & str( g.ptrCount ) & " x ptr] [" & tbody & _
                      "], align " & str( pw ) & chr( 10 )
            return
        end if
    end if

    if vt <> MT_AGG then
        if g.hasInit then
            select case vt
            case MT_F32 : init_ = LlvmFloatConst( g.initFlt, true )
            case MT_F64 : init_ = LlvmFloatConst( g.initFlt, false )
            case else   : init_ = str( g.initInt )
            end select
        else
            init_ = "0"
            if vt = MT_PTR then init_ = "null"
            if (vt = MT_F32) orelse (vt = MT_F64) then init_ = "0.0"
        end if
        '' An UNINITIALISED pointer global is still 'null' rather than '0': LLVM will
        '' not take an integer for a pointer initialiser.
        if (vt = MT_PTR) andalso g.hasInit then
            if g.initInt = 0 then init_ = "null"
        end if
    elseif len( g.initBytes ) > 0 then
        '' AN AGGREGATE'S INITIAL VALUE IS THE BYTE IMAGE OF ITS STORAGE, which is what
        '' a field-by-field initialiser with its offsets already is. It is exactly
        '' 'size' bytes and gets no terminator: this is an object, not a literal.
        dim as string img = g.initBytes
        if len( img ) > g.size then img = left( img, g.size )
        while len( img ) < g.size
            img += chr( 0 )
        wend
        init_ = CString( img )
    end if

    '' AN ADDRESS AS AN INITIAL VALUE IS A RELOCATION, not a number: 'static px as UDT
    '' ptr = @x' is neither of the two branches above -- one holds a constant and the
    '' other a byte image, and the address of another global is neither.
    if g.initReloc >= 0 then
        if g.initReloc >= e.m->globals.Count then
            Ice( e, "a relocation naming a global that does not exist" )
            return
        end if
        dim as string baseSym = GlobalName( e, e.m->globals[g.initReloc].name )
        if g.initRelocOff <> 0 then
            init_ = "getelementptr (i8, ptr " & baseSym & ", i64 " & _
                    str( g.initRelocOff ) & ")"
        else
            init_ = baseSym
        end if
    elseif g.initRelocFn <> 0 then
        init_ = "@""" & e.names->Spelling( g.initRelocFn ) & """"
    end if

    '' AN ADDRESS IN AN INTEGER SLOT IS A ptrtoint. 'static f as uinteger =
    '' cptr( uinteger, @s )' is an address written into an INTEGER global, and a bare
    '' symbol there is 'global variable reference must have pointer type' -- LLVM
    '' will not narrow a relocation implicitly. It is a constant expression, which
    '' is what a static initialiser has to be.
    dim as boolean isReloc = (g.initReloc >= 0)
    if isReloc = false then isReloc = (g.initRelocFn <> 0)
    if isReloc andalso (vt <> MT_PTR) andalso (vt <> MT_AGG) then
        init_ = "ptrtoint (ptr " & init_ & " to " & LlvmType( vt ) & ")"
    end if

    e.outp += nm & " = global " & ty & " " & init_ & _
              ", align " & str( AlignOf( e, vt, g.size ) ) & chr( 10 )
end sub

'' ---------------------------------------------------------------- the module
''
'' AN INTRINSIC MUST BE DECLARED before it is called, and which ones are needed is only
'' known once every function has been emitted. So the body is built first and the
'' declarations are prepended -- which is also why the emitter builds one string and
'' writes it once rather than streaming to a file.
'' Does this module carry a function of its own under that LINKER NAME?
''
'' The intrinsic declarations below are chosen by scanning the emitted TEXT, and
'' a call the program wrote itself looks exactly like one this emitter made. The
'' MirFunction table tells them apart.
private function ModuleDeclares_( byref e as EmitCtx, byref nm as string ) as boolean
    for i as long = 0 to e.m->functions.Count - 1
        dim as MirFunction ptr f = e.m->functions[i]
        if f = 0 then continue for
        if e.names->Spelling( f->name ) = nm then return true
    next
    return false
end function

private function IntrinsicDecls _
    ( byref e as EmitCtx, byref body as string ) as string
    dim as string r
    '' The full set this emitter can produce, each declared only if it appears. A
    '' declaration that is never called is harmless but noisy, and noise in emitted IR
    '' is what makes a real difference hard to see in a golden diff.
    dim as string names_( ... ) = { _
        "llvm.floor.float", "llvm.floor.double", _
        "llvm.sqrt.float", "llvm.sqrt.double", _
        "llvm.sin.float", "llvm.sin.double", _
        "llvm.cos.float", "llvm.cos.double", _
        "llvm.log.float", "llvm.log.double", _
        "llvm.exp.float", "llvm.exp.double", _
        "llvm.fabs.float", "llvm.fabs.double", _
        "llvm.nearbyint.float", "llvm.nearbyint.double" }
    for i as long = lbound( names_ ) to ubound( names_ )
        dim as string n = names_( i )
        if instr( body, "@" & n & "(" ) = 0 then continue for
        dim as string t = "double"
        if right( n, 6 ) = ".float" then t = "float"
        r += "declare " & t & " @" & n & "(" & t & ") nounwind" & chr( 10 )
    next

    dim as string ints( ... ) = { "i8", "i16", "i32", "i64" }
    for i as long = lbound( ints ) to ubound( ints )
        dim as string t = ints( i )
        if instr( body, "@llvm.abs." & t & "(" ) = 0 then continue for
        r += "declare " & t & " @llvm.abs." & t & "(" & t & ", i1) nounwind" & chr( 10 )
    next

    dim as string vas( ... ) = { "va_start", "va_end" }
    for i as long = lbound( vas ) to ubound( vas )
        if instr( body, "@llvm." & vas( i ) & ".p0(" ) = 0 then continue for
        r += "declare void @llvm." & vas( i ) & ".p0(ptr) nounwind" & chr( 10 )
    next
    if instr( body, "@llvm.va_copy.p0(" ) > 0 then
        r += "declare void @llvm.va_copy.p0(ptr, ptr) nounwind" & chr( 10 )
    end if

    '' The four libm functions with no intrinsic. Declared with their real signatures
    '' so that LLVM does not invent one from the call.
    dim as string libm( ... ) = { "tan", "asin", "acos", "atan" }
    for i as long = lbound( libm ) to ubound( libm )
        dim as string n = libm( i )
        '' ...UNLESS THE MODULE DECLARES IT ITSELF. A program may write
        '' 'declare function asinf cdecl alias "asinf"( byval as single ) as single'
        '' and call it -- optimizations/inline-ops.bas does, to check tiko's own
        '' ASIN against libm's -- and then there are TWO declarations of one name:
        '' 'invalid redefinition of function asinf'. The module's own is the one
        '' that stays: it is what its call sites were emitted against.
        if ModuleDeclares_( e, n ) = false then
            if instr( body, "@""" & n & """(" ) > 0 then
                r += "declare double @""" & n & """(double) nounwind" & chr( 10 )
            end if
        end if
        if ModuleDeclares_( e, n & "f" ) = false then
            if instr( body, "@""" & n & "f""(" ) > 0 then
                r += "declare float @""" & n & "f""(float) nounwind" & chr( 10 )
            end if
        end if
    next
    return r
end function

function EmitLlvm _
    ( byref m as MirModule, byref names as Tko.Interner, _
      byref target as TargetDescription, byval sm as Tko.SourceManager ptr, _
      byval debugInfo as boolean, byval mainPath as string ) as EmitResult

    dim as EmitResult res
    dim as EmitCtx e
    e.m = @m
    e.names = @names
    e.tgt = @target
    dim as DebugInfo dbg
    if debugInfo then
        DbgBegin( dbg, sm, mainPath )
        e.dbg = @dbg
    end if

    for gi as long = 0 to m.globals.Count - 1
        EmitGlobal( e, m.globals[gi] )
    next
    if m.globals.Count > 0 then e.outp += chr( 10 )

    '' AN UNREFERENCED PRIVATE PROCEDURE IS NOT EMITTED, because fbc does not emit one:
    '' emitting it made a link fail that fbc links, and only -O0 showed it (LLVM deletes
    '' the internal function at -O1). codegen/llvmrefs.bas has the measurement.
    dim as FB.Array( of ubyte ) refd = ReferencedFunctions( m )

    '' DEFINITIONS FIRST, then declarations, which is only a readability choice -- LLVM
    '' does not care -- but it keeps a golden diff of the code away from the churn of
    '' an added runtime declaration.
    for fi as long = 0 to m.functions.Count - 1
        dim as MirFunction ptr f = m.functions[fi]
        if f = 0 then continue for
        if f->isDefinition = false then continue for
        '' HOISTED, each one a boolean of its own: warning 38 is FreeBASIC objecting to
        '' a boolean beside a non-boolean in one 'andalso' chain, and the house rule is
        '' to give each term a name rather than to widen the chain.
        dim as boolean unref = (refd[fi] = 0)
        dim as boolean isRoot = (f->isModuleCtor orelse f->isModuleDtor)
        if f->isPrivate andalso unref andalso (isRoot = false) then continue for
        EmitFunction( e, f )
    next
    '' A DECLARATION OF SOMETHING THIS MODULE ALSO DEFINES IS SKIPPED. Two MirFunction
    '' entries can carry one name: a call lowered before the definition was reached
    '' creates a declaration, and the definition arrives later as its own entry. MIR
    '' does not mind -- the call names an index, not a name -- but LLVM does, and
    '' emitting both is "invalid redefinition of function". The declaration is the
    '' redundant one: everything it could say, the definition says.
    for fi as long = 0 to m.functions.Count - 1
        dim as MirFunction ptr f = m.functions[fi]
        if f = 0 then continue for
        if f->isDefinition then continue for
        dim as boolean alsoDefined = false
        for gi as long = 0 to m.functions.Count - 1
            dim as MirFunction ptr g = m.functions[gi]
            if g = 0 then continue for
            if g->isDefinition = false then continue for
            if g->name = f->name then
                alsoDefined = true
                exit for
            end if
        next
        if alsoDefined then continue for
        EmitFunction( e, f )
    next

    '' A VTABLE SLOT MAY NAME A FUNCTION THIS MODULE NEVER DECLARES -- see
    '' codegen/llvmrefs.bas, which writes the declarations LLVM needs for them.
    e.outp += DeclareUnknownVtableSlots( m, names, e.outp )

    '' MODULE-LIFETIME CONSTRUCTORS. gcc spells this an attribute and LLVM spells it a
    '' list; the priority 65535 is the default one, and the third field -- the data a
    '' constructor is associated with -- is null because these belong to the module
    '' rather than to any one object.
    dim as string ctors
    dim as long nctor = 0
    for fi as long = 0 to m.functions.Count - 1
        dim as MirFunction ptr f = m.functions[fi]
        if f = 0 then continue for
        if f->isModuleCtor = false then continue for
        if nctor > 0 then ctors += ", "
        ctors += "{ i32, ptr, ptr } { i32 65535, ptr " & GlobalName( e, f->name ) & _
                 ", ptr null }"
        nctor += 1
    next
    if nctor > 0 then
        e.outp += "@llvm.global_ctors = appending global [" & str( nctor ) & _
                  " x { i32, ptr, ptr }] [" & ctors & "]" & chr( 10 )
    end if

    '' ...AND MODULE-LIFETIME DESTRUCTORS, which were not emitted at all. MIR has
    '' carried isModuleDtor since 'sub f( ) destructor' was parsed, dump.bas prints
    '' 'attribute destructor' beside the function, and the emitter ignored it -- so the
    '' procedure was written out correctly and NOTHING EVER CALLED IT.
    ''
    '' Measured, fbc emits 'void CHECK( void ) __attribute__(( destructor ));' and the
    '' program prints '1  1'; tiko's printed nothing at all and exited 0, which is why
    '' only build/runscan.sh could see it -- it compiles, it links, and it is silent.
    '' tests/vendor/fbc-tests/scopes/dtor_eol_eof1.bas is the corpus file that says so.
    ''
    '' THE SAME SHAPE AS THE CONSTRUCTOR LIST: priority 65535 is the default, and the
    '' third field is null because these belong to the module and not to an object.
    dim as string dtors
    dim as long ndtor = 0
    for fi as long = 0 to m.functions.Count - 1
        dim as MirFunction ptr f = m.functions[fi]
        if f = 0 then continue for
        if f->isModuleDtor = false then continue for
        if ndtor > 0 then dtors += ", "
        dtors += "{ i32, ptr, ptr } { i32 65535, ptr " & GlobalName( e, f->name ) & _
                 ", ptr null }"
        ndtor += 1
    next
    if ndtor > 0 then
        e.outp += "@llvm.global_dtors = appending global [" & str( ndtor ) & _
                  " x { i32, ptr, ptr }] [" & dtors & "]" & chr( 10 )
    end if

    if len( e.ice ) > 0 then
        res.ok = false
        res.ice = e.ice
        return res
    end if

    dim as string hdr = _
        "target datalayout = """ & target.dataLayout & """" & chr( 10 ) & _
        "target triple = """ & target.triple & """" & chr( 10 ) & chr( 10 )
    res.ok = true
    dim as string body_ = e.outp
    res.text = hdr & IntrinsicDecls( e, body_ ) & chr( 10 ) & body_
    if e.dbg <> 0 then res.text += DbgFinish( dbg )
    return res
end function

end namespace
