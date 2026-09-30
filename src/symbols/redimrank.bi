'' redimrank.bi -- THE RANK A REDIM GIVES a rank-0 dynamic array.
''
'' 'dim a( ) as integer' declares an array whose rank is not known, and its FIRST redim
'' fixes it: 'redim a( 0 to 0 )' makes it one-dimensional, and a later 'a( 0, 0 )' or a
'' second 'redim a( 0 to 0, 0 to 0 )' is fbc's error 36. Two passes need that: Visibility
'' records every first redim up front and judges the later ones, and overload resolution
'' asks about one symbol when an array argument of unknown rank meets overloads that
'' differ by rank -- overload/bydesc.bas calls 'f( array( )' after 'redim array( 0 to 0 )'
'' and fbc binds the one-dimensional 'f'.

#ifndef TKO_REDIMRANK_BI
#define TKO_REDIMRANK_BI

#include once "ast/nodes.bi"
#include once "symbols/symbol.bi"
#include once "symbols/resolve.bi"
#include once "types/type.bi"

namespace Tko.RedimRank

    '' The rank one REDIM item writes, with the rank-0 dynamic array it redims in 'sid'.
    '' 0 and SYMBOL_NONE when the item is anything else.
    declare function ItemRank _
        ( byref ast as AstArena, byref syms as SymbolTable, byref types as TypeContext, _
          byref info as SemanticInfo, byval item as NodeId, byref sid as SymbolId, _
          byval scope_ as ScopeId = SCOPE_NONE ) as long

    '' The rank the FIRST redim of 'target', in source order, gives it -- or 0.
    declare function FirstRank _
        ( byref ast as AstArena, byref syms as SymbolTable, byref types as TypeContext, _
          byref info as SemanticInfo, byval target as SymbolId ) as long

end namespace

#endif
