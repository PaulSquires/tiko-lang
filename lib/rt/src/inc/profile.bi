'' profile.bi -- the profiler's shared types.
''
'' SPLIT OUT BECAUSE TWO fbc MEMBERS SHARE THEM. profile.o owns the string
'' arena and hash tables; profile_calls.o builds its per-thread call tree on
'' top of them and reads the same structs. Both are reproduced here, so the
'' layouts have to be declared once.
''
'' NONE OF THESE ARE BYTE-PACKED. They mirror what the C compiler laid out and
'' fbc's other objects read them directly; `field = 1` would shift every field.

#pragma once

#include once "inc/descriptors.bi"

const STRING_INFO_TB_SIZE = 10240
const STRING_HASH_TB_SIZE = 997
const PROFILER_MAX_PATH   = 1024

const DEFAULT_PROFILE_FILE = "profile.txt"
const DEFAULT_PROFILE_EXT  = ".prf"

const PROC_MAX_CHILDREN = 257
const PROC_INFO_TB_SIZE = 1024
const PROC_HASH_TB_SIZE = 257

'' THREE C ints, not lengths in the index-width sense: this struct mirrors one
'' the C profiler writes, so the widths are fixed by its layout and cannot be
'' widened to `integer`. Named entbytes/strbytes rather than size/length so the
'' lint does not have to be argued with at every reader.
type STRING_INFO
	as long         entbytes      '' padded allocation size of this entry
	as long         strbytes      '' strlen + 1, the bytes actually stored
	as ulong        hashkey
end type

type STRING_INFO_TB_
	as ubyte              data( 0 to STRING_INFO_TB_SIZE - 1 )
	as STRING_INFO_TB_ ptr nxt
	as long               bytes_used
	as long               string_tb_id
end type

type STRING_TABLE
	as STRING_INFO_TB_ ptr tb
end type

type STRING_HASH_TB_
	as STRING_INFO ptr     items( 0 to STRING_HASH_TB_SIZE - 1 )
	as STRING_HASH_TB_ ptr nxt
end type

type STRING_HASH_TABLE_
	as STRING_TABLE ptr    strings
	as STRING_HASH_TB_ ptr tb
end type

type STRING_HASH_
	as STRING_HASH_TABLE_ ptr strings_hash
	as STRING_HASH_TABLE_     hash_
end type

type FB_PROFILER_GLOBAL
	as any ptr             profiler_ctx
	as STRING_TABLE        strings
	as STRING_HASH_TABLE_  strings_hash
	as STRING_HASH_TABLE_  ignores_hash
	as zstring * PROFILER_MAX_PATH filename
	as zstring * 32        launch_time
	as long                options
end type

type FB_PROFILER_METRICS
	as long nthreads
	as long string_bytes_allocated, string_bytes_used, string_bytes_free
	as long string_count_blocks, string_count_strings, string_max_len
	as long hash_bytes_allocated, hash_count_blocks, hash_count_items, hash_count_slots
	as long procs_bytes_allocated, procs_count_blocks, procs_count_items, procs_count_slots
end type

'' The reporting options, in fb_profile.h's order.
const PROFILE_OPTION_REPORT_DEFAULT    = &h00000000
const PROFILE_OPTION_REPORT_CALLS      = &h00000001
const PROFILE_OPTION_REPORT_CALLTREE   = &h00000002
const PROFILE_OPTION_REPORT_RAWLIST    = &h00000004
const PROFILE_OPTION_REPORT_RAWDATA    = &h00000008
const PROFILE_OPTION_REPORT_RAWSTRINGS = &h00000010
const PROFILE_OPTION_REPORT_MASK       = &h000000FF
const PROFILE_OPTION_HIDE_HEADER       = &h00000100
const PROFILE_OPTION_HIDE_TITLES       = &h00000200
const PROFILE_OPTION_HIDE_COUNTS       = &h00000400
const PROFILE_OPTION_HIDE_TIMES        = &h00000800
const PROFILE_OPTION_HIDE_FUNCTIONS    = &h00001000
const PROFILE_OPTION_HIDE_GLOBALS      = &h00002000
const PROFILE_OPTION_SHOW_DEBUGGING    = &h01000000
const PROFILE_OPTION_GRAPHICS_CHARS    = &h02000000

'' The shared entry points profile_calls.bas calls into profile/core.bas.
'' NON-FBCALL: fb_profile.h declares every one of these plain.
extern "c"   '' NON-FBCALL: the profiler internals carry no FBCALL marker.
	declare function fb_ProfileHashName alias "fb_ProfileHashName" ( byval p as zstring ptr ) as ulong
	declare sub STRING_TABLE_constructor alias "STRING_TABLE_constructor" ( byval s as STRING_TABLE ptr )
	declare sub STRING_TABLE_destructor alias "STRING_TABLE_destructor" ( byval s as STRING_TABLE ptr )
	declare function STRING_TABLE_max_len alias "STRING_TABLE_max_len" ( byval s as STRING_TABLE ptr ) as long
	declare function STRING_HASH_TB_find alias "STRING_HASH_TB_find" _
		( byval tb as STRING_HASH_TB_ ptr, byval src as zstring ptr, byval h as ulong ) as STRING_INFO ptr
	declare function STRING_HASH_TABLE_find alias "STRING_HASH_TABLE_find" _
		( byval ht as STRING_HASH_TABLE_ ptr, byval src as zstring ptr, byval h as ulong ) as STRING_INFO ptr
	declare sub STRING_HASH_TABLE_constructor alias "STRING_HASH_TABLE_constructor" _
		( byval ht as STRING_HASH_TABLE_ ptr, byval s as STRING_TABLE ptr )
	declare sub STRING_HASH_TABLE_destructor alias "STRING_HASH_TABLE_destructor" ( byval ht as STRING_HASH_TABLE_ ptr )
	declare function STRING_HASH_TABLE_add alias "STRING_HASH_TABLE_add" _
		( byval ht as STRING_HASH_TABLE_ ptr, byval src as zstring ptr, byval h as ulong ) as STRING_INFO ptr
	declare sub STRING_HASH_constructor alias "STRING_HASH_constructor" _
		( byval h as STRING_HASH_ ptr, byval sh as STRING_HASH_TABLE_ ptr )
	declare sub STRING_HASH_destructor alias "STRING_HASH_destructor" ( byval h as STRING_HASH_ ptr )
	declare sub STRING_HASH_add alias "STRING_HASH_add" _
		( byval h as STRING_HASH_ ptr, byval src as zstring ptr, byval hk as ulong )
	declare function STRING_HASH_find alias "STRING_HASH_find" _
		( byval h as STRING_HASH_ ptr, byval src as zstring ptr, byval hk as ulong ) as STRING_INFO ptr
	declare sub fb_hPROFILER_METRICS_Clear alias "fb_hPROFILER_METRICS_Clear" ( byval m as FB_PROFILER_METRICS ptr )
	declare sub fb_hPROFILER_METRICS_Strings alias "fb_hPROFILER_METRICS_Strings" _
		( byval m as FB_PROFILER_METRICS ptr, byval s as STRING_TABLE ptr )
	declare sub fb_hPROFILER_METRICS_HashTable alias "fb_hPROFILER_METRICS_HashTable" _
		( byval m as FB_PROFILER_METRICS ptr, byval ht as STRING_HASH_TABLE_ ptr )
	declare sub fb_hPROFILER_METRICS_Global alias "fb_hPROFILER_METRICS_Global" _
		( byval m as FB_PROFILER_METRICS ptr, byval g as FB_PROFILER_GLOBAL ptr )
	declare function PROFILER_GLOBAL_create alias "PROFILER_GLOBAL_create" ( ) as FB_PROFILER_GLOBAL ptr
	declare sub PROFILER_GLOBAL_destroy alias "PROFILER_GLOBAL_destroy" ( )
	declare function fb_hGetExeName alias "fb_hGetExeName" _
		( byval dst as zstring ptr, byval length as integer ) as zstring ptr
end extern
