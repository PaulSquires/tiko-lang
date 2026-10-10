'' visctx.bi -- the post-Check pass's context (visibility.bas and the files it includes).
'' Its own header since visibility.bas reached the 1500-line cap.

#pragma once

'' THE SYMBOL TABLE BY FOLDED NAME, for the latesweeps owner-path rules: is there exactly one
'' namespace (one type) of this name, and which scope is it. Those rules ran once per QUALIFIED
'' DECLARATION and scanned every symbol each time -- 'function CWindow.Foo' times all of
'' windows.bi -- which was 1.18 s of PsCalendar's 4.96 s build (speed audit, 2026-10-07).
'' Indexed by folded InternId; built on first use and again whenever the table has grown, so a
'' symbol declared by an earlier sweep is never missed.
type OwnerIndex
    as long                  builtAt = -1   '' symbols.Count when built; -1 = never
    as containers.Array( of long )   nsHits, nsInner, udtHits, udtInner
    as containers.Array( of ubyte )  head           '' a namespace, type or typedef has this name
end type

type Ctx
    as AstArena ptr         ast
    as SymbolTable ptr      syms
    as TypeContext ptr      types
    as Interner ptr         names
    as DiagnosticEngine ptr diags
    as SemanticInfo ptr     info
    as InternId             baseName
    '' THE FIRST REDIM OF A RANK-0 DYNAMIC ARRAY FIXES ITS RANK. 'dim a( )' then
    '' 'redim a( 0 to 0 )' makes a one-dimensional array, and 'a( 0, 0 )' or a second
    '' 'redim a( 0 to 0, 0 to 0 )' after it is fbc error 36 -- five corpus files. Recorded
    '' in source order before the walk, by symbol; consulted by the two rank tests.
    as NodeIdVec             redimSym
    as NodeIdVec             redimRank
    as NodeIdVec             redimItem
    '' The overload each CALLEE node's call chose, indexed by node id -- see
    '' RecordChosenOverloads_. Local to this pass on purpose.
    as NodeIdVec             chosenFor
    as NodeId                root
    '' THE SYMBOL TABLE BY FOLDED NAME, for the owner-path sweeps -- see OwnerIndex.
    as OwnerIndex            owners
end type
