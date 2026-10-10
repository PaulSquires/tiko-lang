'' db/sqlite, the tiko port of fbsqlite (2026-10-10): an in-memory database, a table, a
'' parameterised insert and a query read back -- the toolchain's sqlite3 and sqlite3api.bi.
#import "db/sqlite"
using sqlite
dim db as Database
db.OpenMemory( )
db.Execute( "create table person( name text, age integer )" )
db.Execute( "insert into person values( ?, ? )", Args( "Ada", 36LL ) )
dim rows as RowsResult = db.Query( "select * from person" )
if rows.IsOk( ) then
    for each person in rows.Value( )
        print person[ "name" ].AsText( ); " "; person[ "age" ].AsInt64( )
    next
end if
