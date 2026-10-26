' ########################################################################################
' Microsoft Windows
' Contents: GDI+ Flat API - ImageGetRawFormat example
' Compiler: tiko-lang
' Copyright (c) 2026 José Roca. Freeware. Use at your own risk.
' THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
' EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
' MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
' ########################################################################################

#import "sys/win"
#import "sys/win/gdiplus"
#import "sys/win/com"
using win, gdiplus, com

#cmdline "-s console"

' ========================================================================================
' Gets a globally unique identifier ( GUID) that identifies the format of an Image object.
' ========================================================================================

' // Create a Bitmap object from a JPEG file.
DIM image AS CGpImage = "climber.jpg"

' // Get the pixel format
DIM rguid AS GUID = image.GetRawFormat
PRINT "Gud: " & GuidText(rguid)

PRINT
PRINT "Press any key"
SLEEP

' ========================================================================================
