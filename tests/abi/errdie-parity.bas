'' errdie-parity.bas -- the UNHANDLED path: fb_Die's message and exit code.
''
'' NEEDS-GEN-LLVM
''
'' THIS PROGRAM IS SUPPOSED TO DIE. errthrow-parity.bas installs a handler for
'' every case, which means fb_Die's message assembly -- the preposition, the
'' message table, the line number, the module and function names -- is never
'' reached there. It is reached here, and the comparison is the text on stderr
'' plus the exit code.
''
'' build/diff.sh reports this as "exited non-zero on BOTH sides", which is the
'' correct reading: identical failure is identical behaviour, and the note
'' exists so an identical CRASH is never mistaken for an identical pass.

extern "c"
	declare function pThrowMsg alias "fb_ErrorThrowMsg" ( byval e as long, byval l as long, byval m as zstring ptr, byval msg as zstring ptr, byval r as any ptr, byval rn as any ptr ) as any ptr
end extern

print "before"
'' No handler installed: this formats the message, publishes it through
'' __fb_ctx.errmsg and ends the program. Nothing after it runs.
pThrowMsg( 6, 42, @"themodule", @"the detail", 0, 0 )
print "after -- must not appear"
