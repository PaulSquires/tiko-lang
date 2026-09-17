'' A 'dim' THAT SHADOWS AN OUTER NAME IS NOT VISIBLE TO THE STATEMENTS ABOVE IT.
'' Measured on fbc-modern, with 'dim as long v = 11' outside: 'print v' written before
'' 'dim as long v = 22' prints 11 -- inside a SELECT CASE arm, an IF, a SCOPE, a FOR
'' body, and over a procedure's own parameter, with STATIC in place of DIM as well.
''
'' tiko-lang bound every one of those to the INNER variable, because Collect declares a
'' whole block before Resolve walks any of it. The statements above the 'dim' then read
'' a slot nothing has written yet: tiko-editor's WM_COMMAND handler dereferenced an
'' uninitialised clsDocument ptr eight lines above the shadowing declaration that made
'' it, which is fault eleven.
''
'' THE GOLDEN IS THE ASSERTION -- WHICH SLOT each read names. An inner declaration
'' appears as its own local ('v$1', 'v$2', ...) and the outer one keeps the bare name,
'' so a read bound the wrong way is visible as the wrong operand and nothing else
'' changes. tests/mir does not run what it builds, and a runtime difference here is a
'' read of uninitialised storage, which is not a thing to assert on anyway.

dim shared as long sink

'' ---- 1. a SELECT CASE arm, over a module-level variable ----------------------
dim as long v = 11
select case v
case 11
    sink = v                '' the OUTER v
    dim as long v = 22
    sink = v                '' the inner one
end select

'' ---- 2. the initializer SEES ITSELF -- 'dim as long w = w + 1' over an outer w
''         prints 1 under fbc, so visibility starts AT the declaration, not after it.
dim as long w = 11
scope
    dim as long w = w + 1
    sink = w
end scope

'' ---- 3. a block inside a procedure, over that procedure's PARAMETER ----------
sub Inner_( byval p as long )
    scope
        sink = p            '' the PARAMETER
        dim as long p = 33
        sink = p
    end scope
end sub

'' ---- 4. STATIC shadows the same way DIM does --------------------------------
dim as long s = 11
if s = 11 then
    sink = s                '' the outer s -- and so does the CONDITION above it
    static as long s = 44
    sink = s
end if

'' ---- 5. NOT A SHADOW, so nothing changes: the only 'u' there is is this one --
scope
    dim as long u = 55
    sink = u
end scope
