'' cimportverify.bi -- the imported records' layout, tiko's against clang's. D16 §3.
''
'' A binding is text, and the text says what C said -- members, order, 'field = N' -- but
'' not where each member lands: tiko lays it out. The two agree for nearly every record
'' and not for all, and a record laid out wrongly does not fail, it reads its neighbour's
'' bytes. So the binding is laid out here with tiko's own frontend, and every record is
'' compared with the layout clang wrote to the manifest.

#pragma once

#include once "tko.bi"
#include once "driver/driver.bi"

namespace Tko.CImportDriver

'' Lays 'text' out and compares it with 'manifest' ("record <name> <size> <align>" /
'' "  field <name> <bit> <width>"). Every record that disagrees is pushed to 'badName'
'' with the difference in 'badWhy'. False when the binding did not compile at all -- a
'' bug in the importer, reported where the binding failed.
declare function VerifyLayout _
    ( byref ctx as Tko.CompilerContext, byref text as string, byref manifest as string, _
      byref badName as Tko.StrVec, byref badWhy as Tko.StrVec ) as boolean

end namespace
