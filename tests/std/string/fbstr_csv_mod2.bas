'' A SECOND module that includes fb/string.bi and uses the CSV bodies.
''
'' This file has no assertions of its own. Its whole job is to be linked
'' alongside fbstr_csv.bas, which includes the same header.
''
'' SplitCsv and SplitCsvRow have real FreeBASIC bodies -- they must, because
'' they return an Array( of T ), which the runtime cannot build. A body in a
'' header is emitted into every module that includes it, so without `private`
'' those bodies would collide and the link would fail with "multiple definition
'' of FB::SplitCsv". Nothing in a single-module test can catch that; only a
'' second module can.
''
'' So the assertion made here is the LINK ITSELF. If the `private` on those
'' bodies is ever dropped, this suite stops building rather than starts
'' failing, which is the louder of the two.

'' fbcunit.bi is included so the harness COLLECTS this file: unit-tests.mk
'' gathers only the .bas files that include it. There are no suites here --
'' the file exists to be compiled and linked, not to assert.
#import "std/strings"
#import "std/containers"
#include "fbcunit.bi"

using strings, containers
'' Called from fbstr_csv.bas. Answers the record count, or 0 for malformed.
function CsvInOtherModule( byref s as const string ) as integer
	dim rows as Array( of CsvRow ) = SplitCsv( s )
	if rows.Count( ) = 0 then return 0

	'' use SplitCsvRow too, so both bodies are instantiated in this module
	dim first_ as Array( of string ) = SplitCsvRow( s )
	if first_.Count( ) <> rows[ 0 ].fields.Count( ) then return -1

	return rows.Count( )
end function
