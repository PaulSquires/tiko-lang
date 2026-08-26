'' 'var (a, b) = expr' -- the DESTRUCTURING DECLARATION, which had no parse at all: the
'' '(' was read where a name belongs and the whole statement died with "expected an
'' identifier". The ASSIGNMENT form '(a, b) = expr' already worked; only the declaring
'' form was missing, and tuple/destructure.bas is fifteen declines of it.
''
'' Desugared in the parser into ONE 'var' with N+1 items --
''
''     var $dt1 = expr, a = $dt1._1, b = $dt1._2
''
'' -- a shape every later pass already handles completely. The items of one 'var' are
'' declared in order, so the temporary is typed before the names that read it; each
'' name gets its own inferred type from the element it is initialised from; and a
'' STRING element is copy-initialised by the ordinary declaration path, so it owns its
'' data rather than viewing the temporary's.
''
'' ONCE-ONLY EVALUATION comes with the shape: 'expr' is written exactly once, in the
'' temporary's initialiser, so a CALL on the right runs once however many names are on
'' the left. Two 'var (...)' in one scope must not share a temporary either, which is
'' what the counter in the generated name is for.
dim shared as long calls

declare function counted( ) as (long, long)

scope
    var (lo, hi) = (3, 4)
    print lo, hi

    '' really a long, not a tuple
    lo += 1
    print lo

    '' three elements
    var (a, b, c) = (1, 2, 3)
    print a + b + c
end scope

scope
    dim v as (long, string)
    v._1 = 1 : v._2 = "from-var"
    var (n, s) = v
    print n, s

    '' really a STRING, and it owns its data
    s &= "!"
    print s
end scope

scope
    calls = 0
    var (p, q) = counted( )
    print calls, p, q
end scope

end

private function counted( ) as (long, long)
    calls += 1
    return (20, 22)
end function
