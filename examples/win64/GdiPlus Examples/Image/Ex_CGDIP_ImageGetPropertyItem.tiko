' ########################################################################################
' Microsoft Windows
' Contents: GDI+ Flat API - ImageGetPropertyItem example
' Compiler: tiko-lang - Windows 64 bit
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
' Gets a specified property item (piece of metadata) from an image.
' ========================================================================================

' // Create a Bitmap object from a JPEG file.
DIM image AS CGpImage = "climber.jpg"

' // Get the size of the specified property item.
DIM itemSize AS UINT = image.GetPropertyItemSize(PropertyTagLuminanceTable)

' // Allocate buffer and retrieve item
DIM buffer AS STRING = SPACE(itemSize)
DIM status AS LONG = image.GetPropertyItem(PropertyTagLuminanceTable, itemSize, cast(PropertyItem PTR, STRPTR(buffer)))
IF status = StatusOk Then
   DIM propItem AS PropertyItem PTR = cast(PropertyItem PTR, STRPTR(buffer))
   DIM values AS UBYTE PTR = cast(UBYTE PTR, propItem->value)
   PRINT "Luminance Table ("; propItem->length; " bytes):"
   FOR i AS LONG = 0 TO propItem->length - 1
      PRINT values[i]; " ";
      IF (i + 1) MOD 16 = 0 THEN PRINT
   NEXT
ELSE
   PRINT "Failed to retrieve luminance table"
END IF

PRINT
PRINT "Press any key"
SLEEP

' ========================================================================================
