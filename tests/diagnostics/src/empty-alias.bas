'' AN EMPTY ALIAS OR LIB STRING IS AN ERROR -- fbc's 304 and 305. 'alias ""' would mangle
'' to a name with nothing in it and 'lib ""' would link against a library with no name;
'' a non-empty one is the ordinary use and is accepted.
declare sub good alias "good_name"( )
extern as integer okVar alias "ok_var"

declare sub bad1 alias ""( )
declare sub bad2 lib ""( )
extern as integer badVar alias ""
