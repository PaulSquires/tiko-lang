'' 'defer' IS A CONTEXTUAL KEYWORD, and was being claimed unconditionally.
''
'' FBC-Modern does not reserve it, and generics/defer.bas says so in as many words:
'' 'everything below is a program that predates the feature and must keep compiling and
'' behaving identically'. Claimed at the head of a statement whatever followed,
'' 'defer = 4' parsed as DEFER of a statement beginning with '=' and died on it.
''
'' The rule is the one that file states -- the keyword is claimed only when what follows
'' BEGINS A STATEMENT -- and it is tested from the other end, because the list of things
'' that follow a VARIABLE of that name is short and closed: an assignment, or a compound
'' one.
''
'' THE CORPUS FILE'S WARNING IS ABOUT FBC'S LEXER, NOT THIS ONE. It says '+=' lexes as
'' '+' then '=', so a reject-list spelled '+=' would match nothing. True of fbc, and NOT
'' of tiko-lang, which has TK_PLUSEQ and its six siblings -- so both spellings are
'' rejected here: the fused tokens because that is what this lexer produces, and
'' '<op> =' because the KEYWORD operators, 'shl=' and 'mod=', have no fused token.
dim as string log_

sub useDefer( byref l as string )
    defer l &= "[deferred]"
    l &= "body"
end sub

'' ...and the same word as an ordinary local
scope
    dim defer as long = 3
    defer = 4
    print defer
    defer += 5
    print defer
    defer -= 1
    print defer
    defer *= 2
    print defer
end scope

useDefer( log_ )
print log_
