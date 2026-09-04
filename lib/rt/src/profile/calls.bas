'' calls.bas -- the calls profiler: nine entry points over one fbc member.
''
'' EVERY PROFILED PROCEDURE CALL GOES THROUGH BeginProc/EndProc OR
'' BeginCall/EndCall, so everything here is on the hot path of a -profile
'' build. It keeps a per-thread call TREE, not a flat list: each node is a
'' (caller, callee) pair, so the same procedure called from two places is two
'' nodes and the report can attribute time to the caller.
''
'' THE CHILD TABLE IS OPEN-ADDRESSED WITH A NON-UNIT STRIDE. The probe step is
'' PROC_MAX_CHILDREN - hash_index (or 1 when the index is 0), which walks the
'' whole 257-entry table because 257 is prime. A unit stride would cluster; a
'' stride sharing a factor with the size would visit only part of the table.
''
'' TIME IS ACCUMULATED PER PARENT, NOT PER PROCEDURE. hPopCall adds
'' (now - start) into the node for THIS caller, so a procedure's total is the
'' sum over its nodes -- which is what the "Global results" section computes,
'' and why it has to skip recursive nodes to avoid counting a frame twice.
''
'' THE THREAD CONTEXT IS NEVER FREED AT THREAD EXIT. fb_PROFILECTX_Destructor
'' walks the still-open call stack, closes the times, and then LINKS the
'' context into the profiler's list instead of releasing it -- the data has to
'' outlive the thread to appear in the report.

#include once "inc/descriptors.bi"
#include once "inc/profile.bi"
#include once "inc/iolock.bi"
#include once "inc/fmt.bi"
#include once "crt/string.bi"
#include once "crt/stdlib.bi"
#include once "crt/stdio.bi"

'' THE CALL-COUNT FORMAT IS A REPRODUCED fbc BUG, AND IT DIFFERS BY PLATFORM.
''
'' profile_calls.c picks its 64-bit specifier like this:
''
''     #if defined(PRId64)
''         #define fmtlld PRId64                      -- "lld"
''     #elif defined(FB_LL_FMTMOD)
''         #define fmtlld "%12" FB_LL_FMTMOD "d"      -- "%12lld"
''
'' PRId64 expands to the length modifier and conversion WITHOUT a leading
'' '%', so on the first branch fprintf writes the three literal characters
'' "lld" and never formats its argument -- the call count simply does not
'' appear in the report.
''
'' <inttypes.h> is included only under HOST_WIN32, so PRId64 is defined on
'' Windows and undefined on Linux: fbc prints "lld" on Windows and the real
'' count on Linux. Printing the count on both would be more useful and would
'' not match, which is what the differential reported.
''
'' The padding arithmetic follows from it: the caller computes 14 minus what
'' fprintf actually wrote, so Windows pads 11 and Linux pads 2.
#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )
	#define TKORT_FMTLLD @"lld"
#else
	#define TKORT_FMTLLD @"%12lld"
#endif

const MAIN_PROC_NAME    = "(main)"
const THREAD_PROC_NAME  = "(thread)"
const UNNAMED_PROC_NAME = "(unnamed)"

const FB_TLSKEY_PROFILE as long = 6

const PROCINFO_FLAGS_NONE    = 0
const PROCINFO_FLAGS_MAIN    = 1
const PROCINFO_FLAGS_THREAD  = 2
const PROCINFO_FLAGS_CALLPTR = 4
const PROCINFO_FLAGS_FOREIGN = 8

type FB_PROCINFO_
	as zstring ptr      name
	as FB_PROCINFO_ ptr parent
	as double           start_time
	as double           local_time
	as longint          local_count
	as ulong            hashkey
	as long             proc_id
	as FB_PROCINFO_ ptr child( 0 to PROC_MAX_CHILDREN - 1 )
	as FB_PROCINFO_ ptr nxt
	as long             flags
end type

type FB_PROCINFO_TB_
	as FB_PROCINFO_       procinfo( 0 to PROC_INFO_TB_SIZE - 1 )
	as FB_PROCINFO_TB_ ptr nxt
	as long               next_free
	as long               proc_tb_id
end type

type FB_PROCARRAY
	as FB_PROCINFO_ ptr ptr   arr
	as STRING_HASH_           hash_
	as STRING_HASH_TABLE_ ptr ignores
	as long                   nused
	as long                   cap_
end type

type FB_PROFILER_THREAD_
	as FB_PROCINFO_ ptr        thread_entry
	as FB_PROCINFO_ ptr        thread_proc
	as STRING_TABLE            strings
	as STRING_HASH_TABLE_      strings_hash
	as FB_PROCINFO_TB_ ptr     proc_tb
	as FB_PROFILER_THREAD_ ptr nxt
	as long                    last_proc_id
end type

type FB_PROFILECTX
	as FB_PROFILER_THREAD_ ptr ctx
end type

type FB_PROFILER_CALLS
	as FB_PROFILER_GLOBAL ptr  global_
	as FB_PROFILER_THREAD_ ptr main_thread
	as FB_PROFILER_THREAD_ ptr threads
	as FBSTRING                calltree_leader
end type

extern "rtlib"
	declare function fb_TlsGetCtx alias "fb_TlsGetCtx" _
		( byval idx as long, byval length as uinteger, byval dtor as any ptr ) as any ptr
	declare function tkrt_Timer alias "fb_Timer" ( ) as double
	declare function tkrt_ProfileGetFileName alias "fb_ProfileGetFileName" _
		( byval f as zstring ptr, byval l as long ) as long
end extern

'' The calls profiler's own global, distinct from profile/core.bas's
'' fb_profiler -- two files, two statics, and the C has the same shadowing.
dim shared as FB_PROFILER_CALLS ptr calls_profiler = 0

'' Forward-declared because hCtx() passes its address to fb_TlsGetCtx and is
'' defined well above it. NON-FBCALL: fb_profile.h declares it plain.
extern "c"   '' NON-FBCALL: the TLS destructor carries no FBCALL marker.
	declare sub tkort_PROFILECTX_Destructor alias "fb_PROFILECTX_Destructor" ( byval data_ as any ptr )
end extern

private function hCtx( ) as FB_PROFILECTX ptr
	'' The destructor is passed here, so the runtime calls it at thread exit
	'' -- that is what links a finished thread's data into the report.
	return cptr( FB_PROFILECTX ptr, _
		fb_TlsGetCtx( FB_TLSKEY_PROFILE, sizeof( FB_PROFILECTX ), _
		              cast( any ptr, @tkort_PROFILECTX_Destructor ) ) )
end function

private function hThreadAddString( byval ctx as FB_PROFILER_THREAD_ ptr, _
                                   byval src as zstring ptr, byval hashkey as ulong ) as zstring ptr
	dim as STRING_INFO ptr info = STRING_HASH_TABLE_add( @ctx->strings_hash, src, hashkey )
	return cptr( zstring ptr, info + 1 )
end function

private sub hProcTbDestructor( byval tb as FB_PROCINFO_TB_ ptr )
	dim as FB_PROCINFO_TB_ ptr nxt = any
	while( tb <> 0 )
		nxt = tb->nxt
		free( tb )
		tb = nxt
	wend
end sub

'' Bump-allocate one node. A NEW BLOCK IS PUSHED ON THE FRONT and numbered one
'' higher, so ids increase toward the head -- the reverse of the arena in
'' profile/core.bas, which numbers the same way but is walked for a different
'' purpose.
private function hProcTbAllocProc( byval proc_tb as FB_PROCINFO_TB_ ptr ptr ) as FB_PROCINFO_ ptr
	dim as FB_PROCINFO_TB_ ptr tb = any
	dim as FB_PROCINFO_ ptr proc = any

	if( (*proc_tb = 0) orelse ((*proc_tb)->next_free >= PROC_INFO_TB_SIZE) ) then
		tb = calloc( 1, sizeof( FB_PROCINFO_TB_ ) )
		'' Not checked for NULL here -- fbc does not either, and the very
		'' next line would fault. Reproduced rather than hardened, because
		'' adding a check changes what happens under exhaustion.
		tb->nxt = *proc_tb
		if( *proc_tb <> 0 ) then
			tb->proc_tb_id = (*proc_tb)->proc_tb_id + 1
		else
			tb->proc_tb_id = 1
		end if
		*proc_tb = tb
	end if

	proc = @(*proc_tb)->procinfo((*proc_tb)->next_free)
	(*proc_tb)->next_free += 1
	return proc
end function

private function hThreadAllocProc( byval ctx as FB_PROFILER_THREAD_ ptr ) as FB_PROCINFO_ ptr
	return hProcTbAllocProc( @ctx->proc_tb )
end function

'' ------------------------------------------------------------- proc arrays

private sub hArrCtor( byval lst as FB_PROCARRAY ptr, byval strings_hash as STRING_HASH_TABLE_ ptr, _
                      byval ignores as STRING_HASH_TABLE_ ptr )
	lst->arr = 0
	lst->cap_ = 0
	lst->nused = 0
	STRING_HASH_constructor( @lst->hash_, strings_hash )
	lst->ignores = ignores
end sub

private sub hArrDtor( byval lst as FB_PROCARRAY ptr )
	STRING_HASH_destructor( @lst->hash_ )
	free( lst->arr )
	lst->arr = 0
	lst->cap_ = 0
	lst->nused = 0
	lst->ignores = 0
end sub

'' Grows 16, then doubling. Adding also records the name in the array's own
'' hash, which is what makes find_unique_procs able to skip duplicates.
private sub hArrAdd( byval lst as FB_PROCARRAY ptr, byval proc as FB_PROCINFO_ ptr )
	dim as FB_PROCINFO_ ptr ptr new_array = 0
	dim as long s = lst->cap_

	if( s = 0 ) then
		s = 16
		new_array = malloc( s * sizeof( any ptr ) )
	elseif( lst->nused = s ) then
		s *= 2
		new_array = realloc( lst->arr, s * sizeof( any ptr ) )
	else
		new_array = lst->arr
	end if

	if( new_array <> 0 ) then
		new_array[lst->nused] = proc
		lst->arr = new_array
		lst->cap_ = s
		lst->nused += 1
		STRING_HASH_add( @lst->hash_, proc->name, proc->hashkey )
	end if
end sub

'' ROOTS SORT FIRST, then by name -- a node with no parent is the thread entry
'' and has to head its section. Two roots compare equal, so their relative
'' order is whatever the sort leaves.
private function hNameSorter cdecl( byval e1 as any ptr, byval e2 as any ptr ) as long
	dim as FB_PROCINFO_ ptr p1 = *cptr( FB_PROCINFO_ ptr ptr, e1 )
	dim as FB_PROCINFO_ ptr p2 = *cptr( FB_PROCINFO_ ptr ptr, e2 )

	if( (p1->parent <> 0) andalso (p2->parent <> 0) ) then
		return strcmp( p1->name, p2->name )
	elseif( (p1->parent = 0) andalso (p2->parent <> 0) ) then
		return -1
	elseif( (p1->parent <> 0) andalso (p2->parent = 0) ) then
		return 1
	end if
	return 0
end function

private sub hArrSortByName( byval lst as FB_PROCARRAY ptr )
	qsort( lst->arr, lst->nused, sizeof( any ptr ), cast( any ptr, @hNameSorter ) )
end sub

'' DESCENDING by time -- the slowest first.
private function hTimeSorter cdecl( byval e1 as any ptr, byval e2 as any ptr ) as long
	dim as FB_PROCINFO_ ptr p1 = *cptr( FB_PROCINFO_ ptr ptr, e1 )
	dim as FB_PROCINFO_ ptr p2 = *cptr( FB_PROCINFO_ ptr ptr, e2 )
	if( p1->local_time > p2->local_time ) then return -1
	if( p1->local_time < p2->local_time ) then return 1
	return 0
end function

private sub hArrSortByTime( byval lst as FB_PROCARRAY ptr )
	qsort( lst->arr, lst->nused, sizeof( any ptr ), cast( any ptr, @hTimeSorter ) )
end sub

private sub hFindAllProcs( byval lst as FB_PROCARRAY ptr, byval proc_tb as FB_PROCINFO_TB_ ptr )
	dim as FB_PROCINFO_TB_ ptr tb = proc_tb
	dim as FB_PROCINFO_ ptr proc = any
	dim as long i = any
	while( tb <> 0 )
		for i = 0 to tb->next_free - 1
			proc = @tb->procinfo(i)
			if( STRING_HASH_TABLE_find( lst->ignores, proc->name, proc->hashkey ) = 0 ) then
				hArrAdd( lst, proc )
			end if
		next
		tb = tb->nxt
	wend
end sub

'' Same walk, but skips a name already in THIS array's hash -- so one entry per
'' distinct procedure rather than one per (caller, callee) pair.
private sub hFindUniqueProcs( byval lst as FB_PROCARRAY ptr, byval proc_tb as FB_PROCINFO_TB_ ptr )
	dim as FB_PROCINFO_TB_ ptr tb = proc_tb
	dim as FB_PROCINFO_ ptr proc = any
	dim as long i = any
	while( tb <> 0 )
		for i = 0 to tb->next_free - 1
			proc = @tb->procinfo(i)
			if( STRING_HASH_TABLE_find( lst->ignores, proc->name, proc->hashkey ) = 0 ) then
				if( STRING_HASH_find( @lst->hash_, proc->name, proc->hashkey ) = 0 ) then
					hArrAdd( lst, proc )
				end if
			end if
		next
		tb = tb->nxt
	wend
end sub

'' ------------------------------------------------ thread context lifecycle

private sub hThreadCtor( byval ctx as FB_PROFILER_THREAD_ ptr )
	if( ctx = 0 ) then exit sub
	ctx->thread_entry = 0
	ctx->thread_proc = 0
	STRING_TABLE_constructor( @ctx->strings )
	STRING_HASH_TABLE_constructor( @ctx->strings_hash, @ctx->strings )
	ctx->proc_tb = 0
	ctx->nxt = 0
	ctx->last_proc_id = 0
end sub

private sub hProfileCtxCtor( byval tls as FB_PROFILECTX ptr )
	if( tls->ctx <> 0 ) then exit sub
	tls->ctx = calloc( 1, sizeof( FB_PROFILER_THREAD_ ) )
	hThreadCtor( tls->ctx )
end sub

extern "c"   '' NON-FBCALL: the TLS destructor, declared plain in fb_profile.h.

'' DOES NOT FREE THE CONTEXT. It closes the open call stack's times and then
'' links the whole thing into the profiler's thread list, because the data has
'' to survive the thread to appear in the report. Freeing here loses every
'' spawned thread's results.
sub tkort_PROFILECTX_Destructor alias "fb_PROFILECTX_Destructor" ( byval data_ as any ptr )
	dim as FB_PROFILECTX ptr tls = cptr( FB_PROFILECTX ptr, data_ )
	dim as FB_PROFILER_THREAD_ ptr ctx = any
	dim as FB_PROCINFO_ ptr lastproc = any

	if( tls = 0 ) then exit sub
	ctx = tls->ctx
	if( ctx = 0 ) then exit sub

	'' Walk UP the stack so a thread that ends inside a call still gets a
	'' time for every frame it was in.
	lastproc = ctx->thread_proc
	while( lastproc <> 0 )
		lastproc->local_time = tkrt_Timer( ) - lastproc->start_time
		lastproc = lastproc->parent
	wend

	if( calls_profiler <> 0 ) then
		TKORT_PROFLOCK()
		ctx->nxt = calls_profiler->threads
		calls_profiler->threads = ctx
		TKORT_PROFUNLOCK()
	end if
end sub

end extern

'' ------------------------------------------------------------------ metrics

private sub hMetricsProcs( byval metrics as FB_PROFILER_METRICS ptr, _
                           byval proc_tb as FB_PROCINFO_TB_ ptr )
	dim as FB_PROCINFO_TB_ ptr tb = any
	dim as long i = any
	if( metrics = 0 ) then exit sub
	if( proc_tb = 0 ) then exit sub
	tb = proc_tb
	while( tb <> 0 )
		metrics->procs_bytes_allocated += sizeof( FB_PROCINFO_TB_ )
		metrics->procs_count_blocks += 1
		'' Counts EVERY slot in the block, not just the used ones -- an
		'' occupancy figure, which is what the debug report prints.
		for i = 0 to PROC_INFO_TB_SIZE - 1
			if( tb->procinfo(i).name <> 0 ) then metrics->procs_count_items += 1
			metrics->procs_count_slots += 1
		next
		tb = tb->nxt
	wend
end sub

private sub hMetricsThreads( byval metrics as FB_PROFILER_METRICS ptr, _
                             byval ctx as FB_PROFILER_THREAD_ ptr )
	if( metrics = 0 ) then exit sub
	if( ctx = 0 ) then exit sub
	metrics->nthreads += 1
	fb_hPROFILER_METRICS_Strings( metrics, @ctx->strings )
	fb_hPROFILER_METRICS_HashTable( metrics, @ctx->strings_hash )
	hMetricsProcs( metrics, ctx->proc_tb )
end sub

private sub hMetricsCallsProfiler( byval metrics as FB_PROFILER_METRICS ptr, _
                                   byval prof as FB_PROFILER_CALLS ptr )
	dim as FB_PROFILER_THREAD_ ptr ctx = any
	if( prof = 0 ) then exit sub
	if( metrics = 0 ) then exit sub

	fb_hPROFILER_METRICS_Clear( metrics )
	fb_hPROFILER_METRICS_Global( metrics, prof->global_ )
	hMetricsThreads( metrics, prof->main_thread )

	ctx = prof->threads
	while( ctx <> 0 )
		hMetricsThreads( metrics, ctx )
		ctx = ctx->nxt
	wend
end sub

'' ---------------------------------------------------------- calls lifecycle

private function hCallsCreate( ) as FB_PROFILER_CALLS ptr
	dim as FB_PROFILER_CALLS ptr prof = any
	if( calls_profiler <> 0 ) then return calls_profiler

	prof = calloc( 1, sizeof( FB_PROFILER_CALLS ) )
	if( prof = 0 ) then return calls_profiler

	prof->global_ = PROFILER_GLOBAL_create( )
	if( prof->global_ <> 0 ) then
		'' The two profilers point at each other: the global holds an opaque
		'' back-pointer so a report can find the calls profiler from it.
		prof->global_->profiler_ctx = prof
		prof->calltree_leader.data = 0
		prof->calltree_leader.size = 0
		prof->calltree_leader.len = 0
		calls_profiler = prof
	else
		free( prof )
	end if
	return calls_profiler
end function

private sub hCallsDestroy( )
	dim as FB_PROFILER_THREAD_ ptr nxt_ctx = any
	if( calls_profiler = 0 ) then exit sub

	free( calls_profiler->calltree_leader.data )

	'' Only the LINKED threads are freed here; the main thread's context
	'' belongs to TLS and is released with it.
	while( calls_profiler->threads <> 0 )
		hProcTbDestructor( calls_profiler->threads->proc_tb )
		STRING_HASH_TABLE_destructor( @calls_profiler->threads->strings_hash )
		STRING_TABLE_destructor( @calls_profiler->threads->strings )
		nxt_ctx = calls_profiler->threads->nxt
		free( calls_profiler->threads )
		calls_profiler->threads = nxt_ctx
	wend

	PROFILER_GLOBAL_destroy( )
	free( calls_profiler )
	calls_profiler = 0
end sub

private function hNewProcId( byval ctx as FB_PROFILER_THREAD_ ptr ) as long
	ctx->last_proc_id += 1
	return ctx->last_proc_id
end function

'' ------------------------------------------------------------- the report
''
'' EVERY COLUMN IS PADDED BY MEASURING WHAT fprintf ACTUALLY WROTE. The idiom
'' is `len = col - fprintf(...)` followed by pad_spaces(len) -- so a name longer
'' than the column pushes the rest right instead of being truncated, and a
'' negative len pads nothing. Computing the width from strlen instead would
'' differ wherever fprintf's own conversion differs from the source string.

private sub hPadSpaces( byval f as FILE ptr, byval length_ as long )
	dim as long i = length_
	while( i > 0 )
		fprintf( f, @" " )
		i -= 1
	wend
end sub

'' A file-scope "have we written a section yet" flag: the FIRST section gets no
'' leading blank lines and every later one gets two. It is never reset, so a
'' second report in one process starts glued to the first -- fbc's behaviour.
dim shared as long hSectionStarted = 0

private sub hPadSection( byval f as FILE ptr )
	if( hSectionStarted <> 0 ) then
		fprintf( f, @!"\n\n" )
	else
		hSectionStarted = 1
	end if
end sub

private function hProcIsRecursive( byval proc as FB_PROCINFO_ ptr ) as long
	dim as FB_PROCINFO_ ptr p = proc
	if( p = 0 ) then return 0
	p = p->parent
	while( p <> 0 )
		if( (p->hashkey = proc->hashkey) andalso (strcmp( p->name, proc->name ) = 0) ) then
			return -1
		end if
		p = p->parent
	wend
	return 0
end function

'' PROFILE_OPTION_REPORT_CALLS, one parent and its children.
private sub hReportCallsProc( byval prof as FB_PROFILER_CALLS ptr, _
                              byval ctx as FB_PROFILER_THREAD_ ptr, byval f as FILE ptr, _
                              byval parent_proc as FB_PROCINFO_ ptr, byval col as long )
	dim as FB_PROCINFO_ ptr proc = any
	dim as FB_PROCARRAY proc_list = any
	dim as long j = any, length_ = any
	dim as long opts = prof->global_->options

	hArrCtor( @proc_list, @prof->global_->strings_hash, @prof->global_->ignores_hash )

	'' Children live in the node AND in every overflow node chained off it.
	proc = parent_proc
	while( proc <> 0 )
		for j = 0 to PROC_MAX_CHILDREN - 1
			if( proc->child(j) <> 0 ) then
				if( STRING_HASH_TABLE_find( proc_list.ignores, proc->child(j)->name, _
				                            proc->child(j)->hashkey ) = 0 ) then
					hArrAdd( @proc_list, proc->child(j) )
				end if
			end if
		next
		proc = proc->nxt
	wend

	if( proc_list.nused > 0 ) then
		if( (opts and PROFILE_OPTION_HIDE_TITLES) = 0 ) then
			if( (parent_proc->flags and PROCINFO_FLAGS_THREAD) <> 0 ) then
				fprintf( f, @!"(thread)\n" )
			end if
		end if

		length_ = col - fprintf( f, @"%s", parent_proc->name )
		hPadSpaces( f, length_ )

		if( (opts and PROFILE_OPTION_HIDE_COUNTS) = 0 ) then
			length_ = 14 - fprintf( f, TKORT_FMTLLD, parent_proc->local_count )
			hPadSpaces( f, length_ )
		end if

		if( (opts and PROFILE_OPTION_HIDE_TIMES) = 0 ) then
			length_ = 14 - fprintf( f, @"%10.5f", parent_proc->local_time )
			hPadSpaces( f, length_ )
			'' Percentage of the THREAD's total, not of the parent.
			fprintf( f, @"%6.2f%%", (parent_proc->local_time * 100.0) / ctx->thread_entry->local_time )
		end if

		fprintf( f, @!"\n\n" )

		hArrSortByTime( @proc_list )

		for j = 0 to proc_list.nused - 1
			proc = proc_list.arr[j]

			length_ = col - fprintf( f, @"        %s", proc->name )
			hPadSpaces( f, length_ )

			if( (opts and PROFILE_OPTION_HIDE_COUNTS) = 0 ) then
				length_ = 14 - fprintf( f, TKORT_FMTLLD, proc->local_count )
				hPadSpaces( f, length_ )
			end if

			if( (opts and PROFILE_OPTION_HIDE_TIMES) = 0 ) then
				length_ = 14 - fprintf( f, @"%10.5f", proc->local_time )
				hPadSpaces( f, length_ )
				length_ = 10 - fprintf( f, @"%6.2f%%", (proc->local_time * 100.0) / ctx->thread_entry->local_time )
				hPadSpaces( f, length_ )
				'' Guarded against a zero parent time, which happens when
				'' the parent never returned.
				if( parent_proc->local_time > 0.0 ) then
					fprintf( f, @"%6.2f%%", (proc->local_time * 100.0) / parent_proc->local_time )
				else
					fprintf( f, @"%6.2f%%", 0.0 )
				end if
			end if

			fprintf( f, @!"\n" )
		next

		fprintf( f, @!"\n" )
	end if

	hArrDtor( @proc_list )
end sub

private sub hReportCallsFunctions( byval prof as FB_PROFILER_CALLS ptr, _
                                   byval ctx as FB_PROFILER_THREAD_ ptr, byval f as FILE ptr )
	dim as FB_PROCARRAY lst = any
	dim as long i = any, length_ = any
	dim as long max_len = STRING_TABLE_max_len( @ctx->strings )
	dim as long col = any
	dim as long opts = prof->global_->options

	'' The column is the longest name plus the 8-space indent plus one, with
	'' a floor of 20 so a short report still lines up.
	col = max_len + 8 + 1
	if( col < 20 ) then col = 20

	if( (opts and PROFILE_OPTION_HIDE_TITLES) = 0 ) then
		hPadSection( f )
		fprintf( f, @!"Per function results:\n\n" )
		length_ = col - fprintf( f, @"        Function:" )
		hPadSpaces( f, length_ )
		if( (opts and PROFILE_OPTION_HIDE_COUNTS) = 0 ) then
			fprintf( f, @"      Count:  " )
		end if
		if( (opts and PROFILE_OPTION_HIDE_TIMES) = 0 ) then
			fprintf( f, @"     Time:    " )
			fprintf( f, @"Total%%:    " )
			fprintf( f, @"Proc%%:" )
		end if
		fprintf( f, @!"\n\n" )
	end if

	hArrCtor( @lst, @prof->global_->strings_hash, @prof->global_->ignores_hash )
	hFindUniqueProcs( @lst, ctx->proc_tb )
	hArrSortByName( @lst )
	for i = 0 to lst.nused - 1
		hReportCallsProc( prof, ctx, f, lst.arr[i], col )
	next
	hArrDtor( @lst )
end sub

'' PROFILE_OPTION_REPORT_CALLS, the per-procedure totals.
''
'' RECURSIVE NODES CONTRIBUTE ZERO TIME. A procedure that appears twice on its
'' own call stack has the same wall-clock counted in both frames, so summing
'' every node would exceed the program's runtime. Counts still accumulate --
'' only the time is dropped.
private sub hReportCallsGlobals( byval prof as FB_PROFILER_CALLS ptr, _
                                 byval ctx as FB_PROFILER_THREAD_ ptr, byval f as FILE ptr )
	dim as FB_PROCINFO_TB_ ptr tb = 0
	dim as FB_PROCARRAY list_all = any, lst = any
	dim as FB_PROCINFO_ ptr last_p = 0, p = any, q = any, proc = any
	dim as long i = any, length_ = any
	dim as long max_len = STRING_TABLE_max_len( @ctx->strings )
	dim as long col = any
	dim as long opts = prof->global_->options

	col = max_len + 8 + 1
	if( col < 20 ) then col = 20

	if( (opts and PROFILE_OPTION_HIDE_TITLES) = 0 ) then
		hPadSection( f )
		fprintf( f, @!"Global results:\n\n" )
	end if

	hArrCtor( @lst, @prof->global_->strings_hash, @prof->global_->ignores_hash )
	hArrCtor( @list_all, @prof->global_->strings_hash, @prof->global_->ignores_hash )
	hFindAllProcs( @list_all, ctx->proc_tb )
	hArrSortByName( @list_all )

	'' Sorted by name, so equal names are adjacent and can be merged in one
	'' pass -- the merge target is a THROWAWAY block chain freed below.
	for i = 0 to list_all.nused - 1
		q = list_all.arr[i]
		if( (last_p = 0) orelse (last_p->hashkey <> q->hashkey) orelse _
		    (strcmp( last_p->name, q->name ) <> 0) ) then
			p = hProcTbAllocProc( @tb )
			if( p <> 0 ) then
				p->name = q->name
				p->hashkey = q->hashkey
				if( hProcIsRecursive( q ) = 0 ) then
					p->local_time = q->local_time
				else
					p->local_time = 0
				end if
				p->local_count = q->local_count
				hArrAdd( @lst, p )
			end if
			last_p = p
		else
			if( hProcIsRecursive( q ) = 0 ) then
				last_p->local_time += q->local_time
			end if
			last_p->local_count += q->local_count
		end if
	next

	for i = 0 to lst.nused - 1
		proc = lst.arr[i]
		length_ = col - fprintf( f, @"%s", proc->name )
		hPadSpaces( f, length_ )

		if( (opts and PROFILE_OPTION_HIDE_COUNTS) = 0 ) then
			length_ = 14 - fprintf( f, TKORT_FMTLLD, proc->local_count )
			hPadSpaces( f, length_ )
		end if

		if( (opts and PROFILE_OPTION_HIDE_TIMES) = 0 ) then
			length_ = 14 - fprintf( f, @"%10.5f", proc->local_time )
			hPadSpaces( f, length_ )
			'' The result is COMPUTED AND DISCARDED -- fbc assigns len here
			'' and never pads with it. Kept so the fprintf still happens.
			length_ = 10 - fprintf( f, @"%6.2f%%", (proc->local_time * 100.0) / ctx->thread_entry->local_time )
		end if

		fprintf( f, @!"\n" )
	next

	hProcTbDestructor( tb )
	hArrDtor( @lst )
	hArrDtor( @list_all )
end sub

'' PROFILE_OPTION_REPORT_CALLTREE
''
'' THE LEADER IS A GROWABLE STRING OF THREE-CHARACTER GROUPS. Each level pushes
'' either "|  " or "   " depending on whether the parent was the last child, and
'' hPopLeader removes exactly three. Pushing 0 appends nothing and only
'' re-terminates, which is how the current level is drawn without extending it.
private sub hPushLeader( byval prof as FB_PROFILER_CALLS ptr, byval ch as long )
	dim as integer newsize = any
	dim as zstring ptr newbuffer = any

	if( (prof->calltree_leader.data = 0) orelse _
	    (prof->calltree_leader.len + 4 > prof->calltree_leader.size) ) then
		if( prof->calltree_leader.size <> 0 ) then
			newsize = prof->calltree_leader.size * 2
		else
			newsize = 64
		end if
		newbuffer = realloc( prof->calltree_leader.data, newsize )
		if( newbuffer = 0 ) then exit sub
		prof->calltree_leader.data = newbuffer
		prof->calltree_leader.size = newsize
	end if

	if( prof->calltree_leader.len + 4 > prof->calltree_leader.size ) then exit sub

	if( ch <> 0 ) then
		prof->calltree_leader.data[prof->calltree_leader.len] = ch
		prof->calltree_leader.len += 1
	end if
	prof->calltree_leader.data[prof->calltree_leader.len] = 0
end sub

private sub hPopLeader( byval prof as FB_PROFILER_CALLS ptr )
	if( prof->calltree_leader.data <> 0 ) then
		if( prof->calltree_leader.len >= 3 ) then
			prof->calltree_leader.len -= 3
		end if
		prof->calltree_leader.data[prof->calltree_leader.len] = 0
	else
		prof->calltree_leader.len = 0
	end if
end sub

private sub hReportCallTreeProc( byval prof as FB_PROFILER_CALLS ptr, _
                                 byval ctx as FB_PROFILER_THREAD_ ptr, byval f as FILE ptr, _
                                 byval proc as FB_PROCINFO_ ptr, byval isfirst as long, _
                                 byval islast as long )
	'' ASCII by default; the graphics set is CP437 line-drawing, which is
	'' why they are byte values rather than characters.
	static as ubyte asc_chars(0 to 3) = { 124, 45, 124, 92 }      '' | - | \
	static as ubyte gfx_chars(0 to 3) = { 179, 196, 195, 192 }
	dim as ubyte ptr ch = any
	dim as FB_PROCINFO_ ptr p = any
	dim as long i = any, j = any, children = 0
	dim as FB_PROCARRAY lst = any

	if( (prof->global_->options and PROFILE_OPTION_GRAPHICS_CHARS) <> 0 ) then
		ch = @gfx_chars(0)
	else
		ch = @asc_chars(0)
	end if

	hPushLeader( prof, 0 )

	if( islast ) then
		fprintf( f, @!"%s%c%c %s\n", prof->calltree_leader.data, ch[3], ch[1], proc->name )
	else
		fprintf( f, @!"%s%c%c %s\n", prof->calltree_leader.data, ch[2], ch[1], proc->name )
	end if

	p = proc
	while( p <> 0 )
		for j = 0 to PROC_MAX_CHILDREN - 1
			if( p->child(j) <> 0 ) then children += 1
		next
		p = p->nxt
	wend

	if( children > 0 ) then
		'' A last child's subtree gets blank space where a continuing one
		'' gets the vertical bar.
		if( islast ) then
			hPushLeader( prof, 32 )
		else
			hPushLeader( prof, ch[0] )
		end if
		hPushLeader( prof, 32 )
		hPushLeader( prof, 32 )
	end if

	hArrCtor( @lst, @prof->global_->strings_hash, @prof->global_->ignores_hash )

	p = proc
	while( p <> 0 )
		for j = 0 to PROC_MAX_CHILDREN - 1
			if( p->child(j) <> 0 ) then
				if( STRING_HASH_TB_find( lst.ignores->tb, p->child(j)->name, _
				                         p->child(j)->hashkey ) = 0 ) then
					hArrAdd( @lst, p->child(j) )
				end if
			end if
		next
		p = p->nxt
	wend

	hArrSortByName( @lst )

	for i = 0 to lst.nused - 1
		hReportCallTreeProc( prof, ctx, f, lst.arr[i], iif( i = 0, -1, 0 ), _
		                     iif( i = lst.nused - 1, -1, 0 ) )
	next

	hArrDtor( @lst )

	if( children > 0 ) then hPopLeader( prof )
end sub

private sub hReportCallTree( byval prof as FB_PROFILER_CALLS ptr, _
                             byval ctx as FB_PROFILER_THREAD_ ptr, byval f as FILE ptr )
	if( (prof->global_->options and PROFILE_OPTION_HIDE_TITLES) = 0 ) then
		hPadSection( f )
		fprintf( f, @!"Call Tree:\n\n" )
	end if
	hReportCallTreeProc( prof, ctx, f, ctx->thread_entry, -1, -1 )
end sub

'' PROFILE_OPTION_REPORT_RAWLIST -- every (caller, callee) node, unsorted.
private sub hReportRawList( byval prof as FB_PROFILER_CALLS ptr, _
                            byval ctx as FB_PROFILER_THREAD_ ptr, byval f as FILE ptr )
	dim as long ncol = any, col = any, i = any, max_len = any
	dim as FB_PROCINFO_TB_ ptr tb = any
	dim as FB_PROCINFO_ ptr proc = any
	dim as long opts = prof->global_->options

	max_len = STRING_TABLE_max_len( @ctx->strings )
	'' NO +8 here, unlike the per-function report -- these rows are not
	'' indented, so the column is the bare name width with a floor of 20.
	col = iif( max_len >= 20, max_len, 20 )

	if( (opts and PROFILE_OPTION_HIDE_TITLES) = 0 ) then
		hPadSection( f )
		fprintf( f, @!"List of call data captured:\n\n" )
		fprintf( f, @"    id  " )
		ncol = col - fprintf( f, @"caller (parent)" )
		hPadSpaces( f, ncol )
		fprintf( f, @"    id  " )
		ncol = col - fprintf( f, @"callee" )
		hPadSpaces( f, ncol )
		if( (opts and PROFILE_OPTION_HIDE_COUNTS) = 0 ) then fprintf( f, @"      count:  " )
		if( (opts and PROFILE_OPTION_HIDE_TIMES) = 0 ) then fprintf( f, @"     time:  " )
		fprintf( f, @!"\n\n" )
	end if

	tb = ctx->proc_tb
	while( tb <> 0 )
		for i = 0 to tb->next_free - 1
			proc = @tb->procinfo(i)

			if( proc->parent = 0 ) then
				fprintf( f, @"%6d  ", 0 )
				ncol = col - fprintf( f, @"(root)" )
			else
				fprintf( f, @"%6d  ", proc->parent->proc_id )
				ncol = col - fprintf( f, @"%s", proc->parent->name )
			end if
			hPadSpaces( f, ncol )

			fprintf( f, @"%6d  ", proc->proc_id )
			ncol = col - fprintf( f, @"%s", proc->name )
			hPadSpaces( f, ncol )

			if( (opts and PROFILE_OPTION_HIDE_COUNTS) = 0 ) then
				ncol = 14 - fprintf( f, TKORT_FMTLLD, proc->local_count )
				hPadSpaces( f, ncol )
			end if

			if( (opts and PROFILE_OPTION_HIDE_TIMES) = 0 ) then
				'' 12, not 14, in this report only.
				ncol = 12 - fprintf( f, @"%10.5f", proc->local_time )
				hPadSpaces( f, ncol )
			end if

			fprintf( f, @!"\n" )
		next
		tb = tb->nxt
	wend
end sub

'' PROFILE_OPTION_REPORT_RAWDATA -- the same rows with one level of children.
private sub hReportRawDataProc( byval prof as FB_PROFILER_CALLS ptr, _
                                byval ctx as FB_PROFILER_THREAD_ ptr, byval f as FILE ptr, _
                                byval proc as FB_PROCINFO_ ptr, byval level as long, _
                                byval max_len as long, byval recursion as long )
	dim as long ncol = any, col = any, j = any
	dim as long opts = prof->global_->options

	col = iif( max_len >= 20, max_len, 20 )

	'' The asterisk marks a row that will NOT be expanded -- recursion has
	'' run out. It is on the row that stops, not the one that recurses.
	if( recursion > 0 ) then
		fprintf( f, @"%5d   ", level )
	else
		fprintf( f, @"%5d * ", level )
	end if

	if( proc->parent = 0 ) then
		fprintf( f, @"%6d  ", 0 )
		ncol = col - fprintf( f, @"(root)" )
	else
		fprintf( f, @"%6d  ", proc->parent->proc_id )
		ncol = col - fprintf( f, @"%s", proc->parent->name )
	end if
	hPadSpaces( f, ncol )

	fprintf( f, @"%6d  ", proc->proc_id )
	ncol = col - fprintf( f, @"%s", proc->name )
	hPadSpaces( f, ncol )

	if( (opts and PROFILE_OPTION_HIDE_COUNTS) = 0 ) then
		ncol = 14 - fprintf( f, TKORT_FMTLLD, proc->local_count )
		hPadSpaces( f, ncol )
	end if

	if( (opts and PROFILE_OPTION_HIDE_TIMES) = 0 ) then
		ncol = 14 - fprintf( f, @"%10.5f", proc->local_time )
		hPadSpaces( f, ncol )
	end if

	fprintf( f, @!"\n" )

	if( recursion > 0 ) then
		for j = 0 to PROC_MAX_CHILDREN - 1
			if( proc->child(j) <> 0 ) then
				hReportRawDataProc( prof, ctx, f, proc->child(j), level + 1, max_len, recursion - 1 )
			end if
		next
	end if
end sub

private sub hReportRawData( byval prof as FB_PROFILER_CALLS ptr, _
                            byval ctx as FB_PROFILER_THREAD_ ptr, byval f as FILE ptr )
	dim as long i = any, max_len = any, ncol = any, col = any
	dim as FB_PROCINFO_TB_ ptr tb = any
	dim as FB_PROCINFO_ ptr proc = any
	dim as long opts = prof->global_->options

	max_len = STRING_TABLE_max_len( @ctx->strings )
	col = iif( max_len >= 20, max_len, 20 )

	if( (opts and PROFILE_OPTION_HIDE_TITLES) = 0 ) then
		hPadSection( f )
		fprintf( f, @!"List of call data captured (recursive):\n\n" )
		fprintf( f, @" depth: " )
		fprintf( f, @"    id  " )
		ncol = col - fprintf( f, @"caller (parent)" )
		hPadSpaces( f, ncol )
		fprintf( f, @"    id  " )
		ncol = col - fprintf( f, @"callee" )
		hPadSpaces( f, ncol )
		if( (opts and PROFILE_OPTION_HIDE_COUNTS) = 0 ) then fprintf( f, @"      count:  " )
		if( (opts and PROFILE_OPTION_HIDE_TIMES) = 0 ) then fprintf( f, @"     time:  " )
		fprintf( f, @!"\n\n" )
	end if

	tb = ctx->proc_tb
	while( tb <> 0 )
		for i = 0 to tb->next_free - 1
			proc = @tb->procinfo(i)
			'' recursion = 1: each node prints itself and ONE level of
			'' children, so a node appears once as a row and again under
			'' each of its parents.
			hReportRawDataProc( prof, ctx, f, proc, 1, max_len, 1 )
		next
		tb = tb->nxt
	wend
end sub

'' PROFILE_OPTION_REPORT_RAWSTRINGS -- the arena, walked entry by entry.
private sub hReportRawStrings( byval prof as FB_PROFILER_CALLS ptr, _
                               byval ctx as FB_PROFILER_THREAD_ ptr, byval f as FILE ptr )
	dim as STRING_INFO_TB_ ptr tb = ctx->strings.tb
	dim as STRING_INFO ptr info = any
	dim as integer index_ = any
	dim as long opts = prof->global_->options

	if( (opts and PROFILE_OPTION_HIDE_TITLES) = 0 ) then
		hPadSection( f )
		fprintf( f, @!"Profiler string table (procedure names):\n\n" )
		fprintf( f, @!" size length  hash      string\n\n" )
	end if

	while( tb <> 0 )
		index_ = 0
		while( index_ < tb->bytes_used )
			info = cptr( STRING_INFO ptr, @tb->data(index_) )
			fprintf( f, @"%5d", info->entbytes )
			fprintf( f, @"  %5d", info->strbytes )
			fprintf( f, @"  %8x", info->hashkey )
			fprintf( f, @!"  %s\n", cptr( zstring ptr, info + 1 ) )
			index_ += info->entbytes
		wend
		tb = tb->nxt
	wend

	if( (opts and PROFILE_OPTION_HIDE_TITLES) = 0 ) then
		fprintf( f, @!"\n\n" )
	end if
end sub

'' PROFILE_OPTION_SHOW_DEBUGGING -- the profiler's own internals.
private sub hReportDebug( byval prof as FB_PROFILER_CALLS ptr, _
                          byval ctx as FB_PROFILER_THREAD_ ptr, byval f as FILE ptr )
	dim as FB_PROFILER_METRICS metrics_data = any
	dim as FB_PROFILER_METRICS ptr metrics = @metrics_data

	fb_hPROFILER_METRICS_Clear( metrics )
	hMetricsCallsProfiler( metrics, prof )

	fprintf( f, @!"Profiler Debugging Information:\n" )
	fprintf( f, @!"    Call Tree:\n" )
	fprintf( f, @!"        number of threads  : %d\n", metrics->nthreads )
	fprintf( f, @!"        bytes allocated    : %d\n", metrics->procs_bytes_allocated )
	fprintf( f, @!"        number of blocks   : %d\n", metrics->procs_count_blocks )
	fprintf( f, @!"        number of items    : %d\n", metrics->procs_count_items )
	fprintf( f, @!"        number of slots    : %d\n", metrics->procs_count_slots )
	fprintf( f, @!"    String Block:\n" )
	fprintf( f, @!"        bytes allocated    : %d\n", metrics->string_bytes_allocated )
	fprintf( f, @!"        bytes used         : %d\n", metrics->string_bytes_used )
	fprintf( f, @!"        bytes free         : %d\n", metrics->string_bytes_free )
	fprintf( f, @!"        number of blocks   : %d\n", metrics->string_count_blocks )
	fprintf( f, @!"        number of strings  : %d\n", metrics->string_count_strings )
	fprintf( f, @!"        max string length  : %d\n", metrics->string_max_len )
	fprintf( f, @!"    Hash String Table:\n" )
	fprintf( f, @!"        bytes allocated    : %d\n", metrics->hash_bytes_allocated )
	fprintf( f, @!"        number of blocks   : %d\n", metrics->hash_count_blocks )
	fprintf( f, @!"        number of items    : %d\n", metrics->hash_count_items )
	fprintf( f, @!"        number of slots    : %d\n", metrics->hash_count_slots )
	'' SINGLE precision, deliberately -- fbc casts to float here and the
	'' printed value differs from a double division in the last digit.
	fprintf( f, @!"        density            : %-4.2f%%\n", _
		cdbl( csng( metrics->hash_count_items ) * 100.0f / csng( metrics->hash_count_slots ) ) )
	fprintf( f, @!"\n" )
end sub

'' THE DEFAULT REPORT IS SET BY MUTATING THE OPTIONS, not by a local default:
'' if no report bit is set, REPORT_CALLS is turned on permanently, so a second
'' thread's section sees it already set.
private sub hReportThread( byval prof as FB_PROFILER_CALLS ptr, _
                           byval ctx as FB_PROFILER_THREAD_ ptr, byval f as FILE ptr )
	if( (prof->global_->options and PROFILE_OPTION_REPORT_MASK) = 0 ) then
		prof->global_->options or= PROFILE_OPTION_REPORT_CALLS
	end if

	if( (prof->global_->options and PROFILE_OPTION_REPORT_CALLS) <> 0 ) then
		if( (prof->global_->options and PROFILE_OPTION_HIDE_FUNCTIONS) = 0 ) then
			hReportCallsFunctions( prof, ctx, f )
		end if
		if( (prof->global_->options and PROFILE_OPTION_HIDE_GLOBALS) = 0 ) then
			hReportCallsGlobals( prof, ctx, f )
		end if
	end if

	if( (prof->global_->options and PROFILE_OPTION_REPORT_CALLTREE) <> 0 ) then
		hReportCallTree( prof, ctx, f )
	end if
	if( (prof->global_->options and PROFILE_OPTION_REPORT_RAWLIST) <> 0 ) then
		hReportRawList( prof, ctx, f )
	end if
	if( (prof->global_->options and PROFILE_OPTION_REPORT_RAWDATA) <> 0 ) then
		hReportRawData( prof, ctx, f )
	end if
	if( (prof->global_->options and PROFILE_OPTION_REPORT_RAWSTRINGS) <> 0 ) then
		hReportRawStrings( prof, ctx, f )
	end if
	if( (prof->global_->options and PROFILE_OPTION_SHOW_DEBUGGING) <> 0 ) then
		hReportDebug( prof, ctx, f )
	end if
end sub

'' THE FILE HANDLE IS NOT CHECKED. fopen can fail -- a read-only directory, a
'' path from fb_ProfileSetFileName that does not exist -- and every fprintf
'' below then takes a NULL FILE*. fbc does not check either; reproduced rather
'' than hardened, because a check here would change which programs crash.
private sub hWriteReport( byval prof as FB_PROFILER_CALLS ptr )
	dim as zstring * PROFILER_MAX_PATH filename = any
	dim as FB_PROFILER_THREAD_ ptr thread_ = any
	dim as FILE ptr f = any

	if( prof = 0 ) then exit sub

	tkrt_ProfileGetFileName( @filename, PROFILER_MAX_PATH )
	f = fopen( @filename, @"w" )

	if( (prof->global_->options and PROFILE_OPTION_HIDE_HEADER) = 0 ) then
		hPadSection( f )
		fprintf( f, @!"Profiling results:\n" )
		fprintf( f, @!"------------------\n\n" )
		'' filename is REUSED for the exe name here, after the report name
		'' has already been opened.
		fb_hGetExeName( @filename, PROFILER_MAX_PATH - 1 )
		fprintf( f, @!"Executable name: %s\n", @filename )
		fprintf( f, @!"Launched on: %s\n", @prof->global_->launch_time )
		fprintf( f, @!"Total program execution time: %5.4g seconds\n", _
			prof->main_thread->thread_entry->local_time )
	end if

	hReportThread( prof, prof->main_thread, f )

	thread_ = prof->threads
	while( thread_ <> 0 )
		hReportThread( prof, thread_, f )
		thread_ = thread_->nxt
	wend

	fclose( f )
end sub

'' ---------------------------------------------------------- the call stack

private sub hInitCall( byval ctx as FB_PROFILER_THREAD_ ptr, byval proc as FB_PROCINFO_ ptr, _
                       byval procname as zstring ptr )
	dim as ulong hashkey = fb_ProfileHashName( procname )

	proc->name = hThreadAddString( ctx, procname, hashkey )
	proc->hashkey = hashkey
	proc->proc_id = hNewProcId( ctx )
	proc->start_time = tkrt_Timer( )
	proc->local_time = 0.0
	proc->local_count = 0
	proc->parent = 0
	'' A "{fbfp}" prefix marks a CALL THROUGH A POINTER, which is the one
	'' case BeginProc has to treat as a call site rather than a procedure.
	if( strncmp( proc->name, @"{fbfp}", 6 ) = 0 ) then
		proc->flags = PROCINFO_FLAGS_CALLPTR
	else
		proc->flags = PROCINFO_FLAGS_NONE
	end if
end sub

'' Find-or-create the (parent, name) node and make it current.
''
'' THE PROBE STRIDE IS PROC_MAX_CHILDREN - hash_index, or 1 when the index is
'' zero. 257 is prime, so any non-zero stride visits every slot; the stride
'' varies with the key so two colliding keys do not then collide again.
'' WHEN THE WHOLE TABLE IS FULL the search moves to an OVERFLOW NODE chained
'' through nxt, and starts again there.
private function hPushCall( byval ctx as FB_PROFILER_THREAD_ ptr, _
                            byval parent_proc as FB_PROCINFO_ ptr, _
                            byval procname as zstring ptr ) as FB_PROCINFO_ ptr
	dim as FB_PROCINFO_ ptr orig_parent_proc = any, proc = any
	dim as long j = any, hash_index = any, offset_ = any
	dim as ulong hashkey = fb_ProfileHashName( procname )
	dim as long found = 0

	orig_parent_proc = parent_proc
	hash_index = cast( long, hashkey mod PROC_MAX_CHILDREN )
	if( hash_index <> 0 ) then
		offset_ = PROC_MAX_CHILDREN - hash_index
	else
		offset_ = 1
	end if

	do
		for j = 0 to PROC_MAX_CHILDREN - 1
			proc = parent_proc->child(hash_index)
			if( proc <> 0 ) then
				if( (proc->hashkey = hashkey) andalso (strcmp( proc->name, procname ) = 0) ) then
					found = 1
					exit do
				end if
				hash_index = (hash_index + offset_) mod PROC_MAX_CHILDREN
			else
				proc = hThreadAllocProc( ctx )
				exit do
			end if
		next

		if( parent_proc->nxt = 0 ) then
			parent_proc->nxt = hThreadAllocProc( ctx )
			proc = parent_proc->nxt
			exit do
		end if
		parent_proc = parent_proc->nxt
	loop

	if( found = 0 ) then
		hInitCall( ctx, proc, procname )
		proc->parent = orig_parent_proc
		'' Linked into the block the search ENDED in, at the index it ended
		'' at -- which may be an overflow node, not the original parent.
		parent_proc->child(hash_index) = proc
	end if

	proc->start_time = tkrt_Timer( )
	proc->local_count += 1
	ctx->thread_proc = proc
	return proc
end function

'' ACCUMULATES rather than assigns: a procedure called many times from one
'' caller sums into a single node.
private sub hPopCall( byval ctx as FB_PROFILER_THREAD_ ptr, byval proc as FB_PROCINFO_ ptr )
	dim as double end_time = tkrt_Timer( )
	proc->local_time += (end_time - proc->start_time)
	ctx->thread_proc = proc->parent
end sub

extern "rtlib"

'' BeginProc is emitted at the TOP OF A PROCEDURE; BeginCall at a CALL SITE.
'' The distinction matters only for calls through a pointer, where the callee
'' is not known until run time -- so BeginProc pushes a real node only when the
'' current node is marked CALLPTR.
function tkort_ProfileBeginProc alias "fb_ProfileBeginProc" ( byval procname as zstring ptr ) as any ptr
	dim as FB_PROFILECTX ptr tls = hCtx( )
	dim as FB_PROFILER_THREAD_ ptr ctx = any
	dim as FB_PROCINFO_ ptr proc = any

	if( tls->ctx = 0 ) then hProfileCtxCtor( tls )
	ctx = tls->ctx
	proc = ctx->thread_proc

	'' A newly spawned thread has no current proc: synthesise its entry.
	if( proc = 0 ) then
		if( procname = 0 ) then
			procname = @THREAD_PROC_NAME
		elseif( procname[0] = 0 ) then
			procname = @THREAD_PROC_NAME
		end if
		proc = hThreadAllocProc( ctx )
		hInitCall( ctx, proc, procname )
		proc->flags or= PROCINFO_FLAGS_THREAD
		ctx->thread_entry = proc
		proc->local_count += 1
	end if

	if( procname = 0 ) then
		procname = @UNNAMED_PROC_NAME
	elseif( procname[0] = 0 ) then
		procname = @UNNAMED_PROC_NAME
	end if

	ctx->thread_proc = proc

	if( (proc->flags and PROCINFO_FLAGS_CALLPTR) <> 0 ) then
		proc = hPushCall( ctx, proc, procname )
		ctx->thread_proc = proc
	end if

	return proc
end function

'' Pops only when the PARENT was a call through a pointer -- the mirror of
'' BeginProc's push condition.
sub tkort_ProfileEndProc alias "fb_ProfileEndProc" ( byval callid as any ptr )
	dim as FB_PROFILECTX ptr tls = any
	dim as FB_PROFILER_THREAD_ ptr ctx = any
	dim as FB_PROCINFO_ ptr proc = any

	if( callid = 0 ) then exit sub
	tls = hCtx( )
	ctx = tls->ctx
	proc = ctx->thread_proc
	if( proc->parent <> 0 ) then
		if( (proc->parent->flags and PROCINFO_FLAGS_CALLPTR) <> 0 ) then
			hPopCall( ctx, proc )
		end if
	end if
end sub

function tkort_ProfileBeginCall alias "fb_ProfileBeginCall" ( byval procname as zstring ptr ) as any ptr
	dim as FB_PROFILECTX ptr tls = hCtx( )
	dim as FB_PROFILER_THREAD_ ptr ctx = any
	dim as FB_PROCINFO_ ptr parent_proc = any

	if( tls->ctx = 0 ) then hProfileCtxCtor( tls )
	ctx = tls->ctx
	parent_proc = ctx->thread_proc

	if( parent_proc = 0 ) then
		'' Note the asymmetry with BeginProc: procname is normalised first
		'' and then THREAD_PROC_NAME is passed anyway, so a named first call
		'' on a new thread still shows as "(thread)".
		if( procname = 0 ) then
			procname = @THREAD_PROC_NAME
		elseif( procname[0] = 0 ) then
			procname = @THREAD_PROC_NAME
		end if
		parent_proc = hThreadAllocProc( ctx )
		hInitCall( ctx, parent_proc, @THREAD_PROC_NAME )
		parent_proc->flags or= PROCINFO_FLAGS_THREAD
	end if

	if( procname = 0 ) then
		procname = @UNNAMED_PROC_NAME
	elseif( procname[0] = 0 ) then
		procname = @UNNAMED_PROC_NAME
	end if

	return hPushCall( ctx, parent_proc, procname )
end function

sub tkort_ProfileEndCall alias "fb_ProfileEndCall" ( byval callid as any ptr )
	dim as FB_PROFILECTX ptr tls = any
	if( callid = 0 ) then exit sub
	tls = hCtx( )
	hPopCall( tls->ctx, cptr( FB_PROCINFO_ ptr, callid ) )
end sub

sub tkort_InitProfile alias "fb_InitProfile" ( )
	dim as FB_PROFILECTX ptr tls = hCtx( )
	dim as FB_PROFILER_THREAD_ ptr ctx = any

	if( calls_profiler <> 0 ) then exit sub
	calls_profiler = hCallsCreate( )
	hProfileCtxCtor( tls )
	ctx = tls->ctx

	'' Whoever calls this IS main, by assumption.
	ctx->thread_entry = hThreadAllocProc( ctx )
	hInitCall( ctx, ctx->thread_entry, @MAIN_PROC_NAME )
	ctx->thread_proc = ctx->thread_entry
	ctx->thread_proc->flags or= PROCINFO_FLAGS_MAIN
	ctx->thread_proc->local_count = 1

	calls_profiler->main_thread = ctx
end sub

'' Returns its argument, so it can be spliced into the exit path.
function tkort_EndProfile alias "fb_EndProfile" ( byval errorlevel as long ) as long
	dim as FB_PROFILECTX ptr tls = hCtx( )
	dim as FB_PROFILER_THREAD_ ptr ctx = tls->ctx
	dim as FB_PROFILER_CALLS ptr prof = calls_profiler
	dim as FB_PROCINFO_ ptr lastproc = any

	'' Close every still-open frame, exactly as the thread destructor does.
	lastproc = ctx->thread_proc
	while( lastproc <> 0 )
		lastproc->local_time = tkrt_Timer( ) - lastproc->start_time
		lastproc = lastproc->parent
	wend

	hWriteReport( prof )
	hCallsDestroy( )
	return errorlevel
end function

sub tkort_ProfileGetCallsMetrics alias "fb_ProfileGetCallsMetrics" ( byval metrics as FB_PROFILER_METRICS ptr )
	TKORT_PROFLOCK()
	if( (calls_profiler <> 0) andalso (metrics <> 0) ) then
		hMetricsCallsProfiler( metrics, calls_profiler )
	end if
	TKORT_PROFUNLOCK()
end sub

function tkort_ProfileGetCallsProfiler alias "fb_ProfileGetCallsProfiler" ( ) as FB_PROFILER_CALLS ptr
	return calls_profiler
end function

end extern
