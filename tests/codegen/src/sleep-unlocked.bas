'' A THREAD ASLEEP IN SLEEP MUST NOT HOLD THE I/O LOCK. The worker is inside a console-form
'' sleep when the main thread times a SLEEP 1 of its own. fbc's fb_Sleep reads the hook under
'' FB_LOCK and sleeps after FB_UNLOCK; tiko-rt held the lock across the whole sleep, so the
'' main thread's SLEEP 1 waited out the rest of the worker's (AWT-001).
''
'' 99 ms, NOT LONGER: a SLEEP of 100 ms or more polls the keyboard, and with no console that
'' is feof(stdin) -- under a test runner's redirected stdin the sleep ends at once and nothing
'' is ever held.
sub Sleeper( byval p as any ptr )
	sleep 99
end sub

dim as any ptr th = threadcreate( @Sleeper )

'' The raw delay takes no lock: by the end of it the worker is inside its sleep.
sleep 20, 1

dim as double t0 = timer
sleep 1
dim as double waited = timer - t0

threadwait( th )
print iif( waited < 0.05, "sleep 1 did not wait for the other thread", "sleep 1 waited for the other thread" )
