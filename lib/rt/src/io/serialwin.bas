'' serialwin.bas -- the WINDOWS serial driver: fb_SerialOpen, fb_SerialRead,
'' fb_SerialWrite, fb_SerialGetRemaining and fb_SerialClose. Five symbols, one
'' fbc member (win32/io_serial.o).
''
'' EMPTY-ON: linux-x86_64
''
'' THE POSIX HALF IS A DIFFERENT PROGRAM. linux/io_serial.c is 488 lines of
'' termios and ioctl against this one's 317 of DCB and COMMTIMEOUTS; they share
'' fb_serial.h and nothing else. gate.sh deletes fbc's members per target, so
'' taking the Windows half alone is legal.
''
'' EVERY CALLER ARRIVES THROUGH src/io/devcomopen.bas, which has already parsed
'' the option string into an FB_SERIAL_OPTIONS. This file's job is to turn that
'' into a DCB and hand it to the driver.
''
'' THE OPTIONS BLOCK IS BORROWED, NOT COPIED. W32_SERIAL_INFO stores the POINTER
'' fb_SerialOpen was handed, and fb_SerialWrite and fb_SerialRead dereference it
'' on every call to re-check the modem lines. It therefore has to outlive the
'' handle -- which it does, because dev_com.o embeds it inside the DEV_COM_INFO
'' the file handle owns. Copying it here would be a silent behaviour change: a
'' program that altered the options after opening would stop being obeyed.
''
'' PORT NUMBERS ABOVE 9 NEED THE \\.\ PREFIX. "COM10" is not a valid DOS device
'' name and CreateFile will not find it; "\\.\COM10" will. Ports 1..9 are opened
'' by their bare name, and port 0 -- which devcomopen.bas produces for a device
'' path it did not recognise -- is quietly rewritten to COM1. That last one is
'' worth knowing: OPEN "COM:" opens COM1 rather than failing.
''
'' THE COLON IS STRIPPED, NOT THE OPTIONS. The device name arrives as the raw
'' "COM1:9600,N,8,1" and everything from the first colon on is cut. So the
'' options are parsed by dev_com.o and discarded again here.
''
'' fb_hSerialWaitSignal IS A BUSY-WAIT WITH NO SLEEP. It polls
'' GetCommModemStatus in a tight loop until the line asserts or the timeout
'' expires, burning a core for up to DurationCD or DurationDSR milliseconds --
'' which devcomopen.bas defaults to 1000 each. Reproduced: adding a sleep would
'' change the latency of every serial open and write in a way no test would
'' catch but a device might.
''
'' AND ITS CLOCK IS fb_Timer, NOT GetTickCount. fbc's GET_MSEC_TIME() is
'' `(DWORD)( fb_Timer() * 1000.0 )` -- a double seconds counter scaled and
'' truncated into 32 bits. The subtraction that follows is unsigned, so it
'' survives the wrap correctly; using a different clock would not necessarily.
''
'' THE LINES ARE RE-CHECKED ON EVERY READ AND EVERY WRITE, not just at open. A
'' device that drops DSR mid-session makes the next write fail with FILEIO
'' rather than blocking -- and with DurationDSR defaulted to 1000, that write
'' first spins for a second.
''
'' IRQ SELECTION IS REFUSED OUTRIGHT. The IR option parses on every platform but
'' only DOS ever honoured it; here a non-zero IRQNumber is an immediate
'' ILLEGALFUNCTIONCALL, before the port is even named.
''
'' THE DCB BITFIELD LAYOUT IS THE CONTRACT and is reproduced field for field
'' from the SDK: fBinary, fParity, fOutxCtsFlow, fOutxDsrFlow, fDtrControl(2),
'' fDsrSensitivity, fTXContinueOnXoff, fOutX, fInX, fErrorChar, fNull,
'' fRtsControl(2), fAbortOnError, fDummy2(17). Getting one bit out of order does
'' not fail to compile and does not fail to open -- it silently configures the
'' wrong handshake on a real port.

#include once "inc/descriptors.bi"
#include once "inc/rterror.bi"
#include once "inc/file.bi"
#include once "inc/sysbind.bi"

#ifdef __FB_WIN32__

const FB_FILE_ACCESS_READ_      = 1
const FB_FILE_ACCESS_WRITE_     = 2
const FB_FILE_ACCESS_READWRITE_ = 3
const FB_FILE_ACCESS_ANY_       = 0

const GENERIC_READ_  = &h80000000u
const GENERIC_WRITE_ = &h40000000u
const OPEN_EXISTING_ = 3
const INVALID_HANDLE_VALUE_ = cast( any ptr, -1 )

'' Modem status bits, from winbase.h.
const MS_DSR_ON_  = &h0020
const MS_RLSD_ON_ = &h0080

'' DCB.fDtrControl / fRtsControl.
const DTR_CONTROL_DISABLE_ = 0
const DTR_CONTROL_ENABLE_  = 1
const RTS_CONTROL_DISABLE_ = 0
const RTS_CONTROL_HANDSHAKE_ = 2

'' DCB.Parity.
const NOPARITY_    = 0
const ODDPARITY_   = 1
const EVENPARITY_  = 2
const MARKPARITY_  = 3
const SPACEPARITY_ = 4

'' DCB.StopBits.
const ONESTOPBIT_   = 0
const ONE5STOPBITS_ = 1
const TWOSTOPBITS_  = 2

const SETDTR_ = 5

'' FB_SERIAL_PARITY / FB_SERIAL_STOP_BITS, as in src/io/devcomopen.bas.
const FB_SERIAL_PARITY_NONE_  = 0
const FB_SERIAL_PARITY_EVEN_  = 1
const FB_SERIAL_PARITY_ODD_   = 2
const FB_SERIAL_PARITY_SPACE_ = 3
const FB_SERIAL_PARITY_MARK_  = 4

const FB_SERIAL_STOP_BITS_1_   = 0
const FB_SERIAL_STOP_BITS_1_5_ = 1
const FB_SERIAL_STOP_BITS_2_   = 2

'' FB_SERIAL_OPTIONS -- the same seventeen fields as src/io/devcomopen.bas, and
'' the #assert is what keeps the two spellings from drifting apart.
type FB_SERIAL_OPTIONS
	as ulong uiSpeed
	as ulong uiDataBits
	as long  Parity
	as long  StopBits
	as ulong DurationCTS
	as ulong DurationDSR
	as ulong DurationCD
	as ulong OpenTimeout
	as long  SuppressRTS
	as long  AddLF
	as long  CheckParity
	as long  KeepDTREnabled
	as long  DiscardOnError
	as long  IgnoreAllErrors
	as ulong IRQNumber
	as ulong TransmitBuffer
	as ulong ReceiveBuffer
end type

#assert sizeof( FB_SERIAL_OPTIONS ) = 68

'' W32_SERIAL_INFO, from io_serial_private.h. pOptions is BORROWED -- see the
'' file header.
type W32_SERIAL_INFO
	as any ptr               hDevice
	as long                  iPort
	as FB_SERIAL_OPTIONS ptr pOptions
end type

'' THE DCB, FIELD FOR FIELD FROM THE SDK. See the file header on why the bit
'' order is the contract.
type DCB_
	as ulong DCBlength
	as ulong BaudRate
	as ulong fBinary : 1
	as ulong fParity : 1
	as ulong fOutxCtsFlow : 1
	as ulong fOutxDsrFlow : 1
	as ulong fDtrControl : 2
	as ulong fDsrSensitivity : 1
	as ulong fTXContinueOnXoff : 1
	as ulong fOutX : 1
	as ulong fInX : 1
	as ulong fErrorChar : 1
	as ulong fNull : 1
	as ulong fRtsControl : 2
	as ulong fAbortOnError : 1
	as ulong fDummy2 : 17
	as ushort wReserved
	as ushort XonLim
	as ushort XoffLim
	as ubyte  ByteSize
	as ubyte  Parity
	as ubyte  StopBits
	as byte   XonChar
	as byte   XoffChar
	as byte   ErrorChar
	as byte   EofChar
	as byte   EvtChar
	as ushort wReserved1
end type

#assert sizeof( DCB_ ) = 28

type COMMTIMEOUTS_
	as ulong ReadIntervalTimeout
	as ulong ReadTotalTimeoutMultiplier
	as ulong ReadTotalTimeoutConstant
	as ulong WriteTotalTimeoutMultiplier
	as ulong WriteTotalTimeoutConstant
end type

#assert sizeof( COMMTIMEOUTS_ ) = 20

type COMMPROP_
	as ushort wPacketLength
	as ushort wPacketVersion
	as ulong  dwServiceMask
	as ulong  dwReserved1
	as ulong  dwMaxTxQueue
	as ulong  dwMaxRxQueue
	as ulong  dwMaxBaud
	as ulong  dwProvSubType
	as ulong  dwProvCapabilities
	as ulong  dwSettableParams
	as ulong  dwSettableBaud
	as ushort wSettableData
	as ushort wSettableStopParity
	as ulong  dwCurrentTxQueue
	as ulong  dwCurrentRxQueue
	as ulong  dwProvSpec1
	as ulong  dwProvSpec2
	as wstring * 1 wcProvChar
end type

type COMSTAT_
	as ulong fCtsHold : 1
	as ulong fDsrHold : 1
	as ulong fRlsdHold : 1
	as ulong fXoffHold : 1
	as ulong fXoffSent : 1
	as ulong fEof : 1
	as ulong fTxim : 1
	as ulong fReserved : 25
	as ulong cbInQue
	as ulong cbOutQue
end type

#assert sizeof( COMSTAT_ ) = 12

extern "c"   '' NON-FBCALL: kernel32 imports, not rtlib entry points.
	declare function w_CreateFileA stdcall alias "CreateFileA" _
		( byval name_ as zstring ptr, byval access as ulong, byval share as ulong, _
		  byval sec as any ptr, byval disp as ulong, byval flags as ulong, _
		  byval templ as any ptr ) as any ptr
	declare function w_CloseHandle stdcall alias "CloseHandle" ( byval h as any ptr ) as long
	declare function w_ReadFile stdcall alias "ReadFile" _
		( byval h as any ptr, byval buf as any ptr, byval n as ulong, _
		  byval got as ulong ptr, byval ov as any ptr ) as long
	declare function w_WriteFile stdcall alias "WriteFile" _
		( byval h as any ptr, byval buf as any ptr, byval n as ulong, _
		  byval wrote as ulong ptr, byval ov as any ptr ) as long
	declare function w_GetCommModemStatus stdcall alias "GetCommModemStatus" _
		( byval h as any ptr, byval stat_ as ulong ptr ) as long
	declare function w_GetCommProperties stdcall alias "GetCommProperties" _
		( byval h as any ptr, byval prop as COMMPROP_ ptr ) as long
	declare function w_SetupComm stdcall alias "SetupComm" _
		( byval h as any ptr, byval rxq as ulong, byval txq as ulong ) as long
	declare function w_GetCommTimeouts stdcall alias "GetCommTimeouts" _
		( byval h as any ptr, byval t as COMMTIMEOUTS_ ptr ) as long
	declare function w_SetCommTimeouts stdcall alias "SetCommTimeouts" _
		( byval h as any ptr, byval t as COMMTIMEOUTS_ ptr ) as long
	declare function w_GetCommState stdcall alias "GetCommState" _
		( byval h as any ptr, byval d as DCB_ ptr ) as long
	declare function w_SetCommState stdcall alias "SetCommState" _
		( byval h as any ptr, byval d as DCB_ ptr ) as long
	declare function w_EscapeCommFunction stdcall alias "EscapeCommFunction" _
		( byval h as any ptr, byval func_ as ulong ) as long
	declare function w_ClearCommError stdcall alias "ClearCommError" _
		( byval h as any ptr, byval errs as ulong ptr, byval stat_ as COMSTAT_ ptr ) as long
end extern

extern "rtlib"   '' FBCALL: both are decorated on win32.
	declare function tkrt_ErrorSetNum alias "fb_ErrorSetNum" ( byval e as long ) as long
	declare function tkrt_Timer alias "fb_Timer" ( ) as double
end extern

'' fbc's GET_MSEC_TIME() -- fb_Timer scaled to milliseconds and truncated into
'' 32 bits. See the file header on why the clock matters.
private function tkort_msec_time( ) as ulong
	return cast( ulong, fix( tkrt_Timer( ) * 1000.0 ) )
end function

'' A BUSY-WAIT, DELIBERATELY. See the file header.
''
'' THE SUBTRACTION IS UNSIGNED so that a wrap of the 32-bit millisecond counter
'' still yields the correct elapsed time.
private function tkort_SerialWaitSignal _
	( byval hDevice as any ptr, byval dwMask as ulong, byval dwResult as ulong, _
	  byval dwTimeout as ulong ) as long

	dim as ulong dwStartTime = tkort_msec_time( )
	dim as ulong dwModemStatus = 0

	if( w_GetCommModemStatus( hDevice, @dwModemStatus ) = 0 ) then return 0

	while( ((tkort_msec_time( ) - dwStartTime) <= dwTimeout) andalso _
	       ((dwModemStatus and dwMask) <> dwResult) )
		if( w_GetCommModemStatus( hDevice, @dwModemStatus ) = 0 ) then return 0
	wend

	return iif( (dwModemStatus and dwMask) = dwResult, 1, 0 )
end function

'' CD FIRST, THEN DSR, and a zero duration means "do not wait" rather than "wait
'' forever".
private function tkort_SerialCheckLines _
	( byval hDevice as any ptr, byval pOptions as FB_SERIAL_OPTIONS ptr ) as long

	if( pOptions->DurationCD <> 0 ) then
		if( tkort_SerialWaitSignal( hDevice, MS_RLSD_ON_, MS_RLSD_ON_, pOptions->DurationCD ) = 0 ) then
			return 0
		end if
	end if

	if( pOptions->DurationDSR <> 0 ) then
		if( tkort_SerialWaitSignal( hDevice, MS_DSR_ON_, MS_DSR_ON_, pOptions->DurationDSR ) = 0 ) then
			return 0
		end if
	end if

	return 1
end function

extern "c"   '' NON-FBCALL: fb_serial.h declares all five plainly, and the win32
             '' archive spells them without `@N`.

function tkort_SerialOpen alias "fb_SerialOpen" _
	( byval handle as FB_FILE ptr, byval iPort as long, byval options as FB_SERIAL_OPTIONS ptr, _
	  byval pszDevice as zstring ptr, byval ppvHandle as any ptr ptr ) as long

	dim as ulong dwDefaultTxBufferSize = 16384
	dim as ulong dwDefaultRxBufferSize = 16384
	dim as ulong dwDesiredAccess = 0
	dim as zstring ptr pszDev = any, p = any
	dim as any ptr hDevice = any
	dim as long res = any

	'' IRQ SELECTION IS REFUSED BEFORE ANYTHING ELSE -- see the file header.
	if( options->IRQNumber <> 0 ) then
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	res = tkrt_ErrorSetNum( FB_RTERROR_OK )

	select case handle->access
	case FB_FILE_ACCESS_READ_
		dwDesiredAccess = GENERIC_READ_
	case FB_FILE_ACCESS_WRITE_
		dwDesiredAccess = GENERIC_WRITE_
	case FB_FILE_ACCESS_READWRITE_, FB_FILE_ACCESS_ANY_
		dwDesiredAccess = GENERIC_READ_ or GENERIC_WRITE_
	end select

	'' + 5 leaves room for the "\\.\" prefix and the terminator.
	pszDev = cast( zstring ptr, calloc( strlen( pszDevice ) + 5, 1 ) )
	if( pszDev = 0 ) then return tkrt_ErrorSetNum( FB_RTERROR_OUTOFMEM )

	if( iPort = 0 ) then
		'' PORT 0 BECOMES COM1 rather than failing -- see the file header.
		iPort = 1
		strcpy( pszDev, @"COM1:" )
	else
		'' ABOVE NINE NEEDS \\.\ -- "COM10" is not a DOS device name.
		if( iPort > 9 ) then
			strcpy( pszDev, @"\\.\" )
		else
			pszDev[0] = 0
		end if

		strcat( pszDev, pszDevice )
		'' EVERYTHING FROM THE COLON ON IS CUT, options included.
		p = strchr( pszDev, 58 )
		if( p <> 0 ) then p[0] = 0
	end if

	'' EXCLUSIVE ACCESS: share mode must be zero for a COM port.
	hDevice = w_CreateFileA( pszDev, dwDesiredAccess, 0, 0, OPEN_EXISTING_, 0, 0 )

	free( pszDev )

	if( hDevice = INVALID_HANDLE_VALUE_ ) then
		return tkrt_ErrorSetNum( FB_RTERROR_FILENOTFOUND )
	end if

	'' -------------------------------------------------- rx/tx buffer sizes
	if( res = FB_RTERROR_OK ) then
		dim as COMMPROP_ prop
		if( w_GetCommProperties( hDevice, @prop ) = 0 ) then
			res = tkrt_ErrorSetNum( FB_RTERROR_NOPRIVILEGES )
		else
			'' CURRENT beats MAX beats the 16384 default, and an explicit
			'' TB/RB option beats all three.
			if( prop.dwCurrentTxQueue <> 0 ) then
				dwDefaultTxBufferSize = prop.dwCurrentTxQueue
			elseif( prop.dwMaxTxQueue <> 0 ) then
				dwDefaultTxBufferSize = prop.dwMaxTxQueue
			end if

			if( prop.dwCurrentRxQueue <> 0 ) then
				dwDefaultRxBufferSize = prop.dwCurrentRxQueue
			elseif( prop.dwMaxRxQueue <> 0 ) then
				dwDefaultRxBufferSize = prop.dwMaxRxQueue
			end if

			if( options->TransmitBuffer <> 0 ) then dwDefaultTxBufferSize = options->TransmitBuffer
			if( options->ReceiveBuffer <> 0 ) then dwDefaultRxBufferSize = options->ReceiveBuffer

			'' NOTE THE ARGUMENT ORDER: SetupComm takes RX first, TX second.
			if( w_SetupComm( hDevice, dwDefaultRxBufferSize, dwDefaultTxBufferSize ) = 0 ) then
				res = tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
			end if
		end if
	end if

	'' -------------------------------------------------------- timeouts
	if( res = FB_RTERROR_OK ) then
		dim as COMMTIMEOUTS_ timeouts
		if( w_GetCommTimeouts( hDevice, @timeouts ) = 0 ) then
			res = tkrt_ErrorSetNum( FB_RTERROR_NOPRIVILEGES )
		else
			'' THE CS OPTION IS REUSED AS A READ TIMEOUT. CS is documented as
			'' the CTS wait, and here it also becomes ReadIntervalTimeout with
			'' both totals zeroed -- one option driving two unrelated settings.
			if( options->DurationCTS <> 0 ) then
				timeouts.ReadIntervalTimeout = options->DurationCTS
				timeouts.ReadTotalTimeoutMultiplier = 0
				timeouts.ReadTotalTimeoutConstant = 0
			end if
			if( w_SetCommTimeouts( hDevice, @timeouts ) = 0 ) then
				res = tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
			end if
		end if
	end if

	'' ------------------------------------------------------ the DCB itself
	if( res = FB_RTERROR_OK ) then
		dim as DCB_ dcb
		dcb.DCBlength = sizeof( DCB_ )
		if( w_GetCommState( hDevice, @dcb ) = 0 ) then
			res = tkrt_ErrorSetNum( FB_RTERROR_NOPRIVILEGES )
		else
			dcb.BaudRate = options->uiSpeed
			'' fbc's own comment: Windows only supports binary mode. AddLF is
			'' therefore inverted into fBinary and does nothing else.
			dcb.fBinary = iif( options->AddLF <> 0, 0, 1 )
			dcb.fParity = iif( options->CheckParity <> 0, 1, 0 )
			dcb.fOutxCtsFlow = iif( options->DurationCTS <> 0, 1, 0 )
			dcb.fDtrControl = iif( options->KeepDTREnabled <> 0, _
			                       DTR_CONTROL_ENABLE_, DTR_CONTROL_DISABLE_ )

			dcb.fDsrSensitivity = iif( options->DurationDSR <> 0, 1, 0 )
			dcb.fOutxDsrFlow = 0

			'' No XON/XOFF, ever.
			dcb.fOutX = 0
			dcb.fInX = 0
			dcb.fNull = 0

			dcb.fRtsControl = iif( options->SuppressRTS <> 0, _
			                       RTS_CONTROL_DISABLE_, RTS_CONTROL_HANDSHAKE_ )

			dcb.fAbortOnError = 0
			dcb.ByteSize = cast( ubyte, options->uiDataBits )

			select case options->Parity
			case FB_SERIAL_PARITY_NONE_  : dcb.Parity = NOPARITY_
			case FB_SERIAL_PARITY_EVEN_  : dcb.Parity = EVENPARITY_
			case FB_SERIAL_PARITY_ODD_   : dcb.Parity = ODDPARITY_
			case FB_SERIAL_PARITY_SPACE_ : dcb.Parity = SPACEPARITY_
			case FB_SERIAL_PARITY_MARK_  : dcb.Parity = MARKPARITY_
			end select

			select case options->StopBits
			case FB_SERIAL_STOP_BITS_1_   : dcb.StopBits = ONESTOPBIT_
			case FB_SERIAL_STOP_BITS_1_5_ : dcb.StopBits = ONE5STOPBITS_
			case FB_SERIAL_STOP_BITS_2_   : dcb.StopBits = TWOSTOPBITS_
			end select

			if( w_SetCommState( hDevice, @dcb ) = 0 ) then
				res = tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
			else
				'' DTR IS RAISED UNCONDITIONALLY on success, whatever
				'' fDtrControl was just set to.
				w_EscapeCommFunction( hDevice, SETDTR_ )
			end if
		end if
	end if

	'' THE LINE CHECK RUNS EVEN IF SOMETHING ABOVE ALREADY FAILED -- it is not
	'' inside an `if res = OK`, so a port that failed to configure still spends
	'' up to DurationCD + DurationDSR milliseconds here before being closed.
	if( tkort_SerialCheckLines( hDevice, options ) = 0 ) then
		res = tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	if( res <> FB_RTERROR_OK ) then
		w_CloseHandle( hDevice )
	else
		dim as W32_SERIAL_INFO ptr pInfo = _
			cast( W32_SERIAL_INFO ptr, calloc( 1, sizeof( W32_SERIAL_INFO ) ) )
		*ppvHandle = pInfo
		pInfo->hDevice = hDevice
		pInfo->iPort = iPort
		'' BORROWED, NOT COPIED -- see the file header.
		pInfo->pOptions = options
	end if

	return res
end function

'' THE COUNT IS TRUNCATED TO A **LONG** on its way into fb_off_t, which is 64
'' bits -- so a queue depth above 2^31 would come back negative. It cannot in
'' practice, the queue being at most a few tens of kilobytes, but the cast is
'' fbc's and is reproduced rather than widened.
function tkort_SerialGetRemaining alias "fb_SerialGetRemaining" _
	( byval handle as FB_FILE ptr, byval pvHandle as any ptr, byval pLength as longint ptr ) as long

	dim as W32_SERIAL_INFO ptr pInfo = cast( W32_SERIAL_INFO ptr, pvHandle )
	dim as ulong dwErrors = any
	dim as COMSTAT_ Status_

	if( w_ClearCommError( pInfo->hDevice, @dwErrors, @Status_ ) = 0 ) then
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if
	if( pLength <> 0 ) then *pLength = cast( long, Status_.cbInQue )
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

'' A SHORT WRITE IS AN ERROR, not a partial success: the count is compared and
'' anything less than the whole block is FILEIO, with no indication of how much
'' actually went out.
function tkort_SerialWrite alias "fb_SerialWrite" _
	( byval handle as FB_FILE ptr, byval pvHandle as any ptr, _
	  byval data_ as any ptr, byval length_ as uinteger ) as long

	dim as W32_SERIAL_INFO ptr pInfo = cast( W32_SERIAL_INFO ptr, pvHandle )
	dim as ulong dwWriteCount = any

	if( tkort_SerialCheckLines( pInfo->hDevice, pInfo->pOptions ) = 0 ) then
		return tkrt_ErrorSetNum( FB_RTERROR_FILEIO )
	end if

	if( w_WriteFile( pInfo->hDevice, data_, cast( ulong, length_ ), @dwWriteCount, 0 ) = 0 ) then
		return tkrt_ErrorSetNum( FB_RTERROR_FILEIO )
	end if

	if( length_ <> cast( uinteger, dwWriteCount ) ) then
		return tkrt_ErrorSetNum( FB_RTERROR_FILEIO )
	end if

	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

'' A SHORT READ IS FINE, unlike a short write: the caller's length is OVERWRITTEN
'' with what arrived.
function tkort_SerialRead alias "fb_SerialRead" _
	( byval handle as FB_FILE ptr, byval pvHandle as any ptr, _
	  byval data_ as any ptr, byval pLength as uinteger ptr ) as long

	dim as W32_SERIAL_INFO ptr pInfo = cast( W32_SERIAL_INFO ptr, pvHandle )
	dim as ulong dwReadCount = any

	if( tkort_SerialCheckLines( pInfo->hDevice, pInfo->pOptions ) = 0 ) then
		return tkrt_ErrorSetNum( FB_RTERROR_FILEIO )
	end if

	if( w_ReadFile( pInfo->hDevice, data_, cast( ulong, *pLength ), @dwReadCount, 0 ) = 0 ) then
		return tkrt_ErrorSetNum( FB_RTERROR_FILEIO )
	end if

	*pLength = cast( uinteger, dwReadCount )

	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

'' NEITHER THE HANDLE NOR THE OPTIONS BLOCK IS CHECKED, and the options are not
'' freed -- they belong to the DEV_COM_INFO that outlives this.
function tkort_SerialClose alias "fb_SerialClose" _
	( byval handle as FB_FILE ptr, byval pvHandle as any ptr ) as long

	dim as W32_SERIAL_INFO ptr pInfo = cast( W32_SERIAL_INFO ptr, pvHandle )
	w_CloseHandle( pInfo->hDevice )
	free( pInfo )
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

end extern

#endif
