'' devlptio.bas -- fb_DevLptWrite, fb_DevLptWriteWstr and fb_DevLptClose: the
'' printer device's write and close. Three symbols across three fbc members.
''
'' THIN WRAPPERS OVER A DRIVER THAT IS STILL C. Each one takes the I/O lock,
'' hands the channel's opaque pointer to the matching fb_Printer* entry point,
'' and releases. The actual spooler work is in fbc's io_printer.o, which is
'' Windows GDI and winspool on one side and a pipe to lpr on the other -- neither
'' of which is expressible here, and neither of which needs to be for these
'' three.
''
'' THE OPAQUE POINTER IS A DEV_LPT_INFO AND ITS FIRST MEMBER MUST STAY FIRST.
'' fb_printer.h says so in a comment -- `void *driver_opaque; /* this member must
'' be first */` -- because the platform driver casts the DEV_LPT_INFO straight to
'' its own private structure. So the struct is bound here with driver_opaque
'' leading, and nothing may be inserted above it.
''
'' CLOSE IS REFERENCE-COUNTED, AND THAT IS THE WHOLE REASON IT IS NOT A ONE-LINER.
'' Two channels may be OPEN on the same printer; the device is shut down and its
'' memory released only when the LAST one closes. Every other close just
'' decrements and reports success.
''
'' AND THE MEMORY IS FREED ONLY IF THE DRIVER AGREED TO CLOSE. `if( res ==
'' FB_RTERROR_OK )` guards both frees, so a driver that failed to close leaves
'' the DEV_LPT_INFO allocated and the refcount at 1 -- deliberately, because
'' freeing it would leave the driver holding a pointer into released memory. The
'' consequence is that a printer which fails to close leaks, and that is fbc's
'' choice between a leak and a dangling pointer.
''
'' THE ERROR CODE COMES FROM TWO DIFFERENT PLACES depending on the branch. The
'' last-close path returns whatever fb_PrinterClose returned, which has ALREADY
'' been through fb_ErrorSetNum inside the driver; the decrement path calls
'' fb_ErrorSetNum itself. So both set the error state, by different routes, and
'' neither returns a raw code.

#include once "inc/descriptors.bi"
#include once "inc/file.bi"
#include once "inc/rterror.bi"
#include once "inc/iolock.bi"
#include once "inc/sysbind.bi"

'' DEV_LPT_INFO, from fb_printer.h. driver_opaque IS FIRST BY CONTRACT -- the
'' platform driver casts this straight to its own structure, so nothing may be
'' inserted above it.
type DEV_LPT_INFO
	as any ptr      driver_opaque
	as zstring ptr  pszDevice
	as long         iPort
	as uinteger     uiRefCount     '' size_t: pointer-width
end type

extern "c"   '' NON-FBCALL: the printer driver is fbc's and fb_printer.h
             '' declares all four plainly -- the win32 archive confirms no `@N`
             '' on any of them.
	declare function tkrt_PrinterWrite alias "fb_PrinterWrite" _
		( byval devInfo as DEV_LPT_INFO ptr, byval data_ as any ptr, byval length_ as uinteger ) as long
	declare function tkrt_PrinterWriteWstr alias "fb_PrinterWriteWstr" _
		( byval devInfo as DEV_LPT_INFO ptr, byval data_ as wstring ptr, byval length_ as uinteger ) as long
	declare function tkrt_PrinterClose alias "fb_PrinterClose" _
		( byval devInfo as DEV_LPT_INFO ptr ) as long
end extern

extern "rtlib"   '' FBCALL: fb_ErrorSetNum is decorated.
	declare function tkrt_ErrorSetNum alias "fb_ErrorSetNum" ( byval e as long ) as long
end extern

extern "c"   '' NON-FBCALL: fb_printer.h declares these three plainly too, and
             '' the win32 archive spells them without `@N`.

function tkort_DevLptWrite alias "fb_DevLptWrite" _
	( byval handle as FB_FILE ptr, byval value as any ptr, byval valuelen as uinteger ) as long

	TKORT_IOLOCK()
	dim as long res = tkrt_PrinterWrite( cptr( DEV_LPT_INFO ptr, handle->opaque ), value, valuelen )
	TKORT_IOUNLOCK()

	return res
end function

'' THE WIDE FORM IS A SEPARATE DRIVER ENTRY POINT, not a conversion followed by
'' the narrow one -- the printer decides how to encode, because a PostScript
'' driver and a raw text driver want different things.
function tkort_DevLptWriteWstr alias "fb_DevLptWriteWstr" _
	( byval handle as FB_FILE ptr, byval value as wstring ptr, byval valuelen as uinteger ) as long

	TKORT_IOLOCK()
	dim as long res = tkrt_PrinterWriteWstr( cptr( DEV_LPT_INFO ptr, handle->opaque ), value, valuelen )
	TKORT_IOUNLOCK()

	return res
end function

'' REFERENCE-COUNTED -- see the file header. Only the last close shuts the device
'' down, and only a successful shutdown frees.
function tkort_DevLptClose alias "fb_DevLptClose" ( byval handle as FB_FILE ptr ) as long

	dim as long res = any

	TKORT_IOLOCK()

	dim as DEV_LPT_INFO ptr devInfo = cptr( DEV_LPT_INFO ptr, handle->opaque )

	if( devInfo->uiRefCount = 1 ) then
		res = tkrt_PrinterClose( devInfo )

		'' FREED ONLY IF THE DRIVER AGREED. A failed close leaks rather than
		'' leaving the driver a dangling pointer -- fbc's choice, reproduced.
		if( res = FB_RTERROR_OK ) then
			free( devInfo->pszDevice )
			free( devInfo )
		end if
	else
		devInfo->uiRefCount -= 1
		'' THIS BRANCH SETS THE ERROR STATE ITSELF; the branch above inherits it
		'' from inside fb_PrinterClose. See the file header.
		res = tkrt_ErrorSetNum( FB_RTERROR_OK )
	end if

	TKORT_IOUNLOCK()

	return res
end function

end extern
