'' A FIXED ARRAY OF VAR-LENGTH STRINGS, both ends of its life.
''
'' Neither end was lowered. The array was never zeroed, so the first assignment into
'' an element handed fb_StrAssign a GARBAGE DESCRIPTOR TO RELEASE -- a free of
'' whatever the stack happened to hold -- and nothing destructed it, so every buffer
'' it did end up owning leaked at scope exit. Both halves verified and reported
'' "0 statements not lowered" while doing it.
''
'' A BRACE INITIALISER over one is not a store either: the 24 bytes of an element are
'' a descriptor, so it is one fb_StrInit per element. That shape lowers as an
'' aggregate, which the array-initialiser path rejected outright -- the initialiser
'' was dropped whole and the array read back empty.
''
'' Measured, from fbc's C output:
''
''   __builtin_memset( (FBSTRING*)S$0, 0, 48ll );
''   fb_StrInit( (void*)S$0, -1ll, (void*)"abcdef", 7ll, 0 );
''   fb_StrInit( (void*)((int64)(FBSTRING*)S$0 + 24ll), -1ll, (void*)"ghijkl", 7ll, 0 );
''   fb_ArrayDestructStr( (struct $7FBARRAYIvE*)&tmp$2$0 );
''
'' -- and a ustring array takes fb_ArrayDestructUStr, a SEPARATE entry point. The two
'' descriptors are the same size, so calling the narrow one over UTF-16 lowered,
'' verified, and released the wrong thing.
scope
    dim as string bare(0 to 1)
    bare(0) = "a"
    print bare(0)
end scope

scope
    dim as string s(0 to 1) = { "abcdef", "ghijkl" }
    print s(0); s(1)
end scope

scope
    dim as ustring u(0 to 1)
    u(0) = "a"
    print u(0)
end scope
