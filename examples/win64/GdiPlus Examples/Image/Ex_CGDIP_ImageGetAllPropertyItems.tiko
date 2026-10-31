' ########################################################################################
' Microsoft Windows
' Contents: GDI+ Flat API - ImageGetAllPropertyItems example
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
' The following example creates an Image object based on a JPEG file. The code calls the
' GdipGetAllPropertyItems function to obtain its property items (metadata).
' ========================================================================================

DIM status AS LONG

' // Create a Bitmap object from a JPEG file.
DIM image AS CGpImage = "climber.jpg"

' // Get total buffer size and number of properties
DIM totalSize AS UINT, numProps AS UINT, buffer AS UBYTE PTR
status = image.GetPropertySize(@totalSize, @numProps)
IF status = 0 THEN
   ' // Allocate buffer and retrieve all property items
   buffer = Allocate(totalSize)
   status = image.GetAllPropertyItems(totalSize, numProps, cast(PropertyItem PTR, buffer))
   IF status = 0 THEN
      DIM propItem AS PropertyItem PTR
      FOR i AS LONG = 0 TO numProps - 1
         propItem = cast(PropertyItem PTR, buffer + i * SIZEOF(PropertyItem))
         PRINT "Property ID: &h"; HEX(propItem->id)
         PRINT "Type: "; propItem->type; " Length: "; propItem->length
         SELECT CASE propItem->type
            CASE PropertyTagTypeASCII
               PRINT "Value: "; *cast(ZSTRING PTR, propItem->value)
            CASE PropertyTagTypeByte
               DIM b AS UBYTE PTR = Cast(UBYTE PTR, propItem->value)
               FOR j AS LONG = 0 TO propItem->length - 1
                  PRINT b[j]; " ";
               NEXT
               PRINT
            CASE PropertyTagTypeShort
               DIM s AS USHORT PTR = cast(USHORT PTR, propItem->value)
                  FOR j AS LONG = 0 TO propItem->length \ 2 - 1
                     PRINT s[j]; " ";
                  NEXT
                  PRINT
            CASE PropertyTagTypeLong
               DIM l AS ULONG PTR = cast(ULONG PTR, propItem->value)
               FOR j AS LONG = 0 TO propItem->length \ 4 - 1
                  PRINT l[j]; " ";
               NEXT
               PRINT
            CASE ELSE
               PRINT "Unsupported type"
         END SELECT
         PRINT "---------------------------"
      NEXT
   ELSE
      PRINT "Failed to retrieve property items"
   END IF
END IF

' // Cleanup
IF buffer THEN Deallocate(buffer)

PRINT
PRINT "Press any key"
SLEEP

' ========================================================================================
