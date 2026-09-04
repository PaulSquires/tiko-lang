'' lzw.bi -- the 12-bit LZW codec behind fb_hEncode / fb_hDecode.
''
'' Derived from: gfx_lzw.c, gfx_lzw_enc.c, fb_gfx_lzw.h.
'' LGPL-2.1-or-later with the static-linking exception.
''
'' WHAT THIS IS ACTUALLY FOR. It is not a user-facing feature and no FB
'' statement reaches it. `fb_hDecode` has exactly ONE caller in the whole tree --
'' gfx_data.c, expanding the built-in font and palette blob at startup -- and
'' `fb_hEncode` has NO caller at all: it is exported so the blob can be produced
'' offline. Both are still exported symbols, so a drop-in library owes them.
''
'' We do not need the decoder for our own data, which is extracted by rendering
'' rather than decompressed. It is here for ABI completeness.
''
'' TWO CODES PER THREE BYTES, AND THE PACKING IS NOT BYTE-ALIGNED.
''
'' Codes are 12 bits, emitted in pairs. The `bit` flag alternates:
''
''   bit = 0   write the low 8 bits and advance; then write the high 4 bits into
''             the next byte WITHOUT ADVANCING -- it is left pending
''   bit = 1   OR the new code's low nibble into the pending byte's high nibble,
''             advance, then write the remaining 8 bits and advance
''
'' So the pending byte is written twice: assigned by the even code, OR-ed by the
'' odd one. Advancing after the even write loses the high nibble of every other
'' code, and the stream still decodes for inputs short enough never to reach a
'' second code.
''
'' THE TRAILER. The encoder emits the final string code, then MAX_CODE (4095) as
'' a terminator, then adds one to the size if a byte is left pending. The decoder
'' stops on MAX_CODE and returns 0; if it runs out of input first it returns -1.
'' So a truncated stream is an error, not a short read.
''
'' A DELIBERATE DIVERGENCE: THE DECODER'S OUTPUT BOUND.
''
'' The C computes its limit as `limit = out_buffer + *out_size` AFTER already
'' advancing out_buffer past the first byte, so the limit sits one byte beyond
'' the caller's buffer and a maximally-sized output overruns it by one. We bound
'' at the true capacity instead. The two differ only on a stream that exactly
'' fills the buffer, where the reference writes one byte too many and we return
'' -1 -- so this is asserted against the contract rather than A/B compared.

#pragma once

namespace TkoGfx

const LZW_MAX_CODE   = 4095
const LZW_TABLE_SIZE = 5021

'' Mirrors LZW_ENTRY. `code` is SIGNED -- -1 is the empty marker, and the table
'' is filled with &hFF bytes, so prefix reads back as &hFFFF and value as &hFF.
type LzwEntry
    code   as short
    prefix as ushort
    value  as ubyte
end type

'' The reference keeps ONE table as a process global guarded by a lock. Ours is
'' passed in, so two encodes cannot interfere; the observable output is the same
'' because the encoder clears the table on entry and the decoder only reads
'' entries it wrote during the same call.
type LzwTable
    e(0 to LZW_TABLE_SIZE - 1) as LzwEntry
end type

'' ---- encoder ----

'' Open-addressed lookup. The probe step is `TABLE_SIZE - index`, not 1, and the
'' initial index is `(value shl 4) xor prefix`, which stays below TABLE_SIZE
'' because both operands fit in 12 bits.
'' THE PROBE STEP IS UNOBSERVABLE IN THE OUTPUT. It decides WHERE an entry
'' lands, never which code that entry gets -- codes come from `next_code` in
'' input order -- and lookups follow the identical sequence, so any collision is
'' resolved to the same entry either way. Replacing the step with 1 produces
'' byte-identical streams; it was verified as a negative test and correctly did
'' NOT fail. The step is reproduced because it is the reference's, and it
'' affects clustering, not results.
private function LzwFindMatch( _
        byref t as LzwTable, byval prefix as ushort, byval value as ubyte ) as long

    dim as long index = (cast( long, value ) shl 4) xor cast( long, prefix )
    dim as long offset = 1
    if index <> 0 then offset = LZW_TABLE_SIZE - index

    '' BOUNDED, where the C's probe is not. The table holds at most 4095 entries
    '' in 5021 slots, so a cleared table always has an empty slot and the loop
    '' always terminates -- in valid use this bound is never reached and the
    '' behaviour is identical. It matters because a table that was NOT cleared
    '' has no -1 marker anywhere, and the C then spins forever: a missing clear
    '' HANGS the process instead of producing wrong output. Turning that into a
    '' reported error is worth the compare.
    for probe as integer = 0 to LZW_TABLE_SIZE - 1
        if t.e(index).code = -1 then return index
        if (t.e(index).prefix = prefix) andalso (t.e(index).value = value) then return index
        index = (index + offset) mod LZW_TABLE_SIZE
    next
    return -1
end function

'' Returns 0 on success, -1 if the output did not fit.
'' `out_size` is the capacity on entry and the produced length on exit.
private function LzwEncode( _
        byref t as LzwTable, _
        byval in_buffer as const ubyte ptr, byval in_size as integer, _
        byval out_buffer as ubyte ptr, byref out_size as integer ) as long

    if (in_buffer = 0) orelse (out_buffer = 0) then return -1
    '' The C reads the first byte unconditionally, so an empty input reads out
    '' of bounds. Refused here instead.
    if in_size <= 0 then return -1

    dim as integer cap = out_size
    dim as ubyte ptr o = out_buffer
    dim as integer size = 0
    dim as long bit_ = 0
    dim as long overflow = 0

    for i as integer = 0 to LZW_TABLE_SIZE - 1
        t.e(i).code   = -1
        t.e(i).prefix = &hFFFF
        t.e(i).value  = &hFF
    next

    dim as const ubyte ptr p = in_buffer
    dim as ushort string_code = *p
    p += 1
    in_size -= 1

    dim as ushort next_code = 256

    do while (in_size > 0) andalso (overflow = 0)
        dim as long idx = LzwFindMatch( t, string_code, *p )
        if idx < 0 then return -1
        if t.e(idx).code <> -1 then
            string_code = cast( ushort, t.e(idx).code )
        else
            if next_code < LZW_MAX_CODE then
                t.e(idx).code   = cast( short, next_code )
                t.e(idx).prefix = string_code
                t.e(idx).value  = *p
                next_code += 1
            end if

            '' OUTPUT_CODE(string_code)
            if bit_ then
                *o or= cast( ubyte, (string_code and &hF) shl 4 ) : o += 1
                *o = cast( ubyte, string_code shr 4 ) : o += 1
                size += 1
            else
                *o = cast( ubyte, string_code and &hFF ) : o += 1
                '' pending byte -- assigned now, OR-ed by the next code
                *o = cast( ubyte, string_code shr 8 )
            end if
            size += 1
            if size >= cap then
                overflow = 1
            else
                bit_ xor= 1
            end if

            string_code = *p
        end if
        p += 1
        in_size -= 1
    loop
    if overflow then return -1

    '' the final string code, then the terminator
    dim as ushort tail(0 to 1) = { string_code, LZW_MAX_CODE }
    for k as integer = 0 to 1
        dim as ushort c = tail(k)
        if bit_ then
            *o or= cast( ubyte, (c and &hF) shl 4 ) : o += 1
            *o = cast( ubyte, c shr 4 ) : o += 1
            size += 1
        else
            *o = cast( ubyte, c and &hFF ) : o += 1
            *o = cast( ubyte, c shr 8 )
        end if
        size += 1
        if size >= cap then return -1
        bit_ xor= 1
    next

    '' a byte still pending counts toward the length
    if bit_ then size += 1
    out_size = size
    return 0
end function

'' ---- decoder ----

'' Walks a code back to its root, writing the string FORWARDS and returning a
'' pointer to the LAST byte written -- the caller then pops backwards, which is
'' what puts the bytes in order. Returns 0 if the chain does not terminate.
private function LzwDecodeString( _
        byref t as LzwTable, byval buffer as ubyte ptr, byval code as long ) as ubyte ptr

    dim as ubyte ptr b = buffer
    dim as long index = 0
    while code > 255
        *b = t.e(code).value
        b += 1
        code = cast( long, t.e(code).prefix )
        index += 1
        if index >= LZW_MAX_CODE - 1 then return 0
    wend
    *b = cast( ubyte, code )
    return b
end function

'' Returns 0 on success (terminator seen), -1 on a truncated stream, a broken
'' code chain, or an output overrun.
'' `out_size` is the capacity on entry and the produced length on exit.
private function LzwDecode( _
        byref t as LzwTable, _
        byval in_buffer as const ubyte ptr, byval in_size as integer, _
        byval out_buffer as ubyte ptr, byref out_size as integer ) as long

    if (in_buffer = 0) orelse (out_buffer = 0) then return -1
    if in_size <= 0 then return -1
    if out_size <= 0 then return -1

    dim as const ubyte ptr p = in_buffer
    dim as ubyte ptr o = out_buffer
    dim as long bit_ = 0

    dim as ubyte decode_stack(0 to LZW_MAX_CODE - 1)

    '' INPUT_CODE(old_code) -- the first code is a literal byte
    dim as ushort old_code = *p
    p += 1
    old_code or= cast( ushort, (*p and &hF) shl 8 )
    in_size -= 1
    bit_ xor= 1

    dim as ubyte byte_ = cast( ubyte, old_code )
    *o = byte_
    o += 1

    '' Bounded at the TRUE capacity -- see the header on the reference's
    '' off-by-one.
    dim as ubyte ptr limit = out_buffer + out_size
    dim as integer produced = 1

    dim as ushort next_code = 256

    while in_size > 0
        '' INPUT_CODE(new_code)
        dim as ushort new_code
        if bit_ then
            new_code = cast( ushort, *p shr 4 )
            p += 1
            new_code or= cast( ushort, cast( ushort, *p ) shl 4 )
            p += 1
            in_size -= 1
        else
            new_code = *p
            p += 1
            new_code or= cast( ushort, (*p and &hF) shl 8 )
        end if
        in_size -= 1
        bit_ xor= 1

        if new_code = LZW_MAX_CODE then
            out_size = produced
            return 0
        end if

        dim as ubyte ptr s
        if new_code >= next_code then
            '' the KwKwK case: the code is one past the table, so its expansion
            '' is the previous string plus its own first byte
            decode_stack(0) = byte_
            s = LzwDecodeString( t, @decode_stack(1), cast( long, old_code ) )
        else
            s = LzwDecodeString( t, @decode_stack(0), cast( long, new_code ) )
        end if
        if s = 0 then return -1

        byte_ = *s
        while s >= @decode_stack(0)
            if o >= limit then return -1
            *o = *s
            o += 1
            s -= 1
            produced += 1
        wend

        if next_code < LZW_MAX_CODE then
            t.e(next_code).prefix = old_code
            t.e(next_code).value  = byte_
            next_code += 1
        end if
        old_code = new_code
    wend

    '' ran out of input without a terminator
    return -1
end function

end namespace
