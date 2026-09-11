'' A USER DECLARATION SHADOWS A PRELUDE ONE.
''
'' fbc's graphics statements are QUIRK KEYWORDS: a user declaration of the same name
'' simply replaces them, and 'type IMAGEINFO as _II' compiles with the TYPE winning --
'' measured. tiko declares the same names from a real prelude buffer, so
'' win/commctrl.bi's own 'type IMAGEINFO as _IMAGEINFO' collided with the intrinsic and
'' raised two errors, which failed every file that reaches commctrl.bi through
'' windows.bi.
''
'' The prelude is a VIRTUAL FILE appended to the unit, so its declarations are collected
'' AFTER the user's includes -- the diagnostic pointed at '<builtin>' and named the
'' header's type as the one already declared. Whichever side is the prelude's loses.
type _II
	a as long
end type

type IMAGEINFO as _II

dim as IMAGEINFO x
x.a = 5
print x.a
