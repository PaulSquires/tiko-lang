'' The shape of fb/fserror.bi that hid the macros after it (scan-header-macros.test): a TYPE
'' declaring a CONST member function between two macros.
#pragma once
#define HDR_BEFORE extern "C"
namespace NS
    type FsLike
        as long code_
        declare const function Code( ) as long
    end type
end namespace
#define HDR_AFTER extern "C"
