'' strings.SplitCsv / SplitCsvRow -- exhaustive.
''
'' The reason this is not just another Split test: SPLITTING ON COMMAS CANNOT
'' BE PATCHED INTO A CSV PARSER. A delimiter that also appears as content has
'' no repair, so every case below that involves a quote is one the ordinary
'' Split answers wrongly rather than approximately.
''
'' Four things need pinning that no other suite covers:
''
''   1. RECORDS AND FIELDS COME FROM THE SAME PASS. A newline inside a quoted
''      field is content. Any implementation that splits into lines first
''      passes every other test here and fails that one.
''
''   2. ZERO ROWS MEANS MALFORMED, and nothing else does. A well-formed parse
''      always yields at least one record -- including for "" -- so the signal
''      is unambiguous. Both halves of that are asserted.
''
''   3. THE TRAILING-NEWLINE RULE IS THE OPPOSITE OF SPLIT'S. "a,b\n" is one
''      record, not two, while Split( "a," ) is two fields. Two neighbouring
''      functions with opposite empty-tail rules is exactly the kind of thing
''      that gets "fixed" into consistency by someone who did not know it was
''      a decision.
''
''   4. BOTH FAMILIES, and the byte family's exactness for UTF-8. Quote, comma,
''      CR and LF are all below 0x80 and no continuation byte is, so bytes
''      survive the round trip -- unlike the character-set functions, where a
''      STRING set really is a set of bytes.

#import "std/strings"
#include "fbcunit.bi"

#include once "fb/array.bi"

using strings

using FB
'' defined in fbstr_csv_mod2.bas -- proves two modules can both include the
'' header, which is the whole point of the CSV bodies being private
declare function CsvInOtherModule( byref s as const string ) as integer

SUITE( fbc_tests.string_.fbstr_csv )

	'' -------------------------------------------------- SplitCsv, plain

	TEST( csv_rows_and_fields )
		dim t as Array( of CsvRow ) = SplitCsv( "a,b,c" & chr( 10 ) & "d,e,f" )
		CU_ASSERT_EQUAL( t.Count( ), 2 )
		CU_ASSERT_EQUAL( t[0].fields.Count( ), 3 )
		CU_ASSERT_EQUAL( t[0].fields[0], "a" )
		CU_ASSERT_EQUAL( t[0].fields[2], "c" )
		CU_ASSERT_EQUAL( t[1].fields[0], "d" )
		CU_ASSERT_EQUAL( t[1].fields[2], "f" )
	END_TEST

	TEST( csv_delimiters )
		'' the default is a comma
		dim a as Array( of CsvRow ) = SplitCsv( "a,b" )
		CU_ASSERT_EQUAL( a[0].fields.Count( ), 2 )

		dim b as Array( of CsvRow ) = SplitCsv( "a;b;c", ";" )
		CU_ASSERT_EQUAL( b[0].fields.Count( ), 3 )
		CU_ASSERT_EQUAL( b[0].fields[1], "b" )

		'' a tab is a perfectly ordinary delimiter
		dim c as Array( of CsvRow ) = SplitCsv( "a" & chr( 9 ) & "b", chr( 9 ) )
		CU_ASSERT_EQUAL( c[0].fields.Count( ), 2 )
	END_TEST

	TEST( csv_delimiter_must_be_one_unit )
		'' Anything that is not exactly one code unit means NO delimiter:
		'' the record comes back whole, records and quoting still honoured.
		'' Same rule as Split's empty delimiter.
		dim a as Array( of CsvRow ) = SplitCsv( "a,b,c", "<>" )
		CU_ASSERT_EQUAL( a[0].fields.Count( ), 1 )
		CU_ASSERT_EQUAL( a[0].fields[0], "a,b,c" )

		dim b as Array( of CsvRow ) = SplitCsv( "a,b,c", "" )
		CU_ASSERT_EQUAL( b[0].fields.Count( ), 1 )
		CU_ASSERT_EQUAL( b[0].fields[0], "a,b,c" )

		'' records still split, and quotes are still quotes
		dim c as Array( of CsvRow ) = SplitCsv( !"\"x,y\"\nz", "" )
		CU_ASSERT_EQUAL( c.Count( ), 2 )
		CU_ASSERT_EQUAL( c[0].fields[0], "x,y" )
	END_TEST

	TEST( csv_empty_fields_are_fields )
		dim a as Array( of CsvRow ) = SplitCsv( "a,,c" )
		CU_ASSERT_EQUAL( a[0].fields.Count( ), 3 )
		CU_ASSERT_EQUAL( a[0].fields[1], "" )

		dim b as Array( of CsvRow ) = SplitCsv( ",,")
		CU_ASSERT_EQUAL( b[0].fields.Count( ), 3 )

		'' leading and trailing empties both count
		dim c as Array( of CsvRow ) = SplitCsv( ",a," )
		CU_ASSERT_EQUAL( c[0].fields.Count( ), 3 )
		CU_ASSERT_EQUAL( c[0].fields[0], "" )
		CU_ASSERT_EQUAL( c[0].fields[1], "a" )
		CU_ASSERT_EQUAL( c[0].fields[2], "" )
	END_TEST

	TEST( csv_ragged_rows_are_kept_ragged )
		'' No padding and no truncation to the header's width. A short row is
		'' the file's problem to report, not the parser's to hide.
		dim t as Array( of CsvRow ) = SplitCsv( !"a,b,c\nd\ne,f" )
		CU_ASSERT_EQUAL( t.Count( ), 3 )
		CU_ASSERT_EQUAL( t[0].fields.Count( ), 3 )
		CU_ASSERT_EQUAL( t[1].fields.Count( ), 1 )
		CU_ASSERT_EQUAL( t[2].fields.Count( ), 2 )
	END_TEST

	'' ------------------------------------------------------ line endings

	TEST( csv_line_endings )
		'' LF, CRLF and a lone CR all end exactly one record, and they may be
		'' mixed inside one document.
		dim a as Array( of CsvRow ) = SplitCsv( !"a\nb\r\nc\rd" )
		CU_ASSERT_EQUAL( a.Count( ), 4 )
		CU_ASSERT_EQUAL( a[0].fields[0], "a" )
		CU_ASSERT_EQUAL( a[1].fields[0], "b" )
		CU_ASSERT_EQUAL( a[2].fields[0], "c" )
		CU_ASSERT_EQUAL( a[3].fields[0], "d" )

		'' CRLF counts ONCE -- the classic off-by-one is an empty record
		'' between every pair of real ones.
		dim b as Array( of CsvRow ) = SplitCsv( !"a,b\r\nc,d\r\n" )
		CU_ASSERT_EQUAL( b.Count( ), 2 )
	END_TEST

	TEST( csv_trailing_newline_makes_no_extra_record )
		'' DELIBERATELY THE OPPOSITE OF SPLIT. A file ending in a newline is
		'' the normal case, not a file with a blank record at the end.
		dim a as Array( of CsvRow ) = SplitCsv( !"a,b\n" )
		CU_ASSERT_EQUAL( a.Count( ), 1 )

		dim b as Array( of CsvRow ) = SplitCsv( "a,b" )
		CU_ASSERT_EQUAL( b.Count( ), 1 )
		CU_ASSERT_EQUAL( b[0].fields.Count( ), 2 )

		'' but a BLANK LINE in the middle, or a second trailing one, is a
		'' real (empty) record -- only the single final terminator is absorbed
		dim c as Array( of CsvRow ) = SplitCsv( !"a\n\nb\n" )
		CU_ASSERT_EQUAL( c.Count( ), 3 )
		CU_ASSERT_EQUAL( c[1].fields.Count( ), 1 )
		CU_ASSERT_EQUAL( c[1].fields[0], "" )

		dim d as Array( of CsvRow ) = SplitCsv( !"a\n\n" )
		CU_ASSERT_EQUAL( d.Count( ), 2 )
	END_TEST

	TEST( csv_empty_input_is_one_empty_field )
		'' This is what makes zero rows an unambiguous error signal.
		dim a as Array( of CsvRow ) = SplitCsv( "" )
		CU_ASSERT_EQUAL( a.Count( ), 1 )
		CU_ASSERT_EQUAL( a[0].fields.Count( ), 1 )
		CU_ASSERT_EQUAL( a[0].fields[0], "" )

		dim b as Array( of CsvRow ) = SplitCsv( !"\n" )
		CU_ASSERT_EQUAL( b.Count( ), 1 )
		CU_ASSERT_EQUAL( b[0].fields[0], "" )
	END_TEST

	'' ----------------------------------------------------------- quoting

	TEST( csv_quotes_protect_content )
		'' The whole reason this function exists.
		dim a as Array( of CsvRow ) = SplitCsv( !"a,\"b,c\",d" )
		CU_ASSERT_EQUAL( a[0].fields.Count( ), 3 )
		CU_ASSERT_EQUAL( a[0].fields[1], "b,c" )

		'' a doubled quote is one literal quote
		dim b as Array( of CsvRow ) = SplitCsv( !"\"d\"\"e\"" )
		CU_ASSERT_EQUAL( b[0].fields[0], !"d\"e" )

		'' a quoted empty field, and a field of nothing but quotes
		dim c as Array( of CsvRow ) = SplitCsv( !"\"\",\"\"\"\"" )
		CU_ASSERT_EQUAL( c[0].fields.Count( ), 2 )
		CU_ASSERT_EQUAL( c[0].fields[0], "" )
		CU_ASSERT_EQUAL( c[0].fields[1], !"\"" )

		'' quoting may start and stop part way through a field -- RFC 4180
		'' does not bless it, but exports produce it and the answer is
		'' unambiguous
		dim d as Array( of CsvRow ) = SplitCsv( !"a\"b,c\"d" )
		CU_ASSERT_EQUAL( d[0].fields.Count( ), 1 )
		CU_ASSERT_EQUAL( d[0].fields[0], "ab,cd" )
	END_TEST

	TEST( csv_newline_inside_quotes_is_content )
		'' AN IMPLEMENTATION THAT SPLITS INTO LINES FIRST FAILS ONLY HERE.
		dim a as Array( of CsvRow ) = SplitCsv( !"\"line1\nline2\",z" )
		CU_ASSERT_EQUAL( a.Count( ), 1 )
		CU_ASSERT_EQUAL( a[0].fields.Count( ), 2 )
		CU_ASSERT_EQUAL( a[0].fields[0], !"line1\nline2" )
		CU_ASSERT_EQUAL( a[0].fields[1], "z" )

		'' CRLF inside quotes is content too, and is NOT normalised
		dim b as Array( of CsvRow ) = SplitCsv( !"\"x\r\ny\"\nnext" )
		CU_ASSERT_EQUAL( b.Count( ), 2 )
		CU_ASSERT_EQUAL( b[0].fields[0], !"x\r\ny" )
		CU_ASSERT_EQUAL( b[1].fields[0], "next" )

		'' a quoted field that is nothing but a newline
		dim c as Array( of CsvRow ) = SplitCsv( !"\"\n\",a" )
		CU_ASSERT_EQUAL( c.Count( ), 1 )
		CU_ASSERT_EQUAL( c[0].fields[0], !"\n" )
	END_TEST

	TEST( csv_unclosed_quote_is_zero_rows )
		'' Consuming the rest of the document as one field is the alternative,
		'' and it produces a plausible-looking single row instead of a
		'' complaint. Silence is the one answer that cannot be checked.
		dim a as Array( of CsvRow ) = SplitCsv( !"a,\"unclosed" )
		CU_ASSERT_EQUAL( a.Count( ), 0 )

		'' opened on a later record -- the good rows found before it are
		'' discarded too, because the file is not what the caller thinks it is
		dim b as Array( of CsvRow ) = SplitCsv( !"a,b\nc,\"d\ne,f" )
		CU_ASSERT_EQUAL( b.Count( ), 0 )

		'' a lone quote at the very end
		dim c as Array( of CsvRow ) = SplitCsv( !"a,b,\"" )
		CU_ASSERT_EQUAL( c.Count( ), 0 )

		'' an ODD number of quotes in a row leaves one open
		dim d as Array( of CsvRow ) = SplitCsv( !"\"\"\"" )
		CU_ASSERT_EQUAL( d.Count( ), 0 )

		'' ...and an even number does not
		dim e as Array( of CsvRow ) = SplitCsv( !"\"\"\"\"" )
		CU_ASSERT_EQUAL( e.Count( ), 1 )
		CU_ASSERT_EQUAL( e[0].fields[0], !"\"" )
	END_TEST

	'' ---------------------------------------------------------- encoding

	TEST( csv_byte_family_is_exact_for_utf8 )
		'' Unlike the character-set functions, this is exact on a STRING:
		'' quote, comma, CR and LF are all below 0x80 and no UTF-8
		'' continuation byte is, so a multi-byte character can never be
		'' mistaken for a delimiter.
		dim as string e_acute = chr( &hC3 ) & chr( &hA9 )
		dim as string src = "caf" & e_acute & ",the" & e_acute & "s"
		dim a as Array( of CsvRow ) = SplitCsv( src )
		CU_ASSERT_EQUAL( a[0].fields.Count( ), 2 )
		CU_ASSERT_EQUAL( a[0].fields[0], "caf" & e_acute )
		CU_ASSERT_EQUAL( a[0].fields[1], "the" & e_acute & "s" )

		'' and inside quotes, beside a protected comma
		dim b as Array( of CsvRow ) = SplitCsv( """caf" & e_acute & ",x""" )
		CU_ASSERT_EQUAL( b[0].fields.Count( ), 1 )
		CU_ASSERT_EQUAL( b[0].fields[0], "caf" & e_acute & ",x" )
	END_TEST

	TEST( csv_wide_family_keeps_code_units )
		'' The accented capital O that broke the original of this parser: a
		'' code unit appended with CHR rather than WCHR builds a one-BYTE
		'' string, which a USTRING then decodes as UTF-8, where a lone 0xD3 is
		'' not a valid sequence.
		dim as ustring src = wchr( &h00D3 ) & ",x"
		dim a as Array( of CsvURow ) = SplitCsv( src )
		CU_ASSERT_EQUAL( a[0].fields.Count( ), 2 )
		CU_ASSERT_EQUAL( len( a[0].fields[0] ), 1 )
		CU_ASSERT_EQUAL( a[0].fields[0][0], &h00D3 )

		'' the same, forced through the doubled-quote path so the character
		'' is rebuilt rather than sliced out
		dim as ustring src2 = """" & wchr( &h00D3 ) & """""" & wchr( &h00D3 ) & """"
		dim b as Array( of CsvURow ) = SplitCsv( src2 )
		CU_ASSERT_EQUAL( b[0].fields.Count( ), 1 )
		CU_ASSERT_EQUAL( len( b[0].fields[0] ), 3 )
		CU_ASSERT_EQUAL( b[0].fields[0][1], 34 )

		'' an astral character is a surrogate pair and survives whole
		dim as ustring src3 = wchr( &hD83D ) & wchr( &hDE00 ) & ",y"
		dim c as Array( of CsvURow ) = SplitCsv( src3 )
		CU_ASSERT_EQUAL( len( c[0].fields[0] ), 2 )
		CU_ASSERT_EQUAL( c[0].fields[0][0], &hD83D )
		CU_ASSERT_EQUAL( c[0].fields[0][1], &hDE00 )
	END_TEST

	'' ------------------------------------------------------ wide overloads

	TEST( csv_ustring_overload )
		dim as ustring src = !"a,\"b,c\",\"d\"\"e\"\nz,,y"
		dim t as Array( of CsvURow ) = SplitCsv( src )
		CU_ASSERT_EQUAL( t.Count( ), 2 )
		CU_ASSERT_EQUAL( t[0].fields[1], "b,c" )
		CU_ASSERT_EQUAL( t[0].fields[2], !"d\"e" )
		CU_ASSERT_EQUAL( t[1].fields.Count( ), 3 )
		CU_ASSERT_EQUAL( t[1].fields[1], "" )

		dim as ustring bad = !"\"never closed"
		dim u as Array( of CsvURow ) = SplitCsv( bad )
		CU_ASSERT_EQUAL( u.Count( ), 0 )

		dim as ustring empty_ = ""
		dim v as Array( of CsvURow ) = SplitCsv( empty_ )
		CU_ASSERT_EQUAL( v.Count( ), 1 )
		CU_ASSERT_EQUAL( v[0].fields.Count( ), 1 )
	END_TEST

	TEST( csv_wstring_overload_yields_ustring_rows )
		'' A WSTRING in gives USTRING fields, the same return rule every other
		'' function here follows.
		dim as wstring * 64 w = "a,""b,c"",d"
		dim t as Array( of CsvURow ) = SplitCsv( w )
		CU_ASSERT_EQUAL( t.Count( ), 1 )
		CU_ASSERT_EQUAL( t[0].fields.Count( ), 3 )
		CU_ASSERT_EQUAL( t[0].fields[1], "b,c" )

		dim as wstring * 32 bad = """oops"
		dim u as Array( of CsvURow ) = SplitCsv( bad )
		CU_ASSERT_EQUAL( u.Count( ), 0 )
	END_TEST

	'' -------------------------------------------------------- SplitCsvRow

	TEST( csv_split_row )
		dim a as Array( of string ) = SplitCsvRow( !"a,\"b,c\",d" )
		CU_ASSERT_EQUAL( a.Count( ), 3 )
		CU_ASSERT_EQUAL( a[0], "a" )
		CU_ASSERT_EQUAL( a[1], "b,c" )
		CU_ASSERT_EQUAL( a[2], "d" )

		'' where there is nothing to quote it agrees with Split exactly
		dim b as Array( of string ) = SplitCsvRow( "a,,c" )
		dim c as Array( of string ) = Split( "a,,c" )
		CU_ASSERT_EQUAL( b.Count( ), c.Count( ) )
		CU_ASSERT_EQUAL( b[1], c[1] )

		'' an empty record is one empty field, as it is for Split
		dim d as Array( of string ) = SplitCsvRow( "" )
		CU_ASSERT_EQUAL( d.Count( ), 1 )
		CU_ASSERT_EQUAL( d[0], "" )

		'' custom delimiter
		dim e as Array( of string ) = SplitCsvRow( "x;y", ";" )
		CU_ASSERT_EQUAL( e.Count( ), 2 )
		CU_ASSERT_EQUAL( e[1], "y" )
	END_TEST

	TEST( csv_split_row_edges )
		'' Malformed is an EMPTY array, on the same rule: a good parse always
		'' yields at least one field.
		dim a as Array( of string ) = SplitCsvRow( !"a,\"oops" )
		CU_ASSERT_EQUAL( a.Count( ), 0 )

		'' More than one record answers the FIRST. The rest is a table, and
		'' SplitCsv is what returns tables.
		dim b as Array( of string ) = SplitCsvRow( !"a,b\nc,d" )
		CU_ASSERT_EQUAL( b.Count( ), 2 )
		CU_ASSERT_EQUAL( b[0], "a" )
		CU_ASSERT_EQUAL( b[1], "b" )

		'' the wide overloads
		dim as ustring us = !"p,\"q,r\""
		dim c as Array( of ustring ) = SplitCsvRow( us )
		CU_ASSERT_EQUAL( c.Count( ), 2 )
		CU_ASSERT_EQUAL( c[1], "q,r" )

		dim as wstring * 32 w = "p,q"
		dim d as Array( of ustring ) = SplitCsvRow( w )
		CU_ASSERT_EQUAL( d.Count( ), 2 )
		CU_ASSERT_EQUAL( d[1], "q" )
	END_TEST

	'' -------------------------------------------------------------- scale

	TEST( csv_at_scale )
		'' Also the complexity claim: the scan appends whole RUNS with MID
		'' rather than one unit at a time, so a long field is linear. A
		'' per-character `&=` version of this test takes visibly longer.
		dim as string src = Repeat( 2000, !"aaaa,\"b,b\",cccc\n" )
		dim t as Array( of CsvRow ) = SplitCsv( src )
		CU_ASSERT_EQUAL( t.Count( ), 2000 )
		CU_ASSERT_EQUAL( t[0].fields.Count( ), 3 )
		CU_ASSERT_EQUAL( t[1999].fields[1], "b,b" )

		'' one very long single field
		dim as string big = Repeat( 20000, "x" )
		dim u as Array( of CsvRow ) = SplitCsv( big & ",y" )
		CU_ASSERT_EQUAL( u[0].fields.Count( ), 2 )
		CU_ASSERT_EQUAL( len( u[0].fields[0] ), 20000 )

		'' ...and a long field that is quoted, so it goes through the other
		'' branch of the cursor
		dim u2 as Array( of CsvRow ) = SplitCsv( """" & big & """,y" )
		CU_ASSERT_EQUAL( len( u2[0].fields[0] ), 20000 )

		'' many empty fields
		dim as string commas = Repeat( 2000, "," )
		dim v as Array( of CsvRow ) = SplitCsv( commas )
		CU_ASSERT_EQUAL( v.Count( ), 1 )
		CU_ASSERT_EQUAL( v[0].fields.Count( ), 2001 )
	END_TEST

	TEST( csv_bodies_are_private_across_modules )
		'' If the bodies were not `private`, this binary would not have linked
		'' at all: the other module includes the same header.
		CU_ASSERT_EQUAL( CsvInOtherModule( !"a,\"b,c\"\nd,e" ), 2 )
		CU_ASSERT_EQUAL( CsvInOtherModule( "" ), 1 )
		CU_ASSERT_EQUAL( CsvInOtherModule( !"\"oops" ), 0 )
	END_TEST

END_SUITE
