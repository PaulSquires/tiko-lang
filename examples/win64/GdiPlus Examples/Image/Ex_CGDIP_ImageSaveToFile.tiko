' ########################################################################################
' Microsoft Windows
' Contents: GDI+ Flat API - ImageSaveToFile example
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
' The following code saves a file to disk.
' ========================================================================================

' // Create a Bitmap object from a JPEG file.
DIM image AS CGpImage = "climber.jpg"

' // Get the encoder GUID for the .png image type
DIM clsidEncoder AS GUID = GetEncoderClsid("image/png")

' // Save the file with another name and format
IF image.Save("saved.png", @clsidEncoder, NULL) = StatusOk THEN
   PRINT "File saved"
ELSE
   PRINT "Failed to save the file"
END IF

PRINT
PRINT "Press any key"
SLEEP

' ========================================================================================
