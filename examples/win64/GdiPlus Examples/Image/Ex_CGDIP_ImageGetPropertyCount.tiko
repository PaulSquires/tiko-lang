' ########################################################################################
' Microsoft Windows
' Contents: GDI+ Flat API - ImageGetPropertyCount example
' Compiler: tiko-lang
' Copyright (c) 2026 José Roca. Freeware. Use at your own risk.
' THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
' EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
' MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
' ########################################################################################

#import "sys/win"
#import "sys/win/gdiplus"
using win, gdiplus

#cmdline "-s console"

' ========================================================================================
' The following example retrieves the property count of an image.
' ========================================================================================

' // Create a Bitmap object from a JPEG file.
DIM image AS CGpImage = "climber.jpg"

' // Get the property count
DIM count AS UINT = image.GetPropertyCount
PRINT "Property count: " & WSTR(count)

PRINT
PRINT "Press any key"
SLEEP

' ========================================================================================
