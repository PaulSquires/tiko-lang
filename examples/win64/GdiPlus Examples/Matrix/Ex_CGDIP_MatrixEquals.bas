' ########################################################################################
' Microsoft Windows
' Contents: GDI+ - MatrixEquals example
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

' // Must be constructed with NEW to we able to delete them before the call to AfxGdipShutdown
DIM pMat1 AS CGpMatrix PTR = NEW CGpMatrix(1.0, 2.0, 1.0, 1.0, 2.0, 2.0)
DIM pMat2 AS CGpMatrix PTR = NEW CGpMatrix(1.0, 2.0, 1.0, 1.0, 2.0, 2.0)

IF pMat1->Equals(pMat2) THEN
   PRINT "They are the same"
ELSE
   PRINT "They are the different"
END IF

' // Must be deleted before the call to AfxGdipShutdown
Delete pMat1
Delete pMat2

PRINT
PRINT "Press any key"
SLEEP
