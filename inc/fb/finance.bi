'' fb/finance.bi -- the finance module, whole
''
''     #include once "fb/finance.bi"
''     using FB
''
'' Specified by C:\dev\docs\finance\ -- README.md is the index, and each header
'' names the RFC that specifies it.
''
'' AN UMBRELLA, AND NOTHING ELSE.  This file declares no type and no function;
'' it includes the parts in dependency order, the way fb/filesystem.bi and
'' fb/logging.bi do.  Include a part directly if you want only that part --
'' every one of them is independently includable and guarded.
''
''     Phase  Header             RFC   What it is
''     -----  -----------------  ----  ------------------------------------
''       1    fb/finerror.bi     0001  FinanceError, the codes, the aliases
''       1    fb/fincore.bi      0002  conventions, day count, the rate kernel
''       2    fb/fintvm.bi       0004  present/future value, payment, term
''       3    fb/finsolve.bi     0003  the root finder
''       4    fb/finloan.bi      0005  loans, schedules, amortization
''       5    fb/fincash.bi      0006  NPV, IRR, MIRR, payback
''       6    fb/findeprec.bi    0007  depreciation
''       7    fb/finport.bi      0008  returns and risk
''
'' Phases 2 through 7 are not built yet, and this file grows one line each time
'' one lands.  It lists them above rather than including them, so that the
'' table is the plan and the includes are the truth.

#pragma once

#if __FB_LANG__ <> "fb"
	#error "fb/finance.bi requires -lang fb (it uses namespaces)"
#endif

#include once "fb/finerror.bi"
#include once "fb/fincore.bi"
#include once "fb/finsolve.bi"
#include once "fb/fintvm.bi"
#include once "fb/finloan.bi"
#include once "fb/fincash.bi"
#include once "fb/findeprec.bi"
#include once "fb/finport.bi"
