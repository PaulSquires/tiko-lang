'' lprint-parity.bas -- the LPRINT family. Fifteen entry points across eleven fbc
'' members.
''
'' NEEDS-GEN-LLVM
'' NEEDS-LANG-FBLITE
''
'' WHAT THIS TEST DOES NOT COVER, SAID FIRST BECAUSE IT MATTERS MOST:
''
'' It does not check a single byte of LPRINT's OUTPUT. fb_LPrintInit opens the
'' channel at FB_HANDLE_PRINTER with the fixed device string "LPT:EMU=TTY" on
'' Windows and "LPT:" on Linux -- the SYSTEM DEFAULT PRINTER. There is no
'' argument and no way to point it at a file: `OPEN LPT "x.txt" FOR OUTPUT AS #n`
'' opens a different channel that LPRINT never looks at.
''
'' So a differential either prints on a real printer or observes nothing. A first
'' version of this file did the latter -- it opened an LPT channel, ran the whole
'' LPRINT vocabulary through it, read the file back and printed `<no file>`
'' twenty-two times. It PASSED, because both runtimes produced the same nothing.
'' That is the exact failure this project keeps recording, so it is written down
'' rather than quietly replaced.
''
'' WHAT IS LEFT IS STILL WORTH ASSERTING, and it is the half that was deliberately
'' reproduced rather than improved:
''
''   - LPRINT to a printer that cannot be opened PRINTS NOTHING AND DOES NOT
''     RAISE. Every entry point except LPrintUsingInit discards fb_LPrintInit's
''     error code. A version that propagated it would break every program that
''     relies on LPRINT being harmless without a printer, and it would show up
''     here as a non-zero ERR.
''   - LPrintUsingInit is the ONE that propagates, because its return value is
''     what the compiler tests before emitting the rest of the statement.
''   - the whole vocabulary is reachable: every width, both signednesses, both
''     float sizes, strings, fixed strings, wide strings, booleans, USING, SPC
''     and TAB. A missing entry point is a LINK failure, and that is a real check
''     -- it is how the batch's completeness is established.
''
'' The byte-level formatting is covered by print-parity, which exercises the same
'' formatter through the same macro on a channel that can be read back.

dim shared as long e

sub note( byref what as string )
	print "  "; what; " err="; e
end sub

print "-- every entry point is reachable and none of them raises"

err = 0 : lprint 42;                        : e = err : note( "int" )
err = 0 : lprint cuint(42);                 : e = err : note( "uint" )
err = 0 : lprint cshort(-300);              : e = err : note( "short" )
err = 0 : lprint cushort(300);              : e = err : note( "ushort" )
err = 0 : lprint cbyte(-7);                 : e = err : note( "byte" )
err = 0 : lprint cubyte(7);                 : e = err : note( "ubyte" )
err = 0 : lprint clngint(-1234567890123);   : e = err : note( "longint" )
err = 0 : lprint culngint(1234567890123);   : e = err : note( "ulongint" )
err = 0 : lprint csng(1.5);                 : e = err : note( "single" )
err = 0 : lprint 1.0/3.0;                   : e = err : note( "double" )
err = 0 : lprint true;                      : e = err : note( "bool" )
err = 0 : lprint "abc";                     : e = err : note( "string" )

dim as zstring * 8 z = "fixed"
err = 0 : lprint z;                         : e = err : note( "fixed string" )
dim as wstring * 8 w = "wide"
err = 0 : lprint w;                         : e = err : note( "wide string" )

err = 0 : lprint                            : e = err : note( "void" )
err = 0 : lprint 1, 2;                      : e = err : note( "comma" )
err = 0 : lprint "a"; spc(3); "b";          : e = err : note( "spc" )
err = 0 : lprint "a"; tab(10); "b";         : e = err : note( "tab" )

print "-- LPRINT USING is the one that propagates"
err = 0 : lprint using "###.##"; 3.14159;   : e = err : note( "using numeric" )
err = 0 : lprint using "&-&"; "a"; "b";     : e = err : note( "using string" )

print "done"
