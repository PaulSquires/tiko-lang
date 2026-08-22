'' lowerimpl.bas -- the constructor and destructor fbc writes for you.
''
'' 'type T : a as long : s as string : end type' declares neither, and fbc SYNTHESISES
'' both. Without them 'dim as T x : x.s = "hi"' handed fb_StrAssign a descriptor full of
'' whatever the stack held, which the runtime reads as an existing allocation and frees.
'' Not a leak -- a crash, from a program with no diagnostic against it.
''
'' Measured from fbc's own C output. The parts that are not guessable:
''
''   THE TRIGGERS ARE PER-OPERATION AND INDEPENDENT. A field with a user DESTRUCTOR
''   gives the enclosing type a destructor and NOTHING else; a field with a user
''   CONSTRUCTOR gives it a constructor and no destructor; 'extends object' gives it a
''   constructor -- the vptr store -- and no destructor. Declaring one of them never
''   suppresses the others.
''
''   THE BODY IS PREPENDED TO A USER-WRITTEN ONE, not used instead of it. A written
''   constructor still gets the base call, the field initialisation and the vptr store
''   in front of its own statements, and a written destructor still gets the field
''   releases and the base call after them. So this file is not only about types that
''   declare nothing.
''
''   CONSTRUCTOR ORDER: base, then fields in DECLARATION order, then the vptr.
''   DESTRUCTOR ORDER: the vptr, then the body, then fields in REVERSE declaration
''   order, then the base. Both measured, and the reverse is not symmetry -- it was
''   read off the offsets fbc emits.
''
'' NOT DONE, and stated rather than hidden: the implicit COPY CONSTRUCTOR and the
'' implicit 'operator let'. fbc synthesises both wherever it synthesises a constructor,
'' and without them 'dim as T y = x' and 'x = y' over a type holding a string copy the
'' descriptor bitwise -- two descriptors owning one buffer. That is the same class of
'' bug as the one this file fixes and it is still open.

#include once "mir/lowerctx.bi"

namespace Fbx.Mir

'' Defined in lowerstr.bas. IsStringType is true for a FIXED-LENGTH string too, and one
'' of those is bytes rather than a descriptor: zeroing it or handing it to fb_StrDelete
'' would be releasing something that was never allocated. Kind 0 is the var-length one.
declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref n as longint ) as long

private function IsObjectT_( byref c as Ctx, byval t as Fbx.TypeId ) as boolean
    if t = Fbx.TYPE_NONE then return false
    if c.types->Kind( t ) <> Fbx.TK_UDT then return false
    return (c.types->NameOf( t ) = c.names->GetString( "object" ))
end function

'' The base a UDT extends, or nothing. 'extends' is a field named 'base' at offset 0.
private function ImplBaseOf_( byref c as Ctx, byval t as Fbx.TypeId ) as Fbx.TypeId
    if t = Fbx.TYPE_NONE then return Fbx.TYPE_NONE
    if c.types->Kind( t ) <> Fbx.TK_UDT then return Fbx.TYPE_NONE
    dim as Fbx.SymbolId ts = UdtSymOf_( c, t )
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( ts )
    if s = 0 then return Fbx.TYPE_NONE
    if s->inner = Fbx.SCOPE_NONE then return Fbx.TYPE_NONE
    dim as Fbx.SymbolId bf = c.syms->LookupLocal( s->inner, c.vts->baseName )
    if bf = Fbx.SYMBOL_NONE then return Fbx.TYPE_NONE
    dim as Fbx.Symbol ptr b = c.syms->SymbolAt( bf )
    if b = 0 then return Fbx.TYPE_NONE
    if b->kind <> cast( ubyte, Fbx.SYM_FIELD ) then return Fbx.TYPE_NONE
    return b->type_
end function

'' The UDT symbol a TypeId belongs to.
function UdtSymOf_( byref c as Ctx, byval t as Fbx.TypeId ) as Fbx.SymbolId
    if t = Fbx.TYPE_NONE then return Fbx.SYMBOL_NONE
    if c.types->Kind( t ) <> Fbx.TK_UDT then return Fbx.SYMBOL_NONE
    dim as Fbx.InternId tn = c.types->NameOf( t )
    if tn = 0 then return Fbx.SYMBOL_NONE
    dim as Fbx.ScopeId ds = cast( Fbx.ScopeId, c.types->DeclScopeOf( t ) )
    dim as Fbx.SymbolId ts = c.syms->LookupLocalTyped( ds, tn, true )
    if ts = Fbx.SYMBOL_NONE then ts = c.syms->LookupTyped( ds, tn, true )
    return ts
end function

'' Does a member of this type need INITIALISING -- a string descriptor zeroed, a dynamic
'' array's descriptor built, a nested constructor run, a vptr stored?
function TypeNeedsInit_( byref c as Ctx, byval t as Fbx.TypeId ) as boolean
    if t = Fbx.TYPE_NONE then return false
    if IsStringType( c, t ) then return true
    if c.types->IsDynArray( t ) then return true
    if c.types->Kind( t ) = Fbx.TK_ARRAY then return TypeNeedsInit_( c, c.types->Inner( t ) )
    if c.types->Kind( t ) <> Fbx.TK_UDT then return false

    '' A TABLE MEANS A VPTR, and the vptr is stored by the constructor.
    if c.vts <> 0 then
        if c.vts->Find( t ) >= 0 then return true
    end if
    if StructorWithArity( c, StructorOf( c, t, "__ctor" ), 0 ) <> Fbx.SYMBOL_NONE then
        return true
    end if

    dim as Fbx.SymbolId ts = UdtSymOf_( c, t )
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( ts )
    if s = 0 then return false
    if s->inner = Fbx.SCOPE_NONE then return false
    dim as Fbx.SymScope ptr sc = c.syms->ScopeAt( s->inner )
    if sc = 0 then return false
    dim as Fbx.SymbolId cur = sc->firstSym
    dim as long guard = 0
    while (cur <> Fbx.SYMBOL_NONE) andalso (guard < 100000)
        guard += 1
        dim as Fbx.Symbol ptr f = c.syms->SymbolAt( cur )
        if f = 0 then exit while
        if f->kind = cast( ubyte, Fbx.SYM_FIELD ) then
            if f->type_ <> t then
                if TypeNeedsInit_( c, f->type_ ) then return true
            end if
        end if
        cur = f->nextInScope
    wend
    return false
end function

'' ...and RELEASING? A string, a dynamic array, or anything holding one.
''
'' NOT the same set as above, which is what the measurement said and symmetry would
'' not: 'extends object' needs a constructor and no destructor, and a field with a
'' user constructor needs a constructor and no destructor either.
function TypeNeedsDtor_( byref c as Ctx, byval t as Fbx.TypeId ) as boolean
    if t = Fbx.TYPE_NONE then return false
    if IsObjectT_( c, t ) then return false
    if IsStringType( c, t ) then return true
    if c.types->IsDynArray( t ) then return true
    if c.types->Kind( t ) = Fbx.TK_ARRAY then return TypeNeedsDtor_( c, c.types->Inner( t ) )
    if c.types->Kind( t ) <> Fbx.TK_UDT then return false

    if StructorWithArity( c, StructorOf( c, t, "__dtor" ), 0 ) <> Fbx.SYMBOL_NONE then
        return true
    end if

    dim as Fbx.SymbolId ts = UdtSymOf_( c, t )
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( ts )
    if s = 0 then return false
    if s->inner = Fbx.SCOPE_NONE then return false
    dim as Fbx.SymScope ptr sc = c.syms->ScopeAt( s->inner )
    if sc = 0 then return false
    dim as Fbx.SymbolId cur = sc->firstSym
    dim as long guard = 0
    while (cur <> Fbx.SYMBOL_NONE) andalso (guard < 100000)
        guard += 1
        dim as Fbx.Symbol ptr f = c.syms->SymbolAt( cur )
        if f = 0 then exit while
        if f->kind = cast( ubyte, Fbx.SYM_FIELD ) then
            if f->type_ <> t then
                if TypeNeedsDtor_( c, f->type_ ) then return true
            end if
        end if
        cur = f->nextInScope
    wend
    return false
end function

private function AnyFieldNeeds_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byval forDtor as boolean ) as boolean

    dim as Fbx.SymbolId ts = UdtSymOf_( c, t )
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( ts )
    if s = 0 then return false
    if s->inner = Fbx.SCOPE_NONE then return false
    dim as Fbx.SymScope ptr sc = c.syms->ScopeAt( s->inner )
    if sc = 0 then return false
    dim as Fbx.SymbolId cur = sc->firstSym
    dim as long guard = 0
    while (cur <> Fbx.SYMBOL_NONE) andalso (guard < 100000)
        guard += 1
        dim as Fbx.Symbol ptr f = c.syms->SymbolAt( cur )
        if f = 0 then exit while
        if (f->kind = cast( ubyte, Fbx.SYM_FIELD )) andalso (f->type_ <> t) then
            if forDtor then
                if TypeNeedsDtor_( c, f->type_ ) then return true
            else
                if TypeNeedsInit_( c, f->type_ ) then return true
            end if
        end if
        cur = f->nextInScope
    wend
    return false
end function

'' A DIFFERENT QUESTION FROM TypeNeedsInit_, and conflating the two put a dead 'load
'' this' in the prologue of every structor of every ordinary UDT.
''
''   TypeNeedsInit_( T )  -- "a MEMBER of type T needs initialising", which is true
''                           when T has a constructor of its own.
''   NeedsCtorBody_( T )  -- "T's OWN constructor has work to do", which that same
''                           constructor's existence says nothing about.
''
'' The base is an ordinary field here, so a base needing initialisation is covered by
'' the field scan.
function NeedsCtorBody_( byref c as Ctx, byval t as Fbx.TypeId ) as boolean
    if t = Fbx.TYPE_NONE then return false
    if IsObjectT_( c, t ) then return false
    if c.types->Kind( t ) <> Fbx.TK_UDT then return false
    if c.vts <> 0 then
        if c.vts->Find( t ) >= 0 then return true
    end if
    return AnyFieldNeeds_( c, t, false )
end function

function NeedsDtorBody_( byref c as Ctx, byval t as Fbx.TypeId ) as boolean
    if t = Fbx.TYPE_NONE then return false
    if IsObjectT_( c, t ) then return false
    if c.types->Kind( t ) <> Fbx.TK_UDT then return false
    return AnyFieldNeeds_( c, t, true )
end function

'' The fields of a UDT, in declaration order, as (symbol, offset) pairs.
private sub FieldsInOrder_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref outv as FB.Array( of ulong ) )

    dim as Fbx.SymbolId ts = UdtSymOf_( c, t )
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( ts )
    if s = 0 then return
    if s->inner = Fbx.SCOPE_NONE then return
    dim as Fbx.SymScope ptr sc = c.syms->ScopeAt( s->inner )
    if sc = 0 then return
    dim as Fbx.SymbolId cur = sc->firstSym
    dim as long guard = 0
    while (cur <> Fbx.SYMBOL_NONE) andalso (guard < 100000)
        guard += 1
        dim as Fbx.Symbol ptr f = c.syms->SymbolAt( cur )
        if f = 0 then exit while
        '' THE BASE IS NOT A FIELD HERE. It is constructed by its own call, before
        '' everything else, and treating it as an ordinary member would run its
        '' initialisation twice.
        if (f->kind = cast( ubyte, Fbx.SYM_FIELD )) andalso (f->name <> c.vts->baseName) then
            outv.Push( cast( ulong, cur ) )
        end if
        cur = f->nextInScope
    wend
end sub

'' The address of one field, given the object's address.
private function FieldAddr_ _
    ( byref c as Ctx, byref thisPtr as MirValue, byval t as Fbx.TypeId, _
      byval nm as Fbx.InternId ) as MirValue

    dim as boolean found = false
    dim as long off = c.udts->FieldOffset( t, nm, found )
    dim as MirValue none_
    if found = false then return none_
    dim as MirInst fa
    fa.op = cast( ushort, M_FIELD_ADDR )
    fa.ty = cast( ubyte, MT_PTR )
    fa.a = thisPtr
    fa.imm = off
    return Emit( c, fa )
end function

'' One member's initialisation, whatever it turns out to be.
private sub InitMember_ _
    ( byref c as Ctx, byref addr as MirValue, byval ft as Fbx.TypeId )

    if addr.kind = cast( ubyte, MV_NONE ) then return
    if IsStringType( c, ft ) then
        '' A var-length string is a descriptor, and an UNZEROED one is what made
        '' fb_StrAssign free a pointer that was never allocated.
        if StrSwapKind_( c, ft, 0 ) = 0 then ZeroStrDescriptor( c, addr )
        return
    end if
    if c.types->IsDynArray( ft ) then
        InitDynArrayDesc( c, addr, ft )
        return
    end if
    if c.types->Kind( ft ) <> Fbx.TK_UDT then return

    dim as Fbx.SymbolId ctor = StructorWithArity( c, StructorOf( c, ft, "__ctor" ), 0 )
    if ctor <> Fbx.SYMBOL_NONE then
        dim as FB.Array( of ulong ) none_
        EmitStructorCall( c, ctor, -1, @addr, @none_ )
        return
    end if
    if TypeNeedsInit_( c, ft ) then CallImplicitCtor_( c, ft, addr )
end sub

'' ...and one member's release.
private sub DestroyMember_ _
    ( byref c as Ctx, byref addr as MirValue, byval ft as Fbx.TypeId )

    if addr.kind = cast( ubyte, MV_NONE ) then return
    if IsStringType( c, ft ) then
        if StrSwapKind_( c, ft, 0 ) = 0 then
            dim as FB.Array( of ulong ) args
            args.Push( cast( ulong, addr.kind ) ) : args.Push( cast( ulong, addr.id ) )
            EmitRtl( c, RTL_STR_DELETE, args )
        end if
        return
    end if
    if c.types->IsDynArray( ft ) then
        dim as FB.Array( of ulong ) args
        args.Push( cast( ulong, addr.kind ) ) : args.Push( cast( ulong, addr.id ) )
        EmitRtl( c, RTL_ARRAY_ERASE, args )
        return
    end if
    if c.types->Kind( ft ) <> Fbx.TK_UDT then return

    dim as Fbx.SymbolId dtor = StructorWithArity( c, StructorOf( c, ft, "__dtor" ), 0 )
    if dtor <> Fbx.SYMBOL_NONE then
        dim as FB.Array( of ulong ) none_
        EmitStructorCall( c, dtor, -1, @addr, @none_ )
        return
    end if
    if TypeNeedsDtor_( c, ft ) then CallImplicitDtor_( c, ft, addr )
end sub

'' The base call, the fields in DECLARATION order, then the vptr. Measured order, and
'' this runs in front of a user-written constructor's own statements as well.
sub EmitCtorPrologue_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref thisPtr as MirValue )

    if thisPtr.kind = cast( ubyte, MV_NONE ) then return

    dim as Fbx.TypeId bt = ImplBaseOf_( c, t )
    if (bt <> Fbx.TYPE_NONE) andalso (bt <> t) then
        '' The base subobject is at offset 0, so its address is this one -- but it is
        '' taken through field.addr all the same, because fbc's cast says so and a
        '' later change to that offset would otherwise be silent.
        dim as MirValue ba = FieldAddr_( c, thisPtr, t, c.vts->baseName )
        if ba.kind <> cast( ubyte, MV_NONE ) then
            dim as Fbx.SymbolId bc = StructorWithArity( c, StructorOf( c, bt, "__ctor" ), 0 )
            if bc <> Fbx.SYMBOL_NONE then
                dim as FB.Array( of ulong ) none_
                EmitStructorCall( c, bc, -1, @ba, @none_ )
            elseif TypeNeedsInit_( c, bt ) then
                CallImplicitCtor_( c, bt, ba )
            end if
        end if
    end if

    dim as FB.Array( of ulong ) flds
    FieldsInOrder_( c, t, flds )
    for i as long = 0 to flds.Count - 1
        dim as Fbx.Symbol ptr f = c.syms->SymbolAt( cast( Fbx.SymbolId, flds[i] ) )
        if f = 0 then continue for
        if TypeNeedsInit_( c, f->type_ ) = false then continue for
        InitMember_( c, FieldAddr_( c, thisPtr, t, f->name ), f->type_ )
    next

    '' LAST, after the fields -- measured. A derived constructor therefore overwrites
    '' what the base's just stored, which is what makes a virtual call inside a base
    '' constructor body reach the BASE override.
    StoreVptr_( c, t, thisPtr )
end sub

'' The fields in REVERSE declaration order, then the base. Runs AFTER a user-written
'' destructor's own statements.
sub EmitDtorEpilogue_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref thisPtr as MirValue )

    if thisPtr.kind = cast( ubyte, MV_NONE ) then return

    dim as FB.Array( of ulong ) flds
    FieldsInOrder_( c, t, flds )
    for i as long = flds.Count - 1 to 0 step -1
        dim as Fbx.Symbol ptr f = c.syms->SymbolAt( cast( Fbx.SymbolId, flds[i] ) )
        if f = 0 then continue for
        if TypeNeedsDtor_( c, f->type_ ) = false then continue for
        DestroyMember_( c, FieldAddr_( c, thisPtr, t, f->name ), f->type_ )
    next

    dim as Fbx.TypeId bt = ImplBaseOf_( c, t )
    if (bt <> Fbx.TYPE_NONE) andalso (bt <> t) then
        dim as MirValue ba = FieldAddr_( c, thisPtr, t, c.vts->baseName )
        if ba.kind <> cast( ubyte, MV_NONE ) then
            dim as Fbx.SymbolId bd = StructorWithArity( c, StructorOf( c, bt, "__dtor" ), 0 )
            if bd <> Fbx.SYMBOL_NONE then
                dim as FB.Array( of ulong ) none_
                EmitStructorCall( c, bd, -1, @ba, @none_ )
            elseif TypeNeedsDtor_( c, bt ) then
                CallImplicitDtor_( c, bt, ba )
            end if
        end if
    end if
end sub

'' The emitted name of a synthesised structor, spelled the way fbc spells a written
'' one: '_ZN1TC1Ev' and '_ZN1TD1Ev'. A type already in a namespace encodes as
'' 'N2NS1TE' and is not wrapped twice.
private function ImplStructorName_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byval suffix as string ) as string

    dim as Fbx.Mangle.Substitutions subs
    dim as string code = Fbx.Mangle.TypeCode( t, *c.types, *c.syms, *c.names, subs )
    if len( code ) = 0 then return ""
    if left( code, 1 ) = "N" then
        '' 'N2NS1TE' -> 'N2NS1TC1Ev': the trailing E belongs to the nested name and the
        '' structor code goes inside it.
        return "_Z" + left( code, len( code ) - 1 ) + suffix + "Ev"
    end if
    return "_ZN" + code + suffix + "Ev"
end function

function ImplicitCtorName_( byref c as Ctx, byval t as Fbx.TypeId ) as string
    '' OBJECT'S CONSTRUCTOR IS THE RUNTIME'S, under a name nothing else would produce:
    '' fbc declares 'void _ZN10fb_Object$C1Ev( struct $10fb_Object$* )' and never
    '' defines it. Synthesising one here instead gave every 'extends object' chain an
    '' EMPTY constructor named after a type -- so the vptr the runtime stores was never
    '' stored at all, and the base of the chain kept whatever the stack held.
    ''
    '' NOT DECORATED FOR WIN32. fbc declares it cdecl there, so the linker-visible name
    '' carries a leading underscore that this does not add -- fbx has no backend to
    '' apply it in yet, and every other hand-written runtime name here is in the same
    '' position.
    if IsObjectT_( c, t ) then return "_ZN10fb_Object$C1Ev"
    return ImplStructorName_( c, t, "C1" )
end function

function ImplicitDtorName_( byref c as Ctx, byval t as Fbx.TypeId ) as string
    '' OBJECT HAS NO DESTRUCTOR. Measured: a module holding only 'dim shared as object'
    '' emits a _GLOBAL__I and no _GLOBAL__D at all.
    if IsObjectT_( c, t ) then return ""
    return ImplStructorName_( c, t, "D1" )
end function

'' A call to one, declared if this module has not defined it.
private sub CallImplByName_ _
    ( byref c as Ctx, byref nm as string, byref selfv as MirValue )

    if len( nm ) = 0 then return
    if selfv.kind = cast( ubyte, MV_NONE ) then return
    dim as Fbx.InternId id = c.names->GetString( nm )
    dim as long fidx = -1
    for i as long = 0 to c.m->functions.Count - 1
        if c.m->functions[i]->name = id then
            fidx = i
            exit for
        end if
    next
    if fidx < 0 then
        dim as MirFunction ptr decl = c.m->AddFunction( id, MT_VOID )
        decl->isDefinition = false
        decl->paramCount = 1
        fidx = c.m->functions.Count - 1
    end if
    dim as long first = c.m->argPool.Count \ 2
    c.m->argPool.Push( cast( ulong, selfv.kind ) )
    c.m->argPool.Push( cast( ulong, selfv.id ) )
    dim as MirInst ins
    ins.op = cast( ushort, M_CALL )
    ins.ty = cast( ubyte, MT_VOID )
    ins.first = first
    ins.count = 1
    ins.callee = fidx
    Emit( c, ins )
end sub

sub WantImplicit_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byval isCtor as boolean )

    dim as long k = iif( isCtor, 1, 0 )
    for i as long = 0 to c.implWantedType.Count - 1
        if (c.implWantedType[i] = cast( ulong, t )) andalso (c.implWantedKind[i] = k) then
            return
        end if
    next
    c.implWantedType.Push( cast( ulong, t ) )
    c.implWantedKind.Push( k )
end sub

sub CallImplicitCtor_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref selfv as MirValue )
    WantImplicit_( c, t, true )
    CallImplByName_( c, ImplicitCtorName_( c, t ), selfv )
end sub

sub CallImplicitDtor_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref selfv as MirValue )
    WantImplicit_( c, t, false )
    CallImplByName_( c, ImplicitDtorName_( c, t ), selfv )
end sub

'' One synthesised structor, as a real function with a real name -- not as code inlined
'' at each use. A vtable slot names one, an array's elements are constructed by calling
'' one in a loop, and 'new T' calls one; giving it a body in one place is what lets all
'' of those refer to it.
private sub EmitOneImplicit_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byval isCtor as boolean )

    dim as string nm = iif( isCtor, ImplicitCtorName_( c, t ), ImplicitDtorName_( c, t ) )
    if len( nm ) = 0 then return
    dim as Fbx.InternId id = c.names->GetString( nm )
    for i as long = 0 to c.m->functions.Count - 1
        if (c.m->functions[i]->name = id) andalso c.m->functions[i]->isDefinition then return
    next

    dim as MirFunction ptr f = c.m->AddFunction( id, MT_VOID )
    f->isDefinition = true
    f->paramCount = 1

    dim as MirFunction ptr savedF = c.f
    dim as long savedB = c.curBlock
    c.f = f
    c.st->functions += 1
    c.curBlock = NewBlock( c, "entry" )

    '' THIS arrives as parameter zero, exactly as it does for a written structor.
    dim as MirValue selfv
    selfv.kind = cast( ubyte, MV_PARAM )
    selfv.ty = cast( ubyte, MT_PTR )
    selfv.id = 0

    if isCtor then
        EmitCtorPrologue_( c, t, selfv )
    else
        '' THE VPTR FIRST, so the rest of this destructor -- and anything it calls --
        '' sees this type's own table rather than the derived one that was there.
        StoreVptr_( c, t, selfv )
        EmitDtorEpilogue_( c, t, selfv )
    end if

    Terminate( c, MTERM_RET, -1, -1, NoVal( ) )
    c.f = savedF
    c.curBlock = savedB
end sub

'' Every implicit structor this unit needs. Called once, after the written procedures
'' are lowered, so a written structor of a base is already there to be called.
''
'' Repeated until nothing new appears: emitting one may call another that did not exist
'' when the walk started -- a field's, or a base's.
sub EmitImplicitStructors( byref c as Ctx )
    if (c.vts = 0) orelse (c.udts = 0) then return

    '' ON DEMAND, and the demand grows as the bodies are written: a constructor emitted
    '' here may call a field's or a base's, which was not wanted when the walk started.
    '' The list is append-only and the index carries over, so each entry is visited once
    '' however many rounds it takes.
    dim as long at = 0
    dim as long guard = 0
    while (at < c.implWantedType.Count) andalso (guard < 100000)
        guard += 1
        dim as Fbx.TypeId t = cast( Fbx.TypeId, c.implWantedType[at] )
        dim as boolean isCtor = (c.implWantedKind[at] = 1)
        at += 1
        if t = Fbx.TYPE_NONE then continue while
        if c.udts->Find( t ) < 0 then continue while
        '' OBJECT'S OWN STRUCTORS ARE THE RUNTIME'S, not this module's.
        if IsObjectT_( c, t ) then continue while
        '' A WRITTEN ONE WINS. fbc prepends the same body to it rather than emitting a
        '' second function, and that is done where it is lowered.
        if isCtor then
            if StructorWithArity( c, StructorOf( c, t, "__ctor" ), 0 ) <> Fbx.SYMBOL_NONE then
                continue while
            end if
        else
            if StructorWithArity( c, StructorOf( c, t, "__dtor" ), 0 ) <> Fbx.SYMBOL_NONE then
                continue while
            end if
        end if
        EmitOneImplicit_( c, t, isCtor )
    wend
end sub

end namespace
