' ########################################################################################
' Microsoft Windows
' Contents: GDI+ Flat API - ImageGetVerticalResolution example
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
' The following example retrieves the the vertical resolution, in dots per inch, of an image.
' ========================================================================================

' // Create a Bitmap object from a JPEG file.
DIM image AS CGpImage = "climber.jpg"

' // Get the vertical resolution of the image
DIM resolution AS SINGLE = image.GetVerticalResolution
PRINT "The vertical resolution is " & STR(resolution) & " dots per inch"

PRINT
PRINT "Press any key"
SLEEP

' ========================================================================================
