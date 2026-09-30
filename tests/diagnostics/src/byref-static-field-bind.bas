'' A 'static byref' field and an 'extern byref' are declarations: the definition binds.
dim shared x as integer
type T
	dummy as integer
	static byref ri as integer                  '' fine
	static byref rj as integer
end type
extern byref re as integer                      '' fine
extern byref rf as integer
dim byref T.ri as integer = x                   '' fine
dim shared byref re as integer = x              '' fine
dim byref T.rj as integer                       '' refused
dim shared byref rf as integer                  '' refused
