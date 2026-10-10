# defaultseed.sh -- sourced, not run: default_seed prints the seed stage0 builds with when
# neither TKO_SEED nor TKO_STAGE0 says otherwise, or returns 1 when there is none.
#
#   . "$ROOT/build/defaultseed.sh"; SEED=$(default_seed "$ROOT" "$HOSTWIN")
#
# build.sh, test.sh and bootstrap.sh share it so the three cannot disagree about which
# compiler built bin/. build/defaultseed.bat is the Windows peer.
#
# IN THIS ORDER, first that exists:
#   1. <root>/seed/cache/<host>/...   the PINNED seed, as seed/fetch-seed.sh unpacks it;
#   2. <root>/toolchains/tiko-<host>  a locally packaged toolchain (build/package.sh) --
#      the seed until one is published, which is what seed/seed.lock says;
#   3. both again in the MAIN checkout, found through git's common directory: a worktree
#      junctions only toolchains/.../inc and lib, never the compiler beside them.

default_seed( ) {
    ds_root=$1
    if [ "$2" = "1" ]; then ds_host=windows; ds_rel="tiko-windows/tiko.exe"
    else                    ds_host=linux;   ds_rel="tiko-linux/bin/tiko"; fi
    ds_main=$(git -C "$ds_root" rev-parse --path-format=absolute --git-common-dir 2>/dev/null || true)
    [ -n "$ds_main" ] && ds_main=$(dirname "$ds_main")
    for ds_c in "$ds_root/seed/cache/$ds_host/$ds_rel" "$ds_root/toolchains/$ds_rel" \
                ${ds_main:+"$ds_main/seed/cache/$ds_host/$ds_rel"} ${ds_main:+"$ds_main/toolchains/$ds_rel"}; do
        if [ -x "$ds_c" ]; then echo "$ds_c"; return 0; fi
    done
    return 1
}
