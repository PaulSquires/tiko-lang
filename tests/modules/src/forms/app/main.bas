'' Every accepted form: an alias, a predefined-only condition, both branches of one.
#lang "fb"
#pragma once
#import "kit/util" as u
#if defined( __FB_WIN64__ ) orelse defined( __FB_LINUX__ )
#import "kit/extra"
#endif
#ifdef __FB_LINUX__
#import "kit/util"
#else
#import "kit/extra"
#endif
print 1
