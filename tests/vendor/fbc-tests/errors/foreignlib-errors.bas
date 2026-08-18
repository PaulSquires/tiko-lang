'' #foreignlib's own diagnostics (RFC-0005).
''
'' The interesting one is the not-found case: it lists every path that was
'' probed, so this file is also the regression net for the variant-selection
'' ORDER and for the per-target os/arch tags and extension sets. The five
'' targets this suite runs produce five different candidate lists from the one
'' source line, which is exactly what should be pinned down.
''
'' test.sh normalises the directory off each probed path, so the goldens show
'' the filenames only and do not churn between machines.

#print === no matching file: dynamic, every candidate listed ===
#foreignlib NOPE dynamic "vendor/nope"

#print === no matching file: static uses a different extension set ===
#foreignlib NOPE static "vendor/nope"

#print === kind is mandatory, never inferred ===
#foreignlib MISSINGKIND "vendor/nope"

#print === kind must be STATIC or DYNAMIC, not something else ===
#foreignlib BADKIND lazy "vendor/nope"

#print === the name must be an identifier ===
#foreignlib "notanidentifier" static "vendor/nope"

#print === a spec must be a string ===
#foreignlib NOSPEC static vendor

#print === an empty spec is not a library ===
#foreignlib EMPTY static ""

#print === LIB naming a binding that was never declared ===
declare function f1 cdecl lib NEVERDECLARED alias "f1" ( ) as long

#print === rebinding a name to a different set ===
#foreignlib DUP dynamic "system:foo"
#foreignlib DUP dynamic "system:bar"

#print === rebinding a name to the SAME set is not an error ===
#foreignlib SAME dynamic "system:foo"
#foreignlib SAME dynamic "system:foo"

#print === declared bindings are usable, and need no file to resolve ===
#foreignlib SYS dynamic "system:foo", "system:bar"
declare function f2 cdecl lib SYS alias "f2" ( ) as long

#print === end ===
