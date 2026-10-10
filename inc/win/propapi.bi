' ########################################################################################
' Platform: Microsoft Windows
' Filename: propapi.bi
' Contents: Structured storage properties APIs
' Purpose:  Translation of propapi.h header
' Compiler: FreeBASIC 32 & 64 bit
' 2026 José Roca
' ########################################################################################

#pragma once
#include once "winapifamily.bi"

type NTPROP AS VOID PTR

#include once "win/propidl.bi"

extern "Windows"

DECLARE FUNCTION StgPropertyLengthAsVariant LIB "ole32.dll" ALIAS "StgPropertyLengthAsVariant" ( _
   BYVAL pProp AS const SERIALIZEDPROPERTYVALUE PTR, BYVAL cbProp AS ULONG, BYVAL CodePage AS USHORT, BYVAL bReserved AS BYTE) AS ULONG

end extern
