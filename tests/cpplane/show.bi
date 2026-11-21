'' show.bi -- the C++ lane's output functions (show.cpp), for the tiko drivers.
extern "C"
    declare sub show_i( byval k as const zstring ptr, byval v as longint )
    declare sub show_u( byval k as const zstring ptr, byval v as ulongint )
    declare sub show_d( byval k as const zstring ptr, byval v as double )
    declare sub show_s( byval k as const zstring ptr, byval v as const zstring ptr )
end extern
