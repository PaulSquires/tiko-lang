'' Two ANONYMOUS unions in one TYPE are two separate members, laid out one after the
'' other. Measured against fbc: two unions of one INTEGER each is 16 bytes, not 8.
''
'' fbx overlapped them. An anonymous union's members are SPLICED into the enclosing type
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
