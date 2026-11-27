#!/bin/bash
# vendor/libcurl: curl's public headers as 'tiko c2t' takes them (claude-docs docs/tiko-vendor
# RFC-0004 P0 section 4). curl.h ends by including easy.h, multi.h, urlapi.h, options.h, header.h,
# websockets.h and mprintf.h. None of those parses on its own -- they use CURL and CURL_EXTERN
# from curl.h -- and multi.h includes curl.h back. So the seven are written INTO curl.h where it
# includes them, their own '#include "curl.h"' dropped. curlver.h and system.h stay separate
# headers, translated first. Run once per curl release, by hand; the output is not committed,
# the translations are.
#
#   bash flatten.sh <curl source>/include <out dir>      ->  <out dir>/curl/{curl,curlver,system}.h
#
# P0 also renamed 'struct Curl_URL' and expanded the CURLOPT() enumerators here; tiko-lang
# 483ed6439 fixed both in c2t, so neither is done any more.
set -e
IN=$1/curl; OUT=$2/curl
[ -f "$IN/curl.h" ] || { echo "flatten.sh: no $IN/curl.h" >&2; exit 1; }
mkdir -p "$OUT"
cp "$IN/curlver.h" "$IN/system.h" "$OUT/"
awk -v dir="$IN" '
/^#include "(easy|multi|urlapi|options|header|websockets|mprintf)\.h"/ {
    f = $2; gsub(/"/, "", f)
    print "/* ---- " f " (flattened) ---- */"
    while ((getline line < (dir "/" f)) > 0)
        if (line !~ /^#include "curl\.h"/) print line
    close(dir "/" f)
    print "/* ---- end " f " ---- */"
    next
}
{ print }' "$IN/curl.h" > "$OUT/curl.h"
n=$(grep -c '(flattened) ----' "$OUT/curl.h")
[ "$n" = 7 ] || { echo "flatten.sh: flattened $n headers, not 7 -- curl.h changed" >&2; exit 1; }
