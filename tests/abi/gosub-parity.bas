'' gosub-parity.bas -- GOSUB / RETURN, exercised through the language rather
'' than through the entry points, because the entry points are only meaningful
'' in the call sequence fbc's codegen emits.
''
'' NEEDS-GEN-LLVM
'' NEEDS-LANG-FBLITE -- GOSUB and RETURN do not exist in the default dialect.
''
'' WHAT IS ACTUALLY BEING CHECKED:
''   - nested GOSUB, so more than one node is live at once
''   - a GOSUB whose RETURN never runs, so fb_GosubExit has nodes to free
''   - RETURN out of a loop, and repeated GOSUB in a loop, to make the
''     push/free traffic heavy enough that a use-after-free in fb_GosubReturn
''     would land on reused memory rather than on a still-intact block

'' OPTION GOSUB is required on top of the dialect: fblite still has GOSUB
'' off by default, and the error names the option rather than the dialect.
option gosub

dim shared as long trace_acc

sub run_nested( )
	dim as long i = any
	for i = 1 to 50
		gosub level1
	next
	exit sub

	level1:
		trace_acc += 1
		gosub level2
		trace_acc += 10
		return

	level2:
		trace_acc += 100
		gosub level3
		trace_acc += 1000
		return

	level3:
		trace_acc += 10000
		return
end sub

sub run_abandoned( )
	'' GOSUB, then leave the scope WITHOUT returning: the node is still on
	'' the list and only fb_GosubExit frees it.
	dim as long i = any
	for i = 1 to 20
		gosub deadend
	next
	exit sub

	deadend:
		trace_acc += 7
		if( trace_acc > 0 ) then exit sub
		return
end sub

sub run_loop( )
	dim as long i = any, j = any
	for i = 1 to 200
		gosub body
	next
	exit sub

	body:
		for j = 1 to 3
			trace_acc += j
		next
		return
end sub

trace_acc = 0 : run_nested( )    : print "nested   ="; trace_acc
trace_acc = 0 : run_abandoned( ) : print "abandoned="; trace_acc
trace_acc = 0 : run_loop( )      : print "loop     ="; trace_acc

'' Repeat the whole thing, so any corruption from the first pass shows up.
dim as long k = any
trace_acc = 0
for k = 1 to 25
	run_nested( ) : run_abandoned( ) : run_loop( )
next
print "repeated ="; trace_acc
print "done"
