' TEST_MODE : COMPILE_AND_RUN_OK

'' The phase-5 port, asserted rather than eyeballed.
''
'' examples/win32/desktop_shortcut.bas and examples/win32/desktop_shortcut_comptr.bas
'' are the same program written two ways.  This file runs the refcount-bearing
'' part of each flow against a LIVE CLSID_ShellLink and asserts that the two
'' produce the IDENTICAL sequence of reference counts at the identical points.
''
'' That is the rank-10 criterion: "refcounts asserted identical before and after".
'' Without it the port rests on the program still appearing to work, which is
'' exactly the standard a refcount bug survives.
''
'' Save( ) is deliberately NOT called in either flow -- it is not a refcount
'' operation, and calling it would litter the desktop of whoever runs the suite.

#include once "win/objbase.bi"
#include once "win/shlobj.bi"
#include once "fb/comptr.bi"
using FB

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

type ILinkW extends ComUnknown
	declare abstract function GetPath( byval psz as wstring ptr, byval cch as long, byval pfd as any ptr, byval fl as ulong ) as HRESULT
	declare abstract function GetIDList( byval ppidl as any ptr ptr ) as HRESULT
	declare abstract function SetIDList( byval pidl as any ptr ) as HRESULT
	declare abstract function GetDescription( byval psz as wstring ptr, byval cch as long ) as HRESULT
	declare abstract function SetDescription( byval psz as const wstring ptr ) as HRESULT
	declare abstract function GetWorkingDirectory( byval psz as wstring ptr, byval cch as long ) as HRESULT
	declare abstract function SetWorkingDirectory( byval psz as const wstring ptr ) as HRESULT
	declare abstract function GetArguments( byval psz as wstring ptr, byval cch as long ) as HRESULT
	declare abstract function SetArguments( byval psz as const wstring ptr ) as HRESULT
	declare abstract function GetHotkey( byval pwHotkey as ushort ptr ) as HRESULT
	declare abstract function SetHotkey( byval wHotkey as ushort ) as HRESULT
	declare abstract function GetShowCmd( byval piShowCmd as long ptr ) as HRESULT
	declare abstract function SetShowCmd( byval iShowCmd as long ) as HRESULT
	declare abstract function GetIconLocation( byval psz as wstring ptr, byval cch as long, byval piIcon as long ptr ) as HRESULT
	declare abstract function SetIconLocation( byval psz as const wstring ptr, byval iIcon as long ) as HRESULT
	declare abstract function SetRelativePath( byval psz as const wstring ptr, byval dw as ulong ) as HRESULT
	declare abstract function Resolve( byval hwnd_ as HWND, byval fl as ulong ) as HRESULT
	declare abstract function SetPath( byval psz as const wstring ptr ) as HRESULT
end type

type IPFile extends ComUnknown
	declare abstract function GetClassID( byval pClassID as GUID ptr ) as HRESULT
	declare abstract function IsDirty( ) as HRESULT
	declare abstract function Load( byval pszFileName as const wstring ptr, byval dwMode as ulong ) as HRESULT
	declare abstract function Save( byval pszFileName as const wstring ptr, byval fRemember as long ) as HRESULT
	declare abstract function SaveCompleted( byval pszFileName as const wstring ptr ) as HRESULT
	declare abstract function GetCurFile( byval ppszFileName as ushort ptr ptr ) as HRESULT
end type

dim shared as GUID IID_ILinkW = type<GUID>( &h000214F9, &h0000, &h0000, _
                                            { &hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46 } )
dim shared as GUID IID_IPFile = type<GUID>( &h0000010B, &h0000, &h0000, _
                                            { &hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46 } )

COM_IID( ILinkW, IID_ILinkW )
COM_IID( IPFile, IID_IPFile )

'' AddRef then Release, so measuring does not itself change the count.
private function RC( byval p as any ptr ) as long
	if( p = 0 ) then return -1
	dim as ComUnknown ptr u = cptr( ComUnknown ptr, p )
	dim as ULONG n = u->AddRef( )
	u->Release( )
	return n - 1
end function

'' Four observation points, recorded identically by both flows.
type Trace_
	as long afterCreate
	as long afterQuery
	as long afterReleasingQueried
	as boolean queriedIsDifferentPointer
end type

'' ------------------------------------------ flow A: the ORIGINAL, by hand
''
'' CoCreateInstance, QueryInterface, use, Release both -- the shape
'' desktop_shortcut.bas has today, written with the C-style calls it uses.

private function RawFlow( byref t as Trace_ ) as HRESULT
	dim as any ptr rawLink = 0
	dim as HRESULT hr = CoCreateInstance( @CLSID_ShellLink, NULL, CLSCTX_INPROC_SERVER, _
	                                      @IID_ILinkW, @rawLink )
	if( failed( hr ) ) then return hr
	t.afterCreate = RC( rawLink )

	dim as ILinkW ptr link = cptr( ILinkW ptr, rawLink )
	hr = link->SetPath( @wstr( "C:\Windows\explorer.exe" ) )
	if( failed( hr ) ) then link->Release( ) : return hr

	dim as any ptr rawFile = 0
	hr = link->QueryInterface( @IID_IPFile, @rawFile )
	if( failed( hr ) ) then link->Release( ) : return hr
	t.afterQuery = RC( rawLink )
	t.queriedIsDifferentPointer = ( rawFile <> rawLink )

	dim as IPFile ptr file = cptr( IPFile ptr, rawFile )
	file->Release( )
	t.afterReleasingQueried = RC( rawLink )

	link->Release( )
	return S_OK
end function

'' ------------------------------------------- flow B: the SAME, with ComPtr
''
'' Every explicit Release is gone; the observation points are the same.

private function ComPtrFlow( byref t as Trace_ ) as HRESULT
	dim as ComPtr( of ILinkW ) link
	dim as HRESULT hr = CoCreateInstance( @CLSID_ShellLink, NULL, CLSCTX_INPROC_SERVER, _
	                                      @IID_ILinkW, cptr( any ptr ptr, link.PutRef( ) ) )
	if( failed( hr ) ) then return hr
	t.afterCreate = RC( link.Get( ) )

	hr = link->SetPath( @wstr( "C:\Windows\explorer.exe" ) )
	if( failed( hr ) ) then return hr          '' no Release needed on this path

	scope
		dim as ComPtr( of IPFile ) file
		hr = ComCast( of ILinkW, IPFile )( link, file )
		if( failed( hr ) ) then return hr      '' nor this one
		t.afterQuery = RC( link.Get( ) )
		t.queriedIsDifferentPointer = ( cast( any ptr, file.Get( ) ) <> cast( any ptr, link.Get( ) ) )
	end scope                                  '' file released HERE
	t.afterReleasingQueried = RC( link.Get( ) )

	return S_OK
end function                                   '' link released HERE

'' ------------------------------------------------------------------- main

scope
	dim as ComInit co
	assert_( co.Ok( ) )

	dim as Trace_ raw_, com_
	assert_( RawFlow( raw_ ) = S_OK )
	assert_( ComPtrFlow( com_ ) = S_OK )

	'' The counts themselves are not asserted against fixed numbers -- a real
	'' object's refcount is its own business and the shell is entitled to hold
	'' references of its own.  What is asserted is that the two flows AGREE at
	'' every point, which is what "identical before and after" means.
	assert_( raw_.afterCreate = com_.afterCreate )
	assert_( raw_.afterQuery = com_.afterQuery )
	assert_( raw_.afterReleasingQueried = com_.afterReleasingQueried )
	assert_( raw_.queriedIsDifferentPointer = com_.queriedIsDifferentPointer )

	'' And that the query actually moved the count, so the comparison above is
	'' not comparing two flows that both did nothing.
	assert_( com_.afterQuery > com_.afterCreate )
	assert_( com_.afterReleasingQueried = com_.afterCreate )

	'' IShellLink and IPersistFile on a shell link are genuinely different
	'' pointers, which is why ComCast must be a QueryInterface and not a cast.
	'' Recorded rather than asserted: it is the shell's implementation detail,
	'' and the test must not fail if a future Windows changes it.
	print "  IPersistFile is a different pointer from IShellLink: "; com_.queriedIsDifferentPointer
end scope

print "comptr-port-equivalence: ok"
