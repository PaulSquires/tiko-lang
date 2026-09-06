'' keyboard.bi -- the key ring behind INKEY, GETKEY and KEYHIT, and MULTIKEY.
''
'' Derived from: gfx_inkey.c (fb_hPostKey, get_key, fb_GfxInkey, fb_GfxGetkey,
'' fb_GfxKeyHit, fb_hGfxInputBufferChanged), gfx_multikey.c.
'' LGPL-2.1-or-later with the static-linking exception.
''
'' TWO SEPARATE MECHANISMS, AND CONFLATING THEM IS THE USUAL MISTAKE.
''
''   the KEY RING     a 16-entry queue of key CODES, fed by the driver from
''                    character and key-down messages. INKEY, GETKEY and KEYHIT
''                    read it. It is about what was TYPED, in order.
''   the KEY TABLE    128 booleans indexed by SCANCODE, refreshed wholesale from
''                    GetKeyboardState every frame. MULTIKEY reads it. It is
''                    about what is HELD DOWN right now.
''
'' A key held for a second appears once in the ring and stays true in the table
'' the whole time. Neither can answer the other's question.
''
'' THE RING DROPS THE OLDEST, exactly like the event queue: a post that would
'' collide with the head advances the head instead of failing. Sixteen slots, so
'' the usable capacity is FIFTEEN -- measured, by posting twenty and reading
'' back fifteen.
''
'' INKEY'S ENCODING IS JUST THE 16-BIT VALUE, LITTLE-ENDIAN. Measured, not
'' assumed:
''
''   key <= 255    a one-character string, chr(key)
''   key >  255    a TWO-character string, chr(key and 255) then chr(key shr 8)
''
'' There is no "extended key" flag in the encoding. The familiar chr(255) prefix
'' appears because extended keys are posted as `(scancode shl 8) or 255`, so the
'' low byte -- emitted first -- happens to be 255. Special-casing 255 rather than
'' emitting the low byte gives the same answer for every extended key and the
'' wrong one for everything else above 255.
''
'' THE "BUFFER CHANGED" FLAG IS CLEARED BY READING IT, and also by taking a key
'' off the ring. It exists so the console layer can tell that input arrived
'' without consuming it.

#pragma once

namespace TkoGfx

'' gfx_inkey.c. A power of two, and the wrap is a mask.
const KEY_BUFFER_LEN = 16

'' gfx_multikey.c accepts 0..127 and nothing else.
const KEY_TABLE_LEN = 128

type KeyRing
    head    as long
    tail    as long
    changed as long
    slot(0 to KEY_BUFFER_LEN - 1) as long
end type

private sub KeyRingInit( byref k as KeyRing )
    k.head = 0
    k.tail = 0
    k.changed = 0
end sub

'' Always succeeds; drops the oldest when full. See the header.
private sub KeyPost( byref k as KeyRing, byval code as long )
    k.slot(k.tail) = code
    if ((k.tail + 1) and (KEY_BUFFER_LEN - 1)) = k.head then
        k.head = (k.head + 1) and (KEY_BUFFER_LEN - 1)
    end if
    k.tail = (k.tail + 1) and (KEY_BUFFER_LEN - 1)
    k.changed = 1
end sub

'' Take the next key, or 0 if none. Reading also clears the changed flag, which
'' is why a caller cannot use the flag to detect a key it has already consumed.
private function KeyGet( byref k as KeyRing ) as long
    dim as long code = 0
    if k.head <> k.tail then
        code = k.slot(k.head)
        k.head = (k.head + 1) and (KEY_BUFFER_LEN - 1)
    end if
    k.changed = 0
    return code
end function

'' KEYHIT: is anything waiting? Does not consume.
private function KeyHit( byref k as KeyRing ) as long
    return iif( k.head <> k.tail, 1, 0 )
end function

'' Read and clear the changed flag.
private function KeyBufferChanged( byref k as KeyRing ) as long
    dim as long r = k.changed
    k.changed = 0
    return r
end function

'' How many keys are waiting -- for tests, not part of the reference's surface.
private function KeyCount( byref k as KeyRing ) as long
    return (k.tail - k.head) and (KEY_BUFFER_LEN - 1)
end function

'' INKEY's string for a key code. Empty when there is no key.
private function KeyInkeyStr( byval code as long ) as string
    if code = 0 then return ""
    if code <= 255 then return chr( code and &hFF )
    '' little-endian, low byte first -- see the header
    return chr( code and &hFF ) + chr( (code shr 8) and &hFF )
end function

'' THE SCANCODES AN EDITING LOOP NEEDS, and only those.
''
'' These are PC set-1 codes, which is what FreeBASIC's SC_* are and what a
'' WM_KEYDOWN lParam carries -- fbgfx.bi declares SC_LEFT as &h4B and the rest
'' follow from it. They are restated here rather than included, because this
'' library cannot include fbgfx.bi; tools/smoke-entry.bas asserts them against
'' the reference header's own constants so the restatement cannot drift.
const SC_HOME_   = &h47
const SC_LEFT_   = &h4B
const SC_RIGHT_  = &h4D
const SC_END_    = &h4F
const SC_DELETE_ = &h53

'' An extended key is (scancode shl 8) or 255, so the low byte identifies one.
'' A plain character is 1..255 and can never collide: 255 alone is not a code
'' this library posts, and a two-byte code always has a non-zero high byte.
private function KeyIsExtended( byval code as long ) as long
    return iif( (code > 255) andalso ((code and &hFF) = 255), 1, 0 )
end function

private function KeyScancode( byval code as long ) as long
    return (code shr 8) and &hFF
end function

'' MULTIKEY. The table is 128 entries and anything outside is FALSE rather than
'' an error, so a program probing an unknown scancode gets a clean answer.
type KeyTable
    down(0 to KEY_TABLE_LEN - 1) as ubyte
end type

private sub KeyTableClear( byref t as KeyTable )
    for i as integer = 0 to KEY_TABLE_LEN - 1
        t.down(i) = 0
    next
end sub

'' Mark one scancode held or released.
''
'' The bounds test is the same one KeyMultikey applies on the way out, and it is
'' not shared with it on purpose: this is fed by window messages, whose scancode
'' byte is whatever the OS put there, and the read side is fed by a program's
'' argument. Two different untrusted sources, checked where each arrives.
private sub KeyTableSet( byref t as KeyTable, byval scancode as long, byval down as long )
    if (scancode < 0) orelse (scancode >= KEY_TABLE_LEN) then exit sub
    t.down(scancode) = iif( down, 1, 0 )
end sub

private function KeyMultikey( byref t as KeyTable, byval scancode as long ) as long
    if (scancode < 0) orelse (scancode >= KEY_TABLE_LEN) then return 0
    return iif( t.down(scancode) <> 0, -1, 0 )      '' FB_TRUE is -1
end function

end namespace
