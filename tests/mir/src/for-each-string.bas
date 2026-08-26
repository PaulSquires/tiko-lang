'' FOR EACH over the two STRING shapes, and 'each' as an ordinary identifier.
''
'' A VAR-LENGTH STRING is a descriptor, not an array, so it never reached the array path
'' at all and declined without being looked at. Measured from fbc: the data pointer and
'' the length are BOTH hoisted once, the limit is 'len - 1' compared with '<=', and an
'' empty string needs no special case -- its limit is -1 and the test-first skeleton
'' runs the body no times. The character is a UBYTE, not a one-character string.
''
'' An ARRAY OF var-length strings lowered to a load and a store, which is the one thing
'' a string element is not: the loop variable owns its own data, so it is COPY-
'' CONSTRUCTED from the element with fb_StrInit and released once per iteration. The
'' release is registered with the body's own scope, so 'exit for' out of the middle
'' releases it too.
''
'' 'each' IS AN ORDINARY IDENTIFIER. 'for each as long = 1 to 3' and 'for each = 4 to 6'
'' are counted loops over a variable that happens to be called that, and fbc compiles
'' both. What separates them from FOR EACH is the NEXT token: the counted form always
'' has AS or '=' after the counter's name and FOR EACH never does.
sub s1( )
    dim as string txt = "abc"
    dim as integer total = 0
    for each ch in txt
        total += ch
    next

    dim as string empty_ = ""
    dim as integer n = 0
    for each ch2 in empty_
        n += 1
    next

    dim strs(0 to 1) as string = { "ab", "cd" }
    dim cat as string = ""
    for each s in strs
        cat += s
    next

    dim as long compat = 0
    for each as long = 1 to 3
        compat += each
    next

    print total, n, cat, compat
end sub

s1( )
