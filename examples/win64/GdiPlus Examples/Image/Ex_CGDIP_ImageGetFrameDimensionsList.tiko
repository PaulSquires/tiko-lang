' ########################################################################################
' Microsoft Windows
' Contents: GDI+ Flat API - ImageGetFrameDimensionsList example
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
' Get the list of frame dimensions from the Image object.
' ========================================================================================

' // Create a Bitmap object from a JPEG file.
DIM image AS CGpImage = "MultiFrame.tiff"

' // How many frame dimensions does the Image object have?
DIM nCount AS UINT = image.GetFrameDimensionsCount
PRINT "The number of dimensions is " & STR(nCount)

' // Get the list of frame dimensions from the Image object.
DIM rgDimensionIDs(nCount - 1) AS GUID
image.GetFrameDimensionsList(@rgDimensionIDs(0), nCount)

' // Display the GUID of the first (and only) frame dimension.
DIM strGuid AS STRING = GuidText(rgDimensionIDs(0))
PRINT "The first (and only) dimension ID is " & strGuid

' // Get the number of frames in the first dimension.
DIM frameCount AS UINT = image.GetFrameCount(@rgDimensionIDs(0))
PRINT "The number of frames in that dimension is " & STR(frameCount)

PRINT
PRINT "Press any key"
SLEEP

' ========================================================================================
