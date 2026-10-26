' ########################################################################################
' Microsoft Windows
' Contents: GDI+ Flat API - ImageGetPropertyIdList example
' Compiler: tiko-lang - Windows 64 bit
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
' Gets a list of the property identifiers used in the metadata of an Image object.
' ========================================================================================

' // Create a Bitmap object from a JPEG file.
DIM image AS CGpImage = "climber.jpg"

' // Get the pixel format
DIM rguid AS GUID = image.GetRawFormat
PRINT "Gud: " & GuidText(rguid)

' // Get the number of properties
DIM count AS UINT = Image.GetPropertyCount
PRINT "Number of properties = " & STR(count)

' // Get the list of properties
DIM propIDs(count - 1) AS PROPID
image.GetPropertyIdList(count, @propIDs(0))
FOR i AS LONG = 0 TO count - 1
   PRINT "PROPID: &h" & HEX(propIDs(i))
NEXT

PRINT
PRINT "Press any key"
SLEEP

' ========================================================================================
