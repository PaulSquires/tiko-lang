'' Two ANONYMOUS unions in one TYPE are two separate members, laid out one after the
'' other. Measured against fbc: two unions of one INTEGER each is 16 bytes, not 8.
''
'' tiko-lang overlapped them. An anonymous union's members are SPLICED into the enclosing type
'' and marked, and the layout pass scans a run of marked fields to find its widest
'' member -- so two adjacent unions produced one continuous run and merged. Each union
'' now marks its own FIRST field, which both bounds the scan and closes the open run.
''
'' The bug was pre-existing and unreachable: 'union field = 4' was being parsed as a
'' union NAMED 'field', so a type with two of them failed as a duplicate before the
'' layout was ever computed. 14 corpus files, all through winnt.bi.

type TwoUnions
	union
		a as integer
	end union
	union
		b as integer
	end union
end type

'' The same, with the alignment clause winnt.bi writes.
type TwoAligned
	union field = 4
		c as integer
	end union
	union field = 4
		d as integer
	end union
end type

'' One union still overlaps, which is the whole point of a union.
type OneUnion
	union
		e as integer
		f as double
	end union
end type

'' 'type T field = 1' caps member alignment.
type Packed field = 4
	g as byte
	h as integer
end type

'' A NAMED union overlaps its members too -- which tiko-lang did NOT do until the same marker
'' was applied to a named union's fields. Measured: three ULONGINTs is 8 bytes, not 24.
union NamedU
	a as ulongint
	b as ulongint
	c as ulongint
end union

'' An anonymous TYPE inside a NAMED union lays its own members out SEQUENTIALLY and
'' overlaps that group with its siblings: f at 0, g at 4, h at 0, size 8.
''
'' This was WRONG for one commit -- 16, with f and g overlapping and h after them -- and
'' pinned here with that explanation, because the flag model could not say 'this group
'' is sequential but the group overlaps'. The layout pass takes a per-field anonymous
'' DEPTH now and places groups recursively, so it can. winnt.bi's _SLIST_HEADER is this
'' shape.
union TypeInUnion
	type
		f as long
		g as long
	end type
	h as double
end union
