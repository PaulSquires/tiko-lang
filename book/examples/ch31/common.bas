'' COMMON SHARED: one variable, declared in every module that uses it.
'' Built with its second module: 'tiko common.bas common-hit.bas'.
common shared hits as long

declare sub Hit( )

hits = 10
Hit( )
Hit( )
print "hits ="; hits
