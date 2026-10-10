' ########################################################################################
' Platform: Microsoft Windows
' Filename: ShellScalingApi.bi
' Compiler: FreeBASIC 32 & 64 bit
' Translated by José Roca, 2026.
' ########################################################################################

#pragma once

#inclib "user32"

#include once "winapifamily.bi"
#include once "win/shtypes.bi"

#ifndef SCALING_ENUMS_DECLARED

'// The scaling API only operates over the primary display and the immersive display.  Scaling information
'// is not provided for displays other than those.
'// This enum matches #defines in IETouch.h.  Don't update this without keeping that in sync.

type DISPLAY_DEVICE_TYPE AS LONG
enum
   DEVICE_PRIMARY = 0
   DEVICE_IMMERSIVE = 1
end enum

type SCALE_CHANGE_FLAGS AS LONG
enum
   SCF_VALUE_NONE = &h00
   SCF_SCALE = &h01
   SCF_PHYSICAL = &h02
end enum

#define SCALING_ENUMS_DECLARED
#endif

'#if (NTDDI_VERSION >= NTDDI_WIN8)

'// Given a display device, return the preferred DEVICE_SCALE_FACTOR to be used for scaling values.
'// Default is SCALE_100_PERCENT
' This function is not supported as of Windows 8.1. Use GetScaleFactorForMonitor instead.
DECLARE FUNCTION GetScaleFactorForDevice LIB "shcore.dll" ALIAS "GetScaleFactorForDevice" (BYVAL deviceType AS DISPLAY_DEVICE_TYPE) AS DEVICE_SCALE_FACTOR

'// Register a window to receive callbacks when scaling information changes.  The uMsgNotify param specifies a message
'// that will be posted to the requesting window. The wParam for this message is a combination of SCALE_CHANGE_FLAGS
' This function is not supported as of Windows 8.1. Use RegisterScaleChangeEvent instead.
DECLARE FUNCTION RegisterScaleChangeNotifications LIB "shcore.dll" ALIAS "RegisterScaleChangeNotifications" (BYVAL displayDevice AS DISPLAY_DEVICE_TYPE, BYVAL hwndNotify AS HWND, BYVAL uMsgNotify AS UINT, BYVAL pdwCookie AS DWORD PTR) AS HRESULT
' This function is not supported as of Windows 8.1. Use UnregisterScaleChangeEvent instead.
DECLARE FUNCTION RevokeScaleChangeNotifications LIB "shcore.dll" ALIAS "RevokeScaleChangeNotifications" (BYVAL displayDevice AS DISPLAY_DEVICE_TYPE, BYVAL dwCookie AS DWORD) AS HRESULT

'#endif // (NTDDI_VERSION >= NTDDI_WIN8)

'#if (NTDDI_VERSION >= NTDDI_WINBLUE)

DECLARE FUNCTION GetScaleFactorForMonitor LIB "shcore.dll" ALIAS "GetScaleFactorForMonitor" (BYVAL hMon AS HMONITOR, BYVAL pScale AS DEVICE_SCALE_FACTOR PTR) AS HRESULT
DECLARE FUNCTION RegisterScaleChangeEvent LIB "shcore.dll" ALIAS "RegisterScaleChangeEvent" (BYVAL hEvent AS HANDLE, BYVAL pdwCookie AS DWORD_PTR PTR) AS HRESULT
DECLARE FUNCTION UnregisterScaleChangeEvent LIB "shcore.dll" ALIAS "UnregisterScaleChangeEvent" (BYVAL dwCookie AS DWORD_PTR) AS HRESULT

'#endif // (NTDDI_VERSION >= NTDDI_WINBLUE)

#ifndef DPI_ENUMS_DECLARED

' // Identifies dots per inch (dpi) awareness values.
type PROCESS_DPI_AWARENESS AS LONG
enum
  PROCESS_DPI_UNAWARE = 0
  PROCESS_SYSTEM_DPI_AWARE = 1
  PROCESS_PER_MONITOR_DPI_AWARE = 2
end enum

' // Identifies the dots per inch (dpi) setting for a monitor.
type MONITOR_DPI_TYPE AS LONG
enum
  MDT_EFFECTIVE_DPI = 0
  MDT_ANGULAR_DPI = 1
  MDT_RAW_DPI = 2
  MDT_DEFAULT
end enum

#define DPI_ENUMS_DECLARED
#endif ' // (DPI_ENUMS_DECLARED)

'#if (NTDDI_VERSION >= NTDDI_WINBLUE)

DECLARE FUNCTION SetProcessDpiAwareness LIB "shcore.dll" ALIAS "SetProcessDpiAwareness" (BYVAL value AS PROCESS_DPI_AWARENESS) AS HRESULT
DECLARE FUNCTION GetProcessDpiAwareness LIB "shcore.dll" ALIAS "GetProcessDpiAwareness" (BYVAL hprocess AS HANDLE, BYVAL value AS PROCESS_DPI_AWARENESS PTR) AS HRESULT
DECLARE FUNCTION GetDpiForMonitor LIB "shcore.dll" ALIAS "GetDpiForMonitor" (BYVAL hMonitor AS HMONITOR, BYVAL dpiTYpe AS MONITOR_DPI_TYPE, BYVAL dpiX AS UINT PTR, BYVAL dpiY AS UINT PTR) AS HRESULT

'#endif // (NTDDI_VERSION >= NTDDI_WINBLUE)

'#if (NTDDI_VERSION >= NTDDI_WINTHRESHOLD)

#ifndef SHELL_UI_COMPONENT_ENUMS_DECLARED

type SHELL_UI_COMPONENT AS LONG
enum
   SHELL_UI_COMPONENT_TASKBARS         = 0
   SHELL_UI_COMPONENT_NOTIFICATIONAREA = 1
   SHELL_UI_COMPONENT_DESKBAND         = 2
end enum

#define SHELL_UI_COMPONENT_ENUMS_DECLARED
#endif ' // (SHELL_UI_COMPONENT_ENUMS_DECLARED)

DECLARE FUNCTION GetDpiForShellUIComponent LIB "shcore.dll" ALIAS "GetDpiForShellUIComponent" (BYVAL AS SHELL_UI_COMPONENT) AS UINT

'#endif // (NTDDI_VERSION >= NTDDI_WINTHRESHOLD)

