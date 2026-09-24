'' sqlite.bas -- sqlite3.h through #cinclude, linked against the amalgamation clang built,
'' and RUN by build/cimporte2e.sh.
#cinclude "sqlite3.h"

dim as sqlite3 ptr db
print "open", sqlite3_open( ":memory:", @db ) = SQLITE_OK
print "exec", sqlite3_exec( db, "create table t( a int ); insert into t values( 20 ), ( 22 );", 0, 0, 0 ) = SQLITE_OK
dim as sqlite3_stmt ptr st
print "prepare", sqlite3_prepare_v2( db, "select sum( a ) from t", -1, @st, 0 ) = SQLITE_OK
print "step", sqlite3_step( st ) = SQLITE_ROW
print "sum", sqlite3_column_int( st, 0 )
sqlite3_finalize( st )
print "close", sqlite3_close( db ) = SQLITE_OK
