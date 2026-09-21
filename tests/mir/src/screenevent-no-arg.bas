'' SCREENEVENT with no argument PEEKS: it reports whether an event is waiting and
'' leaves it there. fbc's rtl-gfx entry gives the argument a default of 0, and the
'' prelude did not, so this form was TKO0776 -- "argument 1 is left out".
dim as long pending = screenevent( )
