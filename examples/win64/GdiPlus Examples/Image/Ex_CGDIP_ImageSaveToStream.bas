' ########################################################################################
' Microsoft Windows
' Contents: GDI+ Flat API - ImageSaveToStream example
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
' The following example retrieves the width of an image.
' ========================================================================================

' // Create two image objects.
DIM image1 AS CGpImage = "Iron.jpg"
DIM image2 AS CGpImage = "House.jpg"

' // Create compound file
DIM storage AS IStorage PTR
DIM compoundFileName AS WSTRING * 260 = "CompoundFile.cmp"
StgCreateDocfile(@compoundFileName, STGM_READWRITE OR STGM_CREATE OR STGM_SHARE_EXCLUSIVE, 0, @storage)

' Create two streams
DIM stream1 AS IStream PTR
DIM stream2 AS IStream PTR
DIM streamName1 AS WSTRING * 260 = "StreamImage1"
DIM streamName2 AS WSTRING * 260 = "StreamImage2"
storage->lpvtbl->CreateStream(storage, @streamName1, STGM_READWRITE Or STGM_SHARE_EXCLUSIVE, 0, 0, @stream1)
storage->lpvtbl->CreateStream(storage, @streamName2, STGM_READWRITE Or STGM_SHARE_EXCLUSIVE, 0, 0, @stream2)

' // Get encoder CLSIDs
DIM jpgClsid AS CLSID = GetEncoderClsid("image/jpeg")
DIM pngClsid AS CLSID = GetEncoderClsid("image/png")

' // Save images to streams
image1.Save(stream1, @jpgClsid, NULL)
image2.Save(stream2, @pngClsid, NULL)

PRINT "File saved"

PRINT
PRINT "Press any key"
SLEEP

' ========================================================================================
