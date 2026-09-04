'' dt.bi -- the date/time constants and the two helpers that are macros in C.
''
'' THE SERIAL EPOCH IS 1899-12-30, NOT 1900-01-01. fb_DateSerial starts its
'' accumulator at 2 for 1900-01-01, so serial 1 is 1899-12-31 and serial 0 is
'' 1899-12-30. That is the OLE automation epoch, and it is what makes
'' fb_Weekday's `(serial - 1) mod 7` land Sunday on 1. Do not "fix" the 2.

#pragma once

'' fb_DateSerial's own base year. Both the encoder and the decoder walk
'' outward from here, so the loops are O(|year - 1900|) by construction.
const FB_DT_BASE_YEAR = 1900

const FB_WEEK_FIRST_SYSTEM     = 0
const FB_WEEK_FIRST_JAN_1      = 1
const FB_WEEK_FIRST_FOUR_DAYS  = 2
const FB_WEEK_FIRST_FULL_WEEK  = 3
const FB_WEEK_FIRST_DEFAULT    = FB_WEEK_FIRST_JAN_1

const FB_WEEK_DAY_SYSTEM       = 0
const FB_WEEK_DAY_SUNDAY       = 1
const FB_WEEK_DAY_MONDAY       = 2
const FB_WEEK_DAY_TUESDAY      = 3
const FB_WEEK_DAY_WEDNESDAY    = 4
const FB_WEEK_DAY_THURSDAY     = 5
const FB_WEEK_DAY_FRIDAY       = 6
const FB_WEEK_DAY_SATURDAY     = 7
const FB_WEEK_DAY_DEFAULT      = FB_WEEK_DAY_SUNDAY

const FB_TIME_INTERVAL_INVALID      = 0
const FB_TIME_INTERVAL_YEAR         = 1
const FB_TIME_INTERVAL_QUARTER      = 2
const FB_TIME_INTERVAL_MONTH        = 3
const FB_TIME_INTERVAL_DAY_OF_YEAR  = 4
const FB_TIME_INTERVAL_DAY          = 5
const FB_TIME_INTERVAL_WEEKDAY      = 6
const FB_TIME_INTERVAL_WEEK_OF_YEAR = 7
const FB_TIME_INTERVAL_HOUR         = 8
const FB_TIME_INTERVAL_MINUTE       = 9
const FB_TIME_INTERVAL_SECOND       = 10

'' fb.h spells these as macros, so there is no symbol to match -- only the
'' answer. hSign HAS NO ZERO CASE: sign(0) is 1, not 0, and fb_hGetWeekOfYear
'' depends on that to make week 1 come out as 1 rather than 0.
#define TKORT_HSIGN( x )  iif( (x) < 0, -1, 1 )
#define TKORT_DAYSINYEAR( y )  ( 365 + tkrt_TimeLeap( y ) )
