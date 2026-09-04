/* probe-rtlabi.c -- ground-truth layout probe for the libtkogfx runtime seam.
 *
 * ORIGINAL WORK. Derived from no gfxlib2 source; it only #includes the runtime
 * headers and reports what the compiler computes.
 *
 * Part of libtkogfx, which is LGPL-2.1-or-later with the static-linking
 * exception (see LICENSE at the repository root).
 *
 * Prints sizeof/alignof/offsetof for every rtlib and gfxlib2 type that the FB
 * side mirrors. The FB mirror must reproduce this table exactly; tools/gate-abi.sh
 * re-runs this against the checked-in goldens in abi/offsets/ and FAILS THE BUILD
 * on any drift. Measured, not asserted.
 *
 * Build (win64):  clang probe-rtlabi.c -D__MINGW32__ -I <rtlib> -I <gfxlib2> -o probe64.exe
 * Build (win32):  add -m32
 *
 * NOTE: the rtlib headers identify Windows only via __MINGW32__, so a
 * -windows-msvc clang must be told. See tools/gate-abi.sh.
 */
/* Ground-truth layout probe for the libtkogfx runtime seam.
   Prints one sorted table; the FB-side mirror must reproduce it exactly. */
/* MSVC headers lack MinGW's ssize_t; rtlib assumes it. */
#include <BaseTsd.h>
typedef SSIZE_T _ssize_t;
typedef SSIZE_T ssize_t;
#define _SSIZE_T_DEFINED
#include "fb.h"
#include "fb_gfx.h"
#include <stdio.h>
#include <stddef.h>

#define T(ty)        printf("%-16s sizeof=%-5zu align=%zu\n", #ty, sizeof(ty), _Alignof(ty))
#define F(ty,fld)    printf("%-16s .%-18s off=%-5zu size=%zu\n", #ty, #fld, \
                            offsetof(ty,fld), sizeof(((ty*)0)->fld))
#define V(name,val)  printf("%-16s = %ld\n", name, (long)(val))

int main(void){
    printf("== types ==\n");
    T(FBSTRING); T(FBARRAY); T(FBARRAYDIM); T(EVENT);
    T(FB_HOOKSTB); T(FB_RTLIB_CTX); T(FB_GFXCTX); T(FBGFX);
    T(GFXDRIVER); T(PUT_HEADER); T(GFX_CHAR_CELL);

    printf("== FBSTRING ==\n");
    F(FBSTRING,data); F(FBSTRING,len); F(FBSTRING,size);

    printf("== FBARRAY ==\n");
    F(FBARRAY,data); F(FBARRAY,ptr); F(FBARRAY,size);
    F(FBARRAY,element_len); F(FBARRAY,dimensions); F(FBARRAY,flags); F(FBARRAY,dimTB);

    printf("== FB_RTLIB_CTX (the two offsets the seam needs) ==\n");
    F(FB_RTLIB_CTX,hooks); F(FB_RTLIB_CTX,exit_gfxlib2);
    F(FB_RTLIB_CTX,null_desc); F(FB_RTLIB_CTX,lang);

    printf("== FB_HOOKSTB ==\n");
    F(FB_HOOKSTB,inkeyproc);    F(FB_HOOKSTB,getkeyproc);   F(FB_HOOKSTB,keyhitproc);
    F(FB_HOOKSTB,clsproc);      F(FB_HOOKSTB,colorproc);    F(FB_HOOKSTB,locateproc);
    F(FB_HOOKSTB,widthproc);    F(FB_HOOKSTB,getxproc);     F(FB_HOOKSTB,getyproc);
    F(FB_HOOKSTB,getxyproc);    F(FB_HOOKSTB,getsizeproc);  F(FB_HOOKSTB,printbuffproc);
    F(FB_HOOKSTB,printbuffwproc); F(FB_HOOKSTB,readstrproc); F(FB_HOOKSTB,multikeyproc);
    F(FB_HOOKSTB,getmouseproc); F(FB_HOOKSTB,setmouseproc); F(FB_HOOKSTB,inproc);
    F(FB_HOOKSTB,outproc);      F(FB_HOOKSTB,viewupdateproc); F(FB_HOOKSTB,lineinputproc);
    F(FB_HOOKSTB,lineinputwproc); F(FB_HOOKSTB,readxyproc); F(FB_HOOKSTB,sleepproc);
    F(FB_HOOKSTB,isredirproc);  F(FB_HOOKSTB,pagecopyproc); F(FB_HOOKSTB,pagesetproc);
    F(FB_HOOKSTB,posteventproc);

    printf("== PUT_HEADER (the 32-byte image contract) ==\n");
    F(PUT_HEADER,bpp); F(PUT_HEADER,width); F(PUT_HEADER,height);
    F(PUT_HEADER,pitch); F(PUT_HEADER,tex);

    printf("== FB_GFXCTX ==\n");
    F(FB_GFXCTX,id); F(FB_GFXCTX,work_page); F(FB_GFXCTX,line); F(FB_GFXCTX,max_h);
    F(FB_GFXCTX,target_bpp); F(FB_GFXCTX,target_pitch); F(FB_GFXCTX,last_target);
    F(FB_GFXCTX,last_x); F(FB_GFXCTX,last_y);
    F(FB_GFXCTX,view); F(FB_GFXCTX,old_view);
    F(FB_GFXCTX,win_x); F(FB_GFXCTX,win_y); F(FB_GFXCTX,win_w); F(FB_GFXCTX,win_h);
    F(FB_GFXCTX,fg_color); F(FB_GFXCTX,bg_color);
    F(FB_GFXCTX,put_pixel); F(FB_GFXCTX,get_pixel); F(FB_GFXCTX,pixel_set);
    F(FB_GFXCTX,putter); F(FB_GFXCTX,flags);
    printf("== FBGFX ==\n");
    F(FBGFX,id); F(FBGFX,mode_num); F(FBGFX,page); F(FBGFX,num_pages); F(FBGFX,visible_page);
    F(FBGFX,framebuffer); F(FBGFX,w); F(FBGFX,h); F(FBGFX,depth); F(FBGFX,bpp); F(FBGFX,pitch);
    F(FBGFX,palette); F(FBGFX,device_palette); F(FBGFX,color_association); F(FBGFX,dirty);
    F(FBGFX,driver); F(FBGFX,color_mask); F(FBGFX,default_palette); F(FBGFX,scanline_size);
    F(FBGFX,cursor_x); F(FBGFX,cursor_y); F(FBGFX,font); F(FBGFX,text_w); F(FBGFX,text_h);
    F(FBGFX,aspect); F(FBGFX,key); F(FBGFX,refresh_rate); F(FBGFX,con_pages);
    F(FBGFX,event_queue); F(FBGFX,event_head); F(FBGFX,event_tail); F(FBGFX,event_mutex);
    F(FBGFX,flags); F(FBGFX,lock_count);
    printf("== GFXDRIVER ==\n");
    F(GFXDRIVER,name); F(GFXDRIVER,init); F(GFXDRIVER,exit); F(GFXDRIVER,lock);
    F(GFXDRIVER,unlock); F(GFXDRIVER,set_palette); F(GFXDRIVER,wait_vsync);
    F(GFXDRIVER,get_mouse); F(GFXDRIVER,set_mouse); F(GFXDRIVER,set_window_title);
    F(GFXDRIVER,set_window_pos); F(GFXDRIVER,fetch_modes); F(GFXDRIVER,flip);
    F(GFXDRIVER,poll_events); F(GFXDRIVER,update);
    printf("== GFX_CHAR_CELL ==\n");
    F(GFX_CHAR_CELL,ch); F(GFX_CHAR_CELL,fg); F(GFX_CHAR_CELL,bg);
    printf("== constants ==\n");
    V("FB_TLSKEY_GFX", FB_TLSKEY_GFX);
    V("PUT_HEADER_NEW", PUT_HEADER_NEW);
    V("MASK_COLOR_32", MASK_COLOR_32);
    return 0;
}
