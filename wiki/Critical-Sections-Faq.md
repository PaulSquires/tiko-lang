[Home](Home) › [Tutorials](Category-Tutorials) › **Critical Sections FAQ**

# Critical Sections FAQ

The "**Critical Sections**" related questions in multi-threading.

'Critical sections' related questions

1. When is it not mandatory to protect by a mutex one shared variable between several threads?2. What is the chronology of code execution of 2 critical sections (with a mutex locking and a conditional variable signaling) that compete between 2 threads?3. What happens if calling 'Condsignal()' or 'Condbroadcast()' without mutex locked?4. Why is it mandatory to put 'Condwait' within a 'While...Wend' loop for checking a Boolean predicate (set by other thread before activate 'Condsignal' or 'Condbroadcast', and reset after the 'Wend')?4.1. Is 'Condwait' (and 'Condsignal' or 'Condbroadcast') still useful when there is already a 'While' loop for checking a Boolean predicate set by other thread?

5. How to implement a user input-line function fully thread-safe?6. How to use 'Screenlock' with multi-threading?7. How to use 'video paging (double buffering or page flipping)' with multi-threading?8. How to use the FB runtime library for multi-threaded applications (gfxlib2) with multi-threading?9. How to use console statements and keyboard inputs with multi-threading?10. Is it better to take precautions when using the keyword 'Sleep' in threads?11. Can all tools to handle multi-threading be encapsulated in a base Class (that the user extends with a derived Type for his own implementing)?12. What is the execution delay of the code of a thread after the thread is created by 'ThreadCreate'?13. What is the synchronization latency when synchronizing threads either by mutual exclusions or by conditional variables?14. What happens when multiple threads are waiting on the same condition variable?15. How to optimize sequencing of successive user tasks executed by threading?16. Why is multi-threading performance penalized by many shared memory accesses (even more in writing mode)?17. Why is multi-threading performance heavily penalized by many manipulation of var-len strings and var-len arrays?

'Critical sections' related questions

1. When is it not mandatory to protect by a mutex one shared variable between several threads?

When accessing to shared variables between several threads, all their accesses must be generally put inside blocks `Mutexlock...Mutexunlock`, in all threads:

**-** When the shared variable is only one simple predefined numeric type of `size <= sizeof(integer)` (only one assembler instruction for access), the mutex use may be not mandatory.
 **-** But if this is for example one shared variable `LongInt` with a win32 compilation, it is advised here to use a mutex (otherwise the reading phase by a thread may be interlaced with the writing phase of another thread).

That is because to access a variable in memory (for reading or for writing), a processor uses its internal registers.  
 A N-bit processor has N-bit registers but none greater:

**-** So one only assembler instruction allows it to access a N-bit variable in memory.
 **-** At opposite, to access a 2N-bit variable, it must use 2 assembler instructions.
 **-** If between these two assembler instructions (for writing), another thread accesses this same variable (for reading), the got value may be incoherent (N-bit highest and N-bit lowest incoherent together).

This behavior can be checked with a graphic program using two threads and a shared `LongInt` (64-bit) without mutex:

**-** by compiling in 32-bit, many read values are incoherent.
 **-** by compiling in 64-bit, no read value is incoherent.

Compile the below test program:

**-** in 32-bit => Many erroneous points not on the circle but anywhere in the square containing the circle. If you uncomment the four lines 37/39/58/60 to activate the mutex, then all the got points are now on the circle only.
 **-** in 64-bit => All points are valid, on the circle only, even if the mutex is not activated.

```freebasic
'   - The "user-defined thread" computes the points coordinates on a circle,

'     and write those in a LongInt (32-bit & 32-bit = 64-bit)

'   - The "main thread" plots the points from the LongInt value.

'

'   Behavior:

'      - The first point must be pre-determined.

'      - Nothing prevents that a same calculated point could be plotted several times

'      (depends on execution times of the loops between main thread and user thread).

'      - Nothing prevents that a calculated point could be not plotted

'      (same remark on the loop times).

'

'   Remark:

'      Voluntarily, there is no Sleep in the loop of each thread (normally strongly discouraged),

'      but this is just in this special case to amplify the behavior effects to observe.

Union Point2D

    Dim As LongInt xy

    Type

        Dim As Long y

        Dim As Long x

    End Type

End Union

Dim As Any Ptr handle

Dim Shared As Any Ptr mutex

Dim Shared As Integer quit

Sub Thread (ByVal param As Any Ptr)

    Const pi As Single = 4 * Atn(1)

    Dim As Point2D Ptr p = param

    Do

        Dim As Point2D P2D0

        Dim As Single teta = 2 * pi * Rnd

        P2D0.x = 320 + 200 * Cos(teta)

        P2D0.y = 240 + 200 * Sin(teta)

'        Mutexlock(mutex)

        p->xy = P2D0.xy

'        Mutexunlock(mutex)

'        Sleep 5, 1

    Loop Until quit = 1

End Sub

Screen 12

Dim As Point2D P2D

P2D.x = 520

P2D.y = 240

mutex = MutexCreate

handle = ThreadCreate(@Thread, @P2D)

Dim As Integer c

Do

    Dim As Point2D P2D0

'    Mutexlock(mutex)

    P2D0.xy = P2D.xy

'    Mutexunlock(mutex)

    PSet (P2D0.x, P2D0.y), c

    c = (c Mod 15) + 1

'    Sleep 5, 1

Loop Until Inkey <> ""

quit = 1

ThreadWait(handle)

MutexDestroy(mutex)
```

Back to top

2. What is the chronology of code execution of 2 critical sections (with a mutex locking and a conditional variable signaling) that compete between 2 threads?

Chronology for one thread signaling which occurs:

a) while another thread is waiting (within a While loop on predicate),  
 b) before another thread is waiting (within a While loop on predicate).

```freebasic
#define while_loop_on_predicate

Dim As Any Ptr handle

Dim Shared As Any Ptr mutex

Dim Shared As Any Ptr cond

Dim As Integer sleep0

Dim As Integer sleep1

#ifdef while_loop_on_predicate

Dim Shared As Integer ready

#endif

Sub Thread1 (ByVal param As Any Ptr)

    Sleep *Cast(Integer Ptr, param), 1

    MutexLock(mutex)

    Color 11 : Print "        Thread#1 locks the mutex"

    Color 11 : Print "        Thread#1 executes code with exclusion"

    #ifdef while_loop_on_predicate

    ready = 1

    #endif

    Color 11 : Print "        Thread#1 is signaling"

    CondSignal(cond)

    Color 11 : Print "        Thread#1 executes post-code with exclusion"

    Color 11 : Print "        Thread#1 unlocks the mutex"

    MutexUnlock(mutex)

End Sub

Sub Thread0 (ByVal param As Any Ptr)

    Sleep *Cast(Integer Ptr, param), 1

    MutexLock(mutex)

    Color 10 : Print "    Thread#0 locks the mutex"

    Color 10 : Print "    Thread#0 executes pre-code with exclusion"

    #ifdef while_loop_on_predicate

    While ready <> 1

    #endif

        Color 10 : Print "    Thread#0 is waiting"

        CondWait(cond, mutex)

        Color 10 : Print "    Thread#0 is waked"

    #ifdef while_loop_on_predicate

    Wend

    #endif

    Color 10 : Print "    Thread#0 executes code with exclusion"

    #ifdef while_loop_on_predicate

    ready = 0

    #endif

    Color 10 : Print "    Thread#0 unlocks the mutex"

    MutexUnlock(mutex)

End Sub

mutex = MutexCreate

cond = CondCreate

sleep0 = 0

sleep1 = 1000

Color 7 : Print "Chronology for Thread#1 signaling while Thread#0 is waiting:"

handle = ThreadCreate(@Thread1, @sleep1)

Thread0(@sleep0)

ThreadWait(handle)

Color 7 : Print "Thread#1 finished": Print

Sleep 1000, 1

sleep0 = 1000

sleep1 = 0

Color 7 : Print "Chronology for Thread#1 signaling before Thread#0 is waiting:"

handle = ThreadCreate(@Thread1, @sleep1)

Thread0(@sleep0)

ThreadWait(handle)

Color 7 : Print "Thread#1 finished": Print

MutexDestroy(mutex)

CondDestroy(cond)

Sleep
```

 Output part a - Chronology for Thread#1 signaling while Thread#0 is waiting:

```freebasic
Chronology for Thread#1 signaling while Thread#0 is waiting:
	Thread#0 locks the mutex
	Thread#0 executes pre-code with exclusion
	Thread#0 is waiting
		Thread#1 locks the mutex
		Thread#1 executes code with exclusion
		Thread#1 is signaling
		Thread#1 executes post-code with exclusion
		Thread#1 unlocks the mutex
	Thread#0 is waked
	Thread#0 executes code with exclusion
	Thread#0 unlocks the mutex
Thread#1 finished

```

Output part b - Chronology for Thread#1 signaling before Thread#0 is waiting:

```freebasic
Chronology for Thread#1 signaling before Thread#0 is waiting:
		Thread#1 locks the mutex
		Thread#1 executes code with exclusion
		Thread#1 is signaling
		Thread#1 executes post-code with exclusion
		Thread#1 unlocks the mutex
	Thread#0 locks the mutex
	Thread#0 executes pre-code with exclusion
	Thread#0 executes code with exclusion
	Thread#0 unlocks the mutex
Thread#1 finished

```

**Note:** If `CondWait` is not within a `While` loop on predicate (by putting in comment the first line of above program), one can check in the second case (thread#1 signaling before thread#0 waiting), that thread#0 remains blocked in its waiting phase (Ctrl-C to quit).

Back to top

3. What happens if calling 'Condsignal()' or 'Condbroadcast()' without mutex locked?

Referring to the example 2 on the [`Critical Sections`](Critical-Sections), one takes this opportunity to recall that:

**-** The mutex must always be also locked while executing `Condsignal()` or `Condbroadcast()` to wake up a thread (it may be unlocked but only after `Condsignal()` or `Condbroadcast()`).
 **-** If the mutex is not locked (or even if the mutex is unlocked only just before executing `Condsignal()` or `Condbroadcast()`), the behavior may become unpredictable (it may work or not, depending on the threads configuration and execution real time).

In the example 2 on the [`Critical Sections`](Critical-Sections) "Synchronous method example using a condwait then a condbroadcast (and a mutex) for all threads":

**-** If one at least `Mutexunlock()` is moved just before its `Condbroadcast()`, the program hangs very quickly.
 **-** Although some users certify that the mutex can always be unlocked just before `Condsignal()` or `Condbroadcast()`, and others more cautious assert that one can do it only for a `Condbroadcast()`, experiment shows the opposite!

The general rule is that:

**-** The condition must not be signaled (by `Condsignal()` or `Condbroadcast()`) between the time a thread locks the mutex and the time it waits on the condition variable (`CondWait()`), otherwise it seems that it may damage the waiting queue of threads on that condition variable.
 **-** Thus to avoid that and follow this rule, it is necessary that the mutex remains locked when the condition is signaled.

Back to top

4. Why is it mandatory to put 'Condwait' within a 'While...Wend' loop for checking a Boolean predicate (set by other thread before activate 'Condsignal' or 'Condbroadcast', and reset after the 'Wend')?

**```freebasic
While predicate <> True

Condwait(conditionalid, mutexid)

Wend

predicate = False
```**

 In all documentations, it is highly advisable to do so, mainly justified to fight against eventual spurious wake-ups.

 This is probably true, but it is also advisable to do so to avoid to loose a `CondSignal` (or `CondBroadcast`) if it is prematurely activated while the receiving thread is not yet waiting on `CondWait` (the signal is lost forever):

**-** In that case, the receiving thread has even not yet locked the mutex before that `CondSignal` (or `CondBroadcast`) is activated.
 **-** So the predicate will already true before the receiving thread reaches the 'While...Wend' loop, inducing that `CondWait` is downright skipped, so avoiding a definitive blocking phenomenon.

Let two threads (thread #0 in main program, thread #1 in a user procedure, each that prints its number in a loop), having about the same execution time, and each one synchronizing the other in order to well interlace their numbers (by using one mutex, two condition variables and `CondSignal`/`CondWait`):

```freebasic
' Thread#0 XOR + <==> Thread#1  
' ..... .....  
' MutexLock(mut) <-------------------------. .----------> MutexLock(mut)  
' ( atomic_mutex_unlock(mut) ) ------. | | Do_something_with_exclusion  
' CondWait(cond#1, mut) <----------- | --- | ----------- | ---------- CondSignal(cond#1)  
' ( atomic_mutex_re-lock(mut) ) <--- | ----'----. | .----- ( atomic_mutex_unlock(mut) )  
' Do_something_with_exclusion | .--- | ------ | --- | ---> CondWait(cond#2, mut)  
' CondSignal(cond#2) --------------- | ----' | .---'---- | ---> ( atomic_mutex_re-lock(mut) )  
' Do_something_with_exclusion | .--- | ---' | Do_something_with_exclusion  
' MutexUnlock(mut) ------------------'-----' '--------------'----- MutexUnlock(mut)  
' ..... .....  
'  
' (connecting lines join the sender(s) and receiver(s) impacted by each action occurring during the sequence)

```

```freebasic
Dim As Any Ptr handle

Dim Shared As Any Ptr mutex

Dim Shared As Any Ptr cond1

Dim Shared As Any Ptr cond2

Dim Shared As Integer quit

Sub Thread (ByVal param As Any Ptr)

   Do

   MutexLock(mutex)

   Print "1";

   CondSignal(cond1)

   CondWait(cond2, mutex)

   If quit = 1 Then

   MutexUnlock(mutex)

   Exit Do

   End If

   MutexUnlock(mutex)

   Sleep 1, 1

   Loop

End Sub

mutex = MutexCreate

cond1 = CondCreate

cond2 = CondCreate

handle = ThreadCreate(@Thread)

Do

   MutexLock(mutex)

   CondWait(cond1, mutex)

   Print "0";

   CondSignal(cond2)

   If Inkey <> "" Then

   quit = 1

   MutexUnlock(mutex)

   Exit Do

   End If

   MutexUnlock(mutex)

   Sleep 1, 1

Loop

ThreadWait(handle)

MutexDestroy(mutex)

CondDestroy(cond1)

CondDestroy(cond2)

Print

Sleep
```

```freebasic
' Thread#0 XOR + <==> Thread#1  
' ..... .....  
' MutexLock(mut) <-----------------------------. .----> MutexLock(mut)  
' While bool#1 <> true <---------------------- | --------. | Do_something_with_exclusion  
' ( atomic_mutex_unlock(mut) ) ------. | '--------------- | ---- bool#1 = true  
' CondWait(cond#1, mut) <----------- | --- | ------------------------ | ---- CondSignal(cond#1)  
' ( atomic_mutex_re-lock(mut) ) <--- | ----'----. .--------------- | ---> While bool#2 <> true  
' Wend | | | .---- | -------- ( atomic_mutex_unlock(mut) )  
' bool#1 = false .------- | -------- | ---' .------ | --- |--------> CondWait(cond#2, mut)  
' Do_something_with_exclusion | .--- | -------- | ------' .--- | ----'--------> ( atomic_mutex_re-lock(mut) )  
' bool#2 = true ----------------' | | .--- | ---------' | Wend  
' CondSignal(cond#2) ---------------' | | | | bool#2 = false  
' Do_something_with_exclusion | | | | Do_something_with_exclusion  
' MutexUnlock(mut) ----------------------'-----' '---------------'----------- MutexUnlock(mut)  
' ..... .....  
'  
' (connecting lines join the sender(s) and receiver(s) impacted by each action occurring during the sequence)

```

```freebasic
Dim As Any Ptr handle

Dim Shared As Any Ptr mutex

Dim Shared As Any Ptr cond1

Dim Shared As Any Ptr cond2

Dim Shared As Integer new1

Dim Shared As Integer new2

Dim Shared As Integer quit

Sub Thread (ByVal param As Any Ptr)

   Do

   MutexLock(mutex)

   Print "1";

   new1 = 1

   CondSignal(cond1)

   While new2 <> 1

   CondWait(cond2, mutex)

   Wend

   new2 = 0

   If quit = 1 Then

   MutexUnlock(mutex)

   Exit Do

   End If

   MutexUnlock(mutex)

   Sleep 1, 1

   Loop

End Sub

mutex = MutexCreate

cond1 = CondCreate

cond2 = CondCreate

handle = ThreadCreate(@Thread)

Do

   MutexLock(mutex)

   While new1 <> 1

   CondWait(cond1, mutex)

   Wend

   new1 = 0

   Print "0";

   new2 = 1

   CondSignal(cond2)

   If Inkey <> "" Then

   quit = 1

   MutexUnlock(mutex)

   Exit Do

   End If

   MutexUnlock(mutex)

   Sleep 1, 1

Loop

ThreadWait(handle)

MutexDestroy(mutex)

CondDestroy(cond1)

CondDestroy(cond2)

Print

Sleep
```

4.1. Is 'Condwait' (and 'Condsignal' or 'Condbroadcast') still useful when there is already a 'While...Wend' loop for checking a Boolean predicate set by other thread?

`(another question induced by the previous one)`

**-** The recommended structure is as follows:

```freebasic
' Principle of mutual exclusion + CONDWAIT in a While...Wend loop with predicate check, for a thread sub-section  
' (connecting lines join the sender(s) and receiver(s) impacted by each action occurring during the sequence)  
'  
'  
' Thread Other Thread  
' MUTEXLOCK(mutexID) <------------------------- from ( atomic_mutex_unlock(mutexID) ) or MUTEXUNLOCK(mutexID)  
' .......  
' While booleanT <> True <--------------------- from booleanT = True  
' ( atomic_mutex_unlock(mutexID) ) -------> to MUTEXLOCK(mutexID) or ( atomic_mutex_re-lock(mutexID) )  
' CONDWAIT(conditionalID, mutexID) <------- from CONDSIGNAL(conditionalID)  
' ( atomic_mutex_re-lock(mutexID) ) <------ from ( atomic_mutex_unlock(mutexID) ) or MUTEXUNLOCK(mutexID)  
' Wend  
' booleanT = False  
' .......  
' MUTEXUNLOCK(mutexID) -----------------------> to MUTEXLOCK(mutexID) or ( atomic_mutex_re-lock(mutexID) )

```

```freebasic
' Principle of mutual exclusion + CONDSIGNAL with predicate check, for a thread sub-section  
' (connecting lines join the sender(s) and receiver(s) impacted by each action occurring during the sequence)  
'  
' Thread Other Thread  
' MUTEXLOCK(mutexID) <------------------------- from ( atomic_mutex_unlock(mutexID) ) or MUTEXUNLOCK(mutexID)  
' .......  
' booleanOT = True ---------------------------> to While booleanOT <> True  
' CONDSIGNAL(conditionalID) ------------------> to CONDWAIT(conditionalID, mutexID)  
' .......  
' MUTEXUNLOCK(mutexID) -----------------------> to MUTEXLOCK(mutexID) or ( atomic_mutex_re-lock(mutexID) )

```

**-** If 'CondWait' is not used, it is mandatory to put instead a 'Sleep x, 1' instruction in the 'While...Wend' loop on the Boolean flag, in order to release time-slice when looping (in addition, this 'Sleep x, 1' must be put inside a \['Mutexunlock'...'Mutexlock'\] block to release another thread):

```freebasic
' Principle of mutual exclusion + SLEEP in a While...Wend loop with predicate check, for a thread sub-section  
' (connecting lines join the sender(s) and receiver(s) impacted by each action occurring during the sequence)  
'  
' Thread Other Thread  
' MUTEXLOCK(mutexID) <------------------------- from MUTEXUNLOCK(mutexID)  
' .......  
' While booleanT <> True <--------------------- from booleanT = True  
' MUTEXUNLOCK(mutexID) -------------------> to MUTEXLOCK(mutexID)  
' SLEEP(tempo, 1)  
' MUTEXLOCK(mutexID) <--------------------- from MUTEXUNLOCK(mutexID)  
' Wend  
' booleanT = False  
' .......  
' MUTEXUNLOCK(mutexID) -----------------------> to MUTEXLOCK(mutexID)

```

```freebasic
' Principle of mutual exclusion + predicate check only, for a thread sub-section  
' (connecting lines join the sender(s) and receiver(s) impacted by each action occurring during the sequence)  
'  
' Thread Other Thread  
' MUTEXLOCK(mutexID) <------------------------- from MUTEXUNLOCK(mutexID)  
' .......  
' booleanOT = True ---------------------------> to While booleanOT <> True  
' .......  
' MUTEXUNLOCK(mutexID) -----------------------> to MUTEXLOCK(mutexID)

```

During 'CondWait', the thread execution is suspended and does not consume any CPU time until the condition variable is signaled.
 But if 'Sleep x, 1' is put instead, the waiting time is predetermined and not self adaptive like that of 'CondWait'.

 **=>** 'CondWait' is useful to optimize the execution time.

Back to top

5. How to implement a user input-line function fully thread-safe?

The `Input` keyword may be not thread-safe, when another thread must also access to input/output resource:

**-** When executing the `Input` statement, the other running threads must not change the position of the text cursor, which prohibits instructions such as `Locate`, `Print`, ...
 **-** Moreover, one cannot enclosed the `Input` keyword inside a mutex locking (as we can do it for the `Inkey` keyword), because while the inputting line would be not completed and validated, the other threads that want to also access to input/output would be fully blocked (waiting for mutex unlocking).

Thread-safe input-line function (versus input/output resource):

Input position, prompt message, sleeping time, line-blanking command, mutex pointer can be passed to the following `threadInput()` function that simulates a simplified input function, but thread-safe, by using a looping around the `Inkey` keyword (all input/output keywords must be enclosed inside a mutex locking block, and the cursor position must be restored at each mutex locking block ending):

```freebasic
Function threadInput (ByVal row As Integer, ByVal column As Integer, ByRef prompt As String = "", _

   ByVal sleeptime As Integer = 15, ByVal blank As Integer = 0, ByVal mutex As Any Ptr = 0 _

   ) As String

   Dim As String inputchr

   Dim As String inputline

   Dim As Integer cursor

   Dim As Integer cursor0

   Dim As Integer r

   Dim As Integer c

   MutexLock(mutex)

   r = CsrLin()

   c = Pos()

   Locate row, column

   Print prompt & " _";

   cursor0 = Pos() - 1

   Locate r, c

   MutexUnlock(mutex)

   Do

   MutexLock(mutex)

   r = CsrLin()

   c = Pos()

   inputchr = Inkey

   If inputchr <> "" Then

   If inputchr >= Chr(32) And inputchr < Chr(255) Then

   inputline = Left(inputline, cursor) & inputchr & Mid(inputline, cursor + 1)

   cursor += 1

   ElseIf inputchr = Chr(08) And Cursor > 0 Then 'BkSp

   cursor -= 1

   inputline = Left(inputline, cursor) & Mid(inputline, cursor + 2)

   ElseIf inputchr = Chr(255) & "S" And Cursor < Len(inputline) Then 'Del

   inputline = Left(inputline, cursor) & Mid(inputline, cursor + 2)

   ElseIf inputchr = Chr(255) + "M" And Cursor < Len(inputline) Then 'Right

   Cursor += 1

   ElseIf inputchr = Chr(255) + "K" And Cursor > 0 Then 'Left

   Cursor -= 1

   End If

   If inputchr = Chr(27) Then 'Esc

   Locate row, cursor0

   Print Space(Len(inputline) + 1);

   inputline = ""

   cursor = 0

   End If

   Locate row, cursor0

   Print Left(inputline, cursor) & Chr(95) & Mid(inputline, cursor + 1) & " ";

   End If

   Locate r, c

   MutexUnlock(mutex)

   Sleep sleeptime, 1

   Loop Until inputchr = Chr(13)

   If blank <> 0 Then

   MutexLock(mutex)

   r = CsrLin()

   c = Pos()

   Locate row, cursor0

   Print Space(Len(inputline) + 1);

   Locate r, c

   MutexUnlock(mutex)

   End If

   Return inputline

End Function
```

```freebasic
' User thread algorithm:  
'  
' Do  
' | Mutexlock  
' | .....  
' | Critical section of code  
' | .....  
' | Mutexunlock  
' | Sleep my_tempo, 1  
' Loop Until quit = true  
'  
' There is no any advantage or disadvantage between threads for running their critical sections.

```

```freebasic
Function threadInput (ByVal row As Integer, ByVal column As Integer, ByRef prompt As String = "", _

   ByVal sleeptime As Integer = 15, ByVal blank As Integer = 0, ByVal mutex As Any Ptr = 0 _

   ) As String

   Dim As String inputchr

   Dim As String inputline

   Dim As Integer cursor

   Dim As Integer cursor0

   Dim As Integer r

   Dim As Integer c

   MutexLock(mutex)

   r = CsrLin()

   c = Pos()

   Locate row, column

   Print prompt & " _";

   cursor0 = Pos() - 1

   Locate r, c

   MutexUnlock(mutex)

   Do

   MutexLock(mutex)

   r = CsrLin()

   c = Pos()

   inputchr = Inkey

   If inputchr <> "" Then

   If inputchr >= Chr(32) And inputchr < Chr(255) Then

   inputline = Left(inputline, cursor) & inputchr & Mid(inputline, cursor + 1)

   cursor += 1

   ElseIf inputchr = Chr(08) And Cursor > 0 Then 'BkSp

   cursor -= 1

   inputline = Left(inputline, cursor) & Mid(inputline, cursor + 2)

   ElseIf inputchr = Chr(255) & "S" And Cursor < Len(inputline) Then 'Del

   inputline = Left(inputline, cursor) & Mid(inputline, cursor + 2)

   ElseIf inputchr = Chr(255) + "M" And Cursor < Len(inputline) Then 'Right

   Cursor += 1

   ElseIf inputchr = Chr(255) + "K" And Cursor > 0 Then 'Left

   Cursor -= 1

   End If

   If inputchr = Chr(27) Then 'Esc

   Locate row, cursor0

   Print Space(Len(inputline) + 1);

   inputline = ""

   cursor = 0

   End If

   Locate row, cursor0

   Print Left(inputline, cursor) & Chr(95) & Mid(inputline, cursor + 1) & " ";

   End If

   Locate r, c

   MutexUnlock(mutex)

   Sleep sleeptime, 1

   Loop Until inputchr = Chr(13)

   If blank <> 0 Then

   MutexLock(mutex)

   r = CsrLin()

   c = Pos()

   Locate row, cursor0

   Print Space(Len(inputline) + 1);

   Locate r, c

   MutexUnlock(mutex)

   End If

   Return inputline

End Function

'------------------------------------------------------------------------------

Type UDT

   Dim As Integer number

   Dim As Integer tempo

   Dim As Any Ptr pThread

   Dim As ULongInt count

   Static As Any Ptr pMutex

   Static As Integer numberMax

   Static As Integer quit

End Type

Dim As Any Ptr UDT.pMutex

Dim As Integer UDT.numberMax

Dim As Integer UDT.quit

Sub Counter (ByVal pt As UDT Ptr)

   With *pt

   Locate .number, .number, 0

   Sleep 5, 1

   .count += 1

   Print .count;

   End With

End Sub

Sub Thread (ByVal p As Any Ptr)

   Dim As Integer myquit

   Dim As UDT Ptr pUDT = p

   With *pUDT

   Do

   MutexLock(.pMutex)

   Counter(pUDT)

   myquit = .quit

   MutexUnlock(.pMutex)

   Sleep .tempo, 1

   Loop Until myquit = 1

   End With

End Sub

Screen 12

UDT.numberMax = 6

Dim As UDT u(0 To UDT.numberMax)

For I As Integer = 0 To UDT.numberMax

   u(I).number = i

   u(I).tempo = 100 + 15 * I - 95 * Sgn(I)

Next I

UDT.pMutex = MutexCreate

Dim As Single t = Timer

For I As Integer = 1 To UDT.numberMax

   u(I).pThread = ThreadCreate(@Thread, @u(I))

Next I

Do

Loop Until LCase(threadInput(8, 1, """quit"" for exit?", 10, 1, UDT.pMutex)) = "quit"

UDT.quit = 1

For I As Integer = 1 To UDT.numberMax

   ThreadWait(u(I).pThread)

Next I

t = Timer - t

MutexDestroy(UDT.pMutex)

Dim As ULongInt c

For I As Integer = 1 To UDT.numberMax

   c += u(I).count

Next I

Locate UDT.numberMax + 4, 1

Print CULngInt(c / t) & " increments per second"

Sleep
```

**Note:**

Otherwise, by using only graphics keywords (using the only position of the graphic cursor) as `Line`, `Draw String`, `Put` in the thread, induces a thread-safe procedure that is compatible with the `Line Input` keyword in the main code with no mutex:

```freebasic
Type UDT

   Dim As Integer number

   Dim As Integer tempo

   Dim As Any Ptr pThread

   Dim As ULongInt count

   Dim As Any Ptr img

   Static As Integer numberMax

   Static As Integer quit

End Type

Dim As Integer UDT.numberMax

Dim As Integer UDT.quit

Const As String prompt = "Enter ""quit"" for exit"

Dim As String s

Sub Counter (ByVal pt As UDT Ptr) ' for a graphic character size 8x16

   With *pt

   Line .img, (0, 0)-(20 * 8 - 1, 16 - 1), 0, BF ' clearing the image buffer

   Sleep 5, 1

   .count += 1

   Draw String .img, (0, 0), Str(.count) ' drawing in the image buffer

   Put ((.number - 1) * 8, (.number - 1) * 16), .img, PSet ' copying the image buffer to screen

   End With

End Sub

Sub Thread (ByVal p As Any Ptr) ' for a graphic character size 8x16

   Dim As UDT Ptr pUDT = p

   With *pUDT

   .img = ImageCreate(20 * 8, 16) ' using an image buffer to avoid flickering

   Do

   Counter(pUDT)

   Sleep .tempo, 1

   Loop Until .quit = 1

   ImageDestroy .img ' destroying the image buffer

   End With

End Sub

Screen 12

UDT.numberMax = 6

Dim As UDT u(0 To UDT.numberMax)

For I As Integer = 0 To UDT.numberMax

   u(I).number = i

   u(I).tempo = 100 + 15 * I - 95 * Sgn(I)

Next I

Dim As Single t = Timer

For I As Integer = 1 To UDT.numberMax

   u(I).pThread = ThreadCreate(@Thread, @u(I))

Next I

Do

   Locate 8, 1, 0

   Line Input; prompt; s

   Locate , Len(prompt) + 3

   Print Space(Len(s));

Loop Until LCase(s) = "quit"

UDT.quit = 1

For I As Integer = 1 To UDT.numberMax

   ThreadWait(u(I).pThread)

Next I

t = Timer - t

Dim As ULongInt c

For I As Integer = 1 To UDT.numberMax

   c += u(I).count

Next I

Locate UDT.numberMax + 4, 1

Print CULngInt(c / t) & " increments per second"

Sleep
```

Back to top

6. How to use 'Screenlock' with multi-threading?

**-** `Screenlock...Scrennunlock` blocks are not compatible with multi-threading (otherwise, the program hangs). This is why a mutex block must be used around each such block to ensure the mutual exclusion.
 **-** The input keywords (like for keyboard, mouse) cannot be safely run when the screen is locked, therefore a such keyword must be outside of any `Screenlock...Screenunlock` block, so outside any `Screenlock...Screenunlock` block in its own thread, and protected of all `Screenlock...Screenunlock` blocks of other threads by a mutex block. Therefore, `Getkey` and `Input`, the statements that wait for keypress or line input are unusable, but `Inkey` that does not wait can work.

 By applying some rules scrupulously, one can use `Screenlock`/`Screenunlock` inside the threads.
 Principle of coding for all threads including the main code (main thread):

```freebasic
Do  
' instructions without display (printing/drawing, ...) neither input (input/inkey/mouse getting, ...)  
MutexLock(m)  
Screenlock  
' instructions with only display (printing/drawing, ...)  
Screenunlock  
' instructions with only input without waiting (inkey/mouse getting, ...)  
MutexUnlock(m)  
Sleep tempo, 1  
Loop Until condition

```

```freebasic
Type ThreadUDT

   Dim handle As Any Ptr

   Static sync As Any Ptr

   Static quit As Byte

End Type

Dim ThreadUDT.sync As Any Ptr

Dim ThreadUDT.quit As Byte

Function ClockTime () As String

   Return Time

End Function

Function Counter () As Integer

   Static C As Integer

   C = (C + 1) Mod 1000000

   Return C

End Function

Sub ProcedureThread (ByVal param As Any Ptr)

   With *Cast(ThreadUDT Ptr, param)

   Do

   MutexLock(.sync)

   ScreenLock

   Line (544, 0)-(639, 49), 0, BF 'clear the print area

   Sleep 100, 1

   Locate 2, 71

   Print ClockTime();

   ScreenUnlock

   MutexUnlock(.sync)

   Sleep 100, 1

   Loop Until .quit = 1

   End With

End Sub

Screen 12

Locate 30, 2

Print "<q/Q> : quit";

Dim TTptr As ThreadUDT Ptr = New ThreadUDT

ThreadUDT.sync = MutexCreate

TTptr->handle = ThreadCreate(@ProcedureThread, TTptr)

Dim As String s

Do

   MutexLock(ThreadUDT.sync)

   ScreenLock

   Line (296, 208)-(376, 256), 0, BF 'clear the print area

   Sleep 100, 1

   Locate 15,40

   Print Using "######"; Counter();

   ScreenUnlock

   s = Inkey

   MutexUnlock(ThreadUDT.sync)

   Sleep 100, 1

Loop Until LCase(s) = "q"

ThreadUDT.quit = 1

ThreadWait(TTptr->handle)

MutexDestroy(ThreadUDT.sync)

Delete TTptr
```

 Note: The `Sleep x, 1` keyword just after the 'clear the print area' lines is only here to highlight the flickering if no screen locking is used.

Back to top

7. How to use 'video paging (double buffering or page flipping)' with multi-threading?

Instead of "screen locking" (see the above paragraph), "video paging (double buffering or page flipping)" can more simply be used with multi-threading, but be careful that many states in the gfxlib2 are thread-dependent like `Screenset` (and also `View` settings, graphic cursor position, graphic colors, ...).
 Therefore, the setting for the working page and the visible page must always be controlled in each thread code which want to work with a multi-video page configuration.

```freebasic
Type ThreadUDT

   Dim handle As Any Ptr

   Static sync As Any Ptr

   Static quit As Byte

End Type

Dim ThreadUDT.sync As Any Ptr

Dim ThreadUDT.quit As Byte

Function ClockTime () As String

   Return Time

End Function

Function Counter () As Integer

   Static C As Integer

   C = (C + 1) Mod 1000000

   Return C

End Function

Sub ProcedureThread (ByVal param As Any Ptr)

   ScreenSet 1, 0 '' setting to define in each thread

   With *Cast(ThreadUDT Ptr, param)

   Do

   MutexLock(.sync)

   Line (544, 0)-(639, 49), 0, BF '' clear the print area

   Sleep 100, 1

   Locate 2, 71

   Print ClockTime();

   ScreenCopy

   MutexUnlock(.sync)

   Sleep 100, 1

   Loop Until .quit = 1

   End With

End Sub

Screen 12, , 2

ScreenSet 1, 0 '' setting to define in each thread

Locate 30, 2

Print "<q/Q> : quit";

ScreenCopy

Dim TTptr As ThreadUDT Ptr = New ThreadUDT

ThreadUDT.sync = MutexCreate

TTptr->handle = ThreadCreate(@ProcedureThread, TTptr)

Dim s As String

Do

   MutexLock(ThreadUDT.sync)

   Line (296, 208)-(376, 256), 0, BF '' clear the print area

   Sleep 100, 1

   Locate 15,40

   Print Using "######"; Counter();

   ScreenCopy

   s = Inkey

   MutexUnlock(ThreadUDT.sync)

   Sleep 100, 1

Loop Until LCase(s) = "q"

ThreadUDT.quit = 1

ThreadWait(TTptr->handle)

MutexDestroy(ThreadUDT.sync)

Delete TTptr
```

 Note: The `Sleep x, 1` keyword just after the 'clear the print area' lines is only here to highlight the flickering if no double buffering is used.

```freebasic
Type ThreadUDT

   Dim handle As Any Ptr

   Static sync As Any Ptr

   Static quit As Byte

End Type

Dim ThreadUDT.sync As Any Ptr

Dim ThreadUDT.quit As Byte

Function ClockTime () As String

   Return Time

End Function

Function Counter () As Integer

   Static C As Integer

   C = (C + 1) Mod 1000000

   Return C

End Function

Sub ProcedureThread (ByVal param As Any Ptr)

   Dim p0 As Integer = 0

   Dim p1 As Integer = 1

   ScreenSet 1, 0 '' setting to define in each thread

   With *Cast(ThreadUDT Ptr, param)

   Do

   MutexLock(.sync)

   Dim s As String = ClockTime()

   For I As Integer = 1 To 2 '' updating the two screen pages

   Line (544, 0)-(639, 49), 0, BF '' clear the print area

   Sleep 100, 1

   Locate 2, 71

   Print s;

   ScreenSet p0, p1

   Swap p0, p1

   Next I

   MutexUnlock(.sync)

   Sleep 100, 1

   Loop Until .quit = 1

   End With

End Sub

Screen 12, , 2

Dim p0 As Integer = 0

Dim p1 As Integer = 1

ScreenSet 1, 0 '' setting to define in each thread

For I As Integer = 1 To 2 '' updating the two screen pages

   Locate 30, 2

   Print "<q/Q> : quit";

   ScreenSet p0, p1

   Swap p0, p1

Next I

Dim TTptr As ThreadUDT Ptr = New ThreadUDT

ThreadUDT.sync = MutexCreate

TTptr->handle = ThreadCreate(@ProcedureThread, TTptr)

Dim s As String

Do

   MutexLock(ThreadUDT.sync)

   Dim C As Integer = Counter()

   For I As Integer = 1 To 2 '' updating the two screen pages

   Line (296, 208)-(376, 256), 0, BF '' clear the print area

   Sleep 100, 1

   Locate 15,40

   Print Using "######"; c;

   ScreenSet p0, p1

   Swap p0, p1

   Next I

   s = Inkey

   MutexUnlock(ThreadUDT.sync)

   Sleep 100, 1

Loop Until LCase(s) = "q"

ThreadUDT.quit = 1

ThreadWait(TTptr->handle)

MutexDestroy(ThreadUDT.sync)

Delete TTptr
```

 Note: The `Sleep x, 1` keyword just after the 'clear the print area' lines is only here to highlight the flickering if no two page flipping is used.

**Note:** In these two examples, a mutual exclusion mutex code block is mandatory in the two threads, not only because of using console statements + `Inkey`, but around also the graphics statements + `Screencopy` only because of using double buffering method (without anti-flickering process, the graphics statements could be outside the exclusion mutex code block).

Back to top

8. How to use the FB runtime library for multi-threaded applications (gfxlib2) with multi-threading?

The source code of gfxlib2 uses TLS (Thread Local Storage) to store many states, so many things are thread-specific.
 Since gfxlib2 is thread-safe, mutual mutex exclusion between threads is not necessary for the graphics statements themselves (including `Draw String`).
 In contrast, console statements such as `Locate`, `Print`, ... are not thread-safe as previously mentioned (for example, text cursor position is common to all threads).

```freebasic
Screen 12

Sub thread(ByVal p As Any Ptr)

   Color 10

   PSet(150, 10)

   For I As Integer = 1 To 40

   Line -Step(10, 10)

   Sleep 150, 1

   Next I

   Draw String Step (-40, 10), "user thread"

End Sub

Dim As Any Ptr p = ThreadCreate(@thread)

Color 14

PSet(10, 100)

For I As Integer = 1 To 24

   Line -Step(10, 10)

   Sleep 250, 1

Next I

Draw String Step (-40, 10), "main thread"

ThreadWait(p)

Color 15

Locate 4, 2

Print "Any key for exit"

Sleep
```

```freebasic
#include "vbcompat.bi"

Screen 12, , 2

ScreenSet 1, 0

Color 0, 7

Cls

Dim Shared terminate As Integer = 0

Sub thread (ByVal param As Any Ptr)

   ScreenSet 1, 0

   Do

   Line (16, 432)-Step(96, 32), 11, BF 'clear print area

   Sleep 100, 1

   Draw String (24, 432), Format(Now,"dd/mm/yyyy"), 0

   Draw String (32, 448), Format(Now,"hh:mm:ss"), 0

   ScreenCopy

   Sleep 100, 1

   Loop Until terminate = 1

End Sub

Dim As String reply

Locate 2, 2

Print "Enter ""q"" to quit"

ScreenCopy

Dim p As Any Ptr = ThreadCreate(@thread)

Do

   reply = Inkey

   Sleep 100, 1

Loop Until LCase(reply) = "q"

Print " Stop the thread"

ScreenCopy

terminate=1

ThreadWait (p)

Print " Thread terminated"

ScreenCopy

Sleep
```

 Note: The `Sleep x, 1` keyword just after the 'clear the print area' line is only here to highlight the flickering if no double buffering is used.

```freebasic
#include "vbcompat.bi"

Screen 12, , 2

ScreenSet 1, 0

Color 0, 7

Cls

Dim Shared terminate As Integer = 0

Dim Shared mutex As Any Ptr

Sub thread1 (ByVal param As Any Ptr)

   ScreenSet 1, 0

   Do

   MutexLock(mutex)

   Line (16, 432)-Step(96, 16), 11, BF 'clear the print area

   Sleep 200, 1

   Draw String (24, 432), Format(Now,"dd/mm/yyyy"), 0

   ScreenCopy

   MutexUnlock(mutex)

   Sleep 100, 1

   Loop Until terminate = 1

End Sub

Sub thread2 (ByVal param As Any Ptr)

   ScreenSet 1, 0

   Do

   MutexLock(mutex)

   Line (16, 448)-Step(96, 16), 11, BF 'clear the print area

   Sleep 100, 1

   Draw String (32, 448), Format(Now,"hh:mm:ss"), 0

   ScreenCopy

   MutexUnlock(mutex)

   Sleep 100, 1

   Loop Until terminate = 1

End Sub

Dim As String reply

Locate 2, 2

Print "Enter ""q"" to quit"

ScreenCopy

mutex = MutexCreate

Dim p1 As Any Ptr = ThreadCreate(@thread1)

Dim p2 As Any Ptr = ThreadCreate(@thread2)

Do

   reply = Inkey

   Sleep 100, 1

Loop Until LCase(reply) = "q"

Print " Stop the threads"

ScreenCopy

terminate=1

ThreadWait (p1)

ThreadWait (p2)

MutexDestroy(mutex)

Print " Threads terminated"

ScreenCopy

Sleep
```

 Note: The `Sleep x, 1` keyword just after the 'clear the print area' lines is only here to highlight the flickering if no double buffering is used, or if no mutex is used.

Back to top

9. How to use console statements and keyboard inputs with multi-threading?

Console statements (such as `Locate`, `Print`, `Color`, ...), as well as `Locate` and `Print` on Graphics window (but not `Color` on Graphics Window), and keyboard inputs (such as `Inkey`, `Getkey`, `Input`, ...) are not thread-safe:

**-** Thus when they are used in competing sections of different threads, mutual exclusion is mandatory by means of mutex locking blocks in which in addition code can restore states (such as text cursor position, console color, ...) at end of the block (after its own usage), as they were before (at begin of the block).
 **-** But the `Getkey` or `Input` keyword cannot be enclosed inside a mutex locking block (as it can be do with the `Inkey` keyword), because as long as the keyboard input is not completed, the other threads in compete would be fully blocked (waiting for the mutex unlocking).

```freebasic
Sub Thread (ByVal p As Any Ptr)

   Locate Cast(Integer, p), Cast(Integer, p)

   For I As Integer = 1 To 50 - 2 * Cast(Integer, p)

   Sleep 20 * Cast(Integer, p), 1

   Print Str(Cast(Integer, p));

   Next I

End Sub

Sub test ()

   Dim As Any Ptr p(1 To 9)

   For I As Integer = 1 To 9

   p(I) = ThreadCreate(@Thread, Cast(Any Ptr, I))

   Sleep 25, 1

   Next I

   For I As Integer = 1 To 9

   ThreadWait(p(I))

   Next I

End Sub

Screen 0

test()

Locate 15, 1

Print "Any key to continue"

Sleep

Screen 12

test()

Locate 15, 1

Print "Any key to quit"

Sleep
```

 Note: One can see that each thread does not write on its own line corresponding to its thread number (id between 1 and 9), on the console window and on the graphics window.

```freebasic
Dim Shared As Any Ptr mutex

Sub Thread (ByVal p As Any Ptr)

   MutexLock(mutex)

   Dim As Long l0 = Locate()

   Locate Cast(Integer, p), Cast(Integer, p)

   Dim As Long l = Locate()

   Locate HiByte(LoWord(l0)), LoByte(LoWord(l0)), HiWord(l0)

   MutexUnlock(mutex)

   For I As Integer = 1 To 50 - 2 * Cast(Integer, p)

   Sleep 20 * Cast(Integer, p), 1

   MutexLock(mutex)

   l0 = Locate()

   Locate HiByte(LoWord(l)), LoByte(LoWord(l)), HiWord(l)

   Print Str(Cast(Integer, p));

   l = Locate()

   Locate HiByte(LoWord(l0)), LoByte(LoWord(l0)), HiWord(l0)

   MutexUnlock(mutex)

   Next I

End Sub

Sub test ()

   Dim As Any Ptr p(1 To 9)

   For I As Integer = 1 To 9

   p(I) = ThreadCreate(@Thread, Cast(Any Ptr, I))

   Sleep 25, 1

   Next I

   For I As Integer = 1 To 9

   ThreadWait(p(I))

   Next I

End Sub

mutex = MutexCreate

Screen 0

test()

Locate 15, 1

Print "Any key to continue"

Sleep

Screen 12

test()

Locate 15, 1

Print "Any key to quit"

Sleep

MutexDestroy(mutex)
```

 Note: One can see that each thread writes now on its own line corresponding to its thread number (id between 1 and 9), on the console window and on the graphics window.

```freebasic
Sub Thread (ByVal p As Any Ptr)

   Color Cast(Integer, p) + 8, Cast(Integer, p)

   For I As Integer = 1 To 50 - 2 * Cast(Integer, p)

   Print " " & Cast(Integer, p) & " ";

   Sleep 20 * Cast(Integer, p), 1

   Next I

End Sub

Sub test ()

   Dim As Any Ptr p(1 To 9)

   Locate 1, 1

   For I As Integer = 1 To 9

   p(I) = ThreadCreate(@Thread, Cast(Any Ptr, I))

   Sleep 25, 1

   Next I

   For I As Integer = 1 To 9

   ThreadWait(p(I))

   Next I

   Locate 16, 1

End Sub

Screen 0

test()

Print "Any key to continue"

Sleep

Screen 12

test()

Print "Any key to quit"

Sleep
```

 Note: One can see that the foreground/background colors are not specific to the thread number (id between 1 and 9) on the console window, but this works great on the graphics window.

```freebasic
Dim Shared As Any Ptr mutex

Sub Thread (ByVal p As Any Ptr)

   MutexLock(mutex)

   Dim As ULong c0 = Color(Cast(Integer, p) + 8, Cast(Integer, p))

   Dim As ULong c = Color()

   Color(LoWord(c0), HiWord(c0))

   MutexUnlock(mutex)

   For I As Integer = 1 To 50 - 2 * Cast(Integer, p)

   MutexLock(mutex)

   c0 = Color(LoWord(c), HiWord(c))

   Print " " & Cast(Integer, p) & " ";

   Color(LoWord(c0), HiWord(c0))

   MutexUnlock(mutex)

   Sleep 20 * Cast(Integer, p), 1

   Next I

End Sub

Sub test ()

   Dim As Any Ptr p(1 To 9)

   Locate 1, 1

   For I As Integer = 1 To 9

   p(I) = ThreadCreate(@Thread, Cast(Any Ptr, I))

   Sleep 25, 1

   Next I

   For I As Integer = 1 To 9

   ThreadWait(p(I))

   Next I

   Locate 16, 1

End Sub

mutex = MutexCreate

Screen 0

test()

Print "Any key to continue"

Sleep

Screen 12

test()

Print "Any key to quit"

Sleep

MutexDestroy(mutex)
```

 Note: One can see that the foreground/background colors are now specific to the thread number (id between 1 and 9) on the console window (obviously this always works on the graphics window).

Therefore, for using Getkey or Input in competing sections of threads:

**-** Only a single thread (for example, the main thread) can uses `Getkey` or `Input` in addition to console statements (such as `Locate`, `Print`, `Color`, ...) and also `Inkey`, in its competing sections.
 **-** The other threads must not to use in their competing sections any console statement neither any keyboard input keyword, but can use by cons graphics statements (such as `Pset`, `Line`, `Circle`, `Draw String`, graphic `Color`, ...) which are themselves thread-safe (they can interlace graphically with the main thread without any problem).
 **-** `Input` and `Getkey` also exclude the screen locking usage in competing sections of threads (double buffering is recommended as anti-flickering method).

```freebasic
#include "vbcompat.bi"

Screen 12, , 2

ScreenSet 1, 0

Color 0, 7

Cls

Dim Shared terminate As Integer = 0

Sub thread (ByVal param As Any Ptr)

   ScreenSet 1, 0

   Do

   Line (16, 432)-Step(96, 32), 11, BF 'clear the print area

   Sleep 100, 1

   Draw String (24, 432), Format(Now,"dd/mm/yyyy"), 0

   Draw String (32, 448), Format(Now,"hh:mm:ss"), 0

   ScreenCopy

   Sleep 100, 1

   Loop Until terminate = 1

End Sub

Dim As String reply

Locate 2, 2

Print "Enter ""quit"" to quit"

ScreenCopy

Dim p As Any Ptr = ThreadCreate(@thread)

Do

   Locate 3, 2

   Print Space(Len(reply) + 2);

   Locate 3, 2

   Input reply

Loop Until LCase(reply) = "quit"

Print " Stop the thread"

ScreenCopy

terminate=1

ThreadWait (p)

Print " Thread terminated"

ScreenCopy

Sleep
```

 Note: The `Sleep x, 1` keyword just after the 'clear the print area' line is only here to highlight the flickering if no double buffering is used (screen locking being forbidden by Input usage).

```freebasic
#include "vbcompat.bi"

Screen 12, , 2

ScreenSet 1, 0

Color 0, 7

Cls

Dim Shared terminate As Integer = 0

Dim Shared mutex As Any Ptr

Sub thread1 (ByVal param As Any Ptr)

   ScreenSet 1, 0

   Do

   MutexLock(mutex)

   Line (16, 432)-Step(96, 16), 11, BF 'clear the print area

   Sleep 200, 1

   Draw String (24, 432), Format(Now,"dd/mm/yyyy"), 0

   ScreenCopy

   MutexUnlock(mutex)

   Sleep 100, 1

   Loop Until terminate = 1

End Sub

Sub thread2 (ByVal param As Any Ptr)

   ScreenSet 1, 0

   Do

   MutexLock(mutex)

   Line (16, 448)-Step(96, 16), 11, BF 'clear the print area

   Sleep 100, 1

   Draw String (32, 448), Format(Now,"hh:mm:ss"), 0

   ScreenCopy

   MutexUnlock(mutex)

   Sleep 100, 1

   Loop Until terminate = 1

End Sub

Dim As String reply

Locate 2, 2

Print "Enter ""quit"" to quit"

ScreenCopy

mutex = MutexCreate

Dim p1 As Any Ptr = ThreadCreate(@thread1)

Dim p2 As Any Ptr = ThreadCreate(@thread2)

Do

   Locate 3, 2

   Print Space(Len(reply) + 2);

   Locate 3, 2

   Input reply

Loop Until LCase(reply) = "quit"

Print " Stop the threads"

ScreenCopy

terminate=1

ThreadWait (p1)

ThreadWait (p2)

MutexDestroy(mutex)

Print " Threads terminated"

ScreenCopy

Sleep
```

 Note: The `Sleep x, 1` keyword just after the 'clear the print area' lines is only here to highlight the flickering if no double buffering is used (screen locking being forbidden by Input usage).

Back to top

10. Is it better to take precautions when using the keyword 'Sleep' in threads?

There is still some doubt about the perfect behavior of the keyword `Sleep` in a multi-threading context.

 It is therefore advisable to take the following precautions for its use:

**-** If it is absolutely necessary in a critical section of a thread, the syntax `Sleep x` or `Sleep x, 0`, because inducing an internal test of a key-press, must for greatest safety be preferably treated in the same way as the `Inkey` keyword to avoid as much as possible any concurrent conflict with other threads.
 **-** Otherwise, the syntax `Sleep x, 1` (inducing no internal test of key-press) is rather advised when there is no protection by mutual exclusion, which is very often the case in order to release time-slice for the other threads.

Back to top

11. Can all tools to handle multi-threading be encapsulated in a base Class (that the user extends with a derived Type for his own implementing)?

A simple 'threadUDT' base Class can be defined as follows:

**-** with a private 'Any Ptr' non-static member field for each handle,
 **-** with a private 'Any Ptr' static member field for one shared mutex,
 **-** with a private 'Any Ptr' static member field for one shared conditional variable,
 **-** with its own public member procedures 'Sub()' calling the corresponding built-in procedures for multi-threading (with same procedure names), including also value integrity tests on the 3 above pointers (non-static procedures for the 3 'thread...()' member Subs, and static procedures for the 4 'mutex...()' member Subs and the 5 'cond...()' member Subs),
 **-** with an abstract private 'Sub()' thread to be overridden by another 'Sub()' from inside the user derived Type (therefore its static address is available in the virtual table of the object, and the hidden 'This' parameter passed by reference is compatible with the 'Any Ptr' parameter to be passed to the thread).

```freebasic
#include Once "fbthread.bi"

Type threadUDT Extends Object

   Public:

   Declare Sub ThreadCreate ()

   Declare Sub ThreadWait ()

   Declare Sub ThreadDetach ()

   Declare Static Sub MutexCreate ()

   Declare Static Sub MutexLock ()

   Declare Static Sub MutexUnlock ()

   Declare Static Sub MutexDestroy ()

   Declare Static Sub CondCreate ()

   Declare Static Sub CondWait ()

   Declare Static Sub CondSignal ()

   Declare Static Sub CondBroadcast ()

   Declare Static Sub CondDestroy ()

   Private:

   Declare Abstract Sub thread ()

   Dim As Any Ptr pThread

   Static As Any Ptr pMutex

   Static As Any Ptr pCond

End Type

Dim As Any Ptr threadUDT.pMutex

Dim As Any Ptr threadUDT.pCond

Sub threadUDT.threadCreate ()

   If This.pThread = 0 Then

   This.pThread = .ThreadCreate(Cast(Any Ptr Ptr Ptr, @This)[0][0], @This)

   End If

End Sub

Sub threadUDT.threadWait ()

   If This.pThread > 0 Then

   .ThreadWait(This.pThread)

   This.pThread = 0

   End If

End Sub

Sub threadUDT.threadDetach ()

   If This.pThread > 0 Then

   .ThreadDetach(This.pThread)

   This.pThread = 0

   End If

End Sub

Sub threadUDT.mutexCreate ()

   If threadUDT.pMutex = 0 Then

   threadUDT.pMutex = .MutexCreate

   End If

End Sub

Sub threadUDT.mutexLock ()

   If threadUDT.pMutex > 0 Then

   .MutexLock(threadUDT.pMutex)

   End If

End Sub

Sub threadUDT.mutexUnlock ()

   If threadUDT.pMutex > 0 Then

   .MutexUnlock(threadUDT.pMutex)

   End If

End Sub

Sub threadUDT.mutexDestroy ()

   If threadUDT.pMutex > 0 Then

   .MutexDestroy(threadUDT.pMutex)

   threadUDT.pMutex = 0

   End If

End Sub

Sub threadUDT.condCreate ()

   If threadUDT.pCond = 0 Then

   threadUDT.pCond = .CondCreate

   End If

End Sub

Sub threadUDT.condWait ()

   If threadUDT.pCond > 0 And threadUDT.pMutex > 0 Then

   .CondWait(threadUDT.pCond, threadUDT.pMutex)

   End If

End Sub

Sub threadUDT.condSignal ()

   If threadUDT.pCond > 0 And threadUDT.pMutex > 0 Then

   .CondSignal(threadUDT.pCond)

   End If

End Sub

Sub threadUDT.condBroadcast ()

   If threadUDT.pCond > 0 And threadUDT.pMutex > 0 Then

   .CondBroadcast(threadUDT.pCond)

   End If

End Sub

Sub threadUDT.condDestroy ()

   If threadUDT.pCond > 0 Then

   .CondDestroy(threadUDT.pCond)

   threadUDT.pCond = 0

   End If

End Sub
```

```freebasic
#include Once "fbthread.bi"

Type threadUDT Extends Object

   Public:

   Declare Sub ThreadCreate ()

   Declare Sub ThreadWait ()

   Declare Sub ThreadDetach ()

   Declare Static Sub MutexCreate ()

   Declare Static Sub MutexLock ()

   Declare Static Sub MutexUnlock ()

   Declare Static Sub MutexDestroy ()

   Declare Static Sub CondCreate ()

   Declare Static Sub CondWait ()

   Declare Static Sub CondSignal ()

   Declare Static Sub CondBroadcast ()

   Declare Static Sub CondDestroy ()

   Private:

   Declare Abstract Sub thread ()

   Dim As Any Ptr pThread

   Static As Any Ptr pMutex

   Static As Any Ptr pCond

End Type

Dim As Any Ptr threadUDT.pMutex

Dim As Any Ptr threadUDT.pCond

Sub threadUDT.threadCreate ()

   If This.pThread = 0 Then

   This.pThread = .ThreadCreate(Cast(Any Ptr Ptr Ptr, @This)[0][0], @This)

   End If

End Sub

Sub threadUDT.threadWait ()

   If This.pThread > 0 Then

   .ThreadWait(This.pThread)

   This.pThread = 0

   End If

End Sub

Sub threadUDT.threadDetach ()

   If This.pThread > 0 Then

   .ThreadDetach(This.pThread)

   This.pThread = 0

   End If

End Sub

Sub threadUDT.mutexCreate ()

   If threadUDT.pMutex = 0 Then

   threadUDT.pMutex = .MutexCreate

   End If

End Sub

Sub threadUDT.mutexLock ()

   If threadUDT.pMutex > 0 Then

   .MutexLock(threadUDT.pMutex)

   End If

End Sub

Sub threadUDT.mutexUnlock ()

   If threadUDT.pMutex > 0 Then

   .MutexUnlock(threadUDT.pMutex)

   End If

End Sub

Sub threadUDT.mutexDestroy ()

   If threadUDT.pMutex > 0 Then

   .MutexDestroy(threadUDT.pMutex)

   threadUDT.pMutex = 0

   End If

End Sub

Sub threadUDT.condCreate ()

   If threadUDT.pCond = 0 Then

   threadUDT.pCond = .CondCreate

   End If

End Sub

Sub threadUDT.condWait ()

   If threadUDT.pCond > 0 And threadUDT.pMutex > 0 Then

   .CondWait(threadUDT.pCond, threadUDT.pMutex)

   End If

End Sub

Sub threadUDT.condSignal ()

   If threadUDT.pCond > 0 And threadUDT.pMutex > 0 Then

   .CondSignal(threadUDT.pCond)

   End If

End Sub

Sub threadUDT.condBroadcast ()

   If threadUDT.pCond > 0 And threadUDT.pMutex > 0 Then

   .CondBroadcast(threadUDT.pCond)

   End If

End Sub

Sub threadUDT.condDestroy ()

   If threadUDT.pCond > 0 Then

   .CondDestroy(threadUDT.pCond)

   threadUDT.pCond = 0

   End If

End Sub

'------------------------------------------------------------------------------

Type UDT Extends threadUDT

   Declare Sub counter ()

   Declare Sub thread ()

   Dim As Integer number

   Dim As Integer tempo

   Dim As ULongInt count

   Static As Integer threadPriorityNumber

   Static As Integer numberMax

   Static As Integer quit

End Type

Dim As Integer UDT.threadPriorityNumber

Dim As Integer UDT.numberMax

Dim As Integer UDT.quit

Sub UDT.counter ()

   Locate This.number, This.number, 0

   Sleep 5, 1

   This.count += 1

   Print This.count;

   Locate This.number, 30 + This.number, 0

End Sub

Sub UDT.Thread ()

   Dim As Integer myquit

   Do

   This.mutexLock()

   While UDT.threadPriorityNumber <> This.number '' synchronous condwait for expected condition

   This.condWait()

   Wend

   This.counter()

   myquit = UDT.quit

   UDT.threadPriorityNumber = (UDT.threadPriorityNumber + 1) Mod (UDT.numberMax + 1)

   This.condBroadcast()

   This.mutexUnlock()

   Sleep This.tempo, 1

   Loop Until myquit = 1

End Sub

UDT.numberMax = 6

Dim As UDT u(0 To UDT.numberMax)

For I As Integer = 0 To UDT.numberMax

   u(I).number = i

   u(I).tempo = 100 + 15 * I - 95 * Sgn(I)

Next I

UDT.mutexCreate()

UDT.condCreate()

Dim As Single t = Timer

For I As Integer = 1 To UDT.numberMax

   u(I).ThreadCreate()

Next I

Dim As String s

Do

   UDT.mutexLock()

   While UDT.threadPriorityNumber <> u(0).number

   UDT.condWait()

   Wend

   s = Inkey

   If s <> "" Then

   UDT.quit = 1

   End If

   UDT.threadPriorityNumber = (UDT.threadPriorityNumber + 1) Mod (UDT.numberMax + 1)

   UDT.condBroadcast()

   UDT.mutexUnlock()

   Sleep u(0).tempo, 1

Loop Until s <> ""

For I As Integer = 1 To UDT.numberMax

   u(I).ThreadWait()

Next I

t = Timer - t

UDT.mutexDestroy()

UDT.condDestroy()

Dim As ULongInt c

For I As Integer = 1 To UDT.numberMax

   c += u(I).count

Next I

Locate UDT.numberMax+2, 1

Print CULngInt(c / t) & " increments per second"

Sleep
```

Back to top

12. What is the execution delay of the code of a thread after the thread is created by 'ThreadCreate'?

One might think that the first code line of the thread is always executed at least after the 'ThreadCreate()' returns, but this is neither guaranteed nor even observed.

 One can estimate the delay (positive or negative) between the 'ThreadCreate()' return and the the thread start, by a time memorization as similar as possible between the line following 'ThreadCreate()' and the first thread code line (the delay calculation is executed after the end of the thread).
 After a while of observation, one can find both small negative values and large positive values.

 Interesting to see the min time, average time, and max time, between the executing start of thread body and the returning point of 'ThreadCreate()':

```freebasic
Dim As Any Ptr ptid

Dim As Double t0

Dim As Any Ptr p0 = @t0

Dim As Double t1

Dim As Double count

Dim As Single tmean

Dim As Single tmin = 10 '' start value

Dim As Single tmax = -10 '' start value

Sub myThread (ByVal p As Any Ptr)

   *Cast(Double Ptr, p) = Timer '' similar code line as in main code

End Sub

Print "Tmin/Tmean/Tmax between begin of thread code and return from ThreadCreate() :"

Do

   count += 1

   ptid = ThreadCreate(@myThread, @t1)

   *Cast(Double Ptr, p0) = Timer '' similar code line as in thread code

   ThreadWait(ptid)

   tmean = (tmean * (count - 1) + (t1 - t0)) / count

   If t1 - t0 < tmin Or t1 - t0 > tmax Then

   If t1 - t0 < tmin Then

   tmin = t1 - t0

   End If

   If t1 - t0 > tmax Then

   tmax = t1 - t0

   End If

   Print Time; Using " Tmin=+###.###### ms Tmean=+###.###### ms Tmax=+###.###### ms"; tmin * 1000; tmean * 1000; tmax * 1000

   End If

Loop Until Inkey <> ""
```

 Output (for example):

```freebasic
Tmin/Tmean/Tmax between begin of thread code and return from ThreadCreate() :  
21:30:13 Tmin= +0.151800 ms Tmean= +0.151800 ms Tmax= +0.151800 ms  
21:30:13 Tmin= +0.006000 ms Tmean= +0.078900 ms Tmax= +0.151800 ms  
21:30:13 Tmin= +0.006000 ms Tmean= +0.098394 ms Tmax= +0.172500 ms  
21:30:13 Tmin= +0.006000 ms Tmean= +0.121555 ms Tmax= +0.884900 ms  
21:30:45 Tmin= +0.006000 ms Tmean= +0.055810 ms Tmax= +1.104200 ms  
21:30:54 Tmin= +0.006000 ms Tmean= +0.055764 ms Tmax= +4.056600 ms  
21:31:44 Tmin= -0.116300 ms Tmean= +0.055516 ms Tmax= +4.056600 ms  
21:32:10 Tmin= -0.136800 ms Tmean= +0.057177 ms Tmax= +4.056600 ms  
21:32:12 Tmin= -0.150300 ms Tmean= +0.057265 ms Tmax= +4.056600 ms  
21:33:17 Tmin= -0.150300 ms Tmean= +0.060048 ms Tmax= +4.979900 ms  
21:33:18 Tmin= -0.150300 ms Tmean= +0.060157 ms Tmax= +7.086300 ms  
21:33:23 Tmin= -0.150600 ms Tmean= +0.060347 ms Tmax= +7.086300 ms  
21:33:38 Tmin= -0.205900 ms Tmean= +0.060878 ms Tmax= +7.086300 ms  
21:35:30 Tmin= -0.208700 ms Tmean= +0.061315 ms Tmax= +7.086300 ms
```

Note:

If the user safely wish to always delay the thread execution at least after some code lines following the 'ThreadCreate()' line, a mutual exclusion between the 'ThreadCreate()' line and the start of the thread body can be used as this principle follows:

```freebasic
Dim Shared As Any Ptr pMutexForThreadStart

'-------------------------------------------

Sub Thread (ByVal p As Any Ptr)

   MutexLock(pMutexForThreadStart)

   MutexUnlock(pMutexForThreadStart)

   '

   ' user thread body

   '

End Sub

'--------------------------------------------

'

' user main code

'

pMutexForThreadStart = MutexCreate()

'

' user main code continues

'

MutexLock(pMutexForThreadStart)

Dim As Any Ptr pThread = ThreadCreate(@Thread)

'

' lines of code to be executed before the executing start of the user body of the thread

'

MutexUnlock(pMutexForThreadStart)

'

' user main code continues

'

ThreadWait(pThread)

MutexDestroy(pMutexForThreadStart)
```

Back to top

13. What is the synchronization latency when synchronizing threads either by mutual exclusions or by conditional variables?

The synchronization waiting phase of each thread should not consume any CPU resources like 'Sleep', which is the case of 'MutexLock()' and 'CondWait()' instructions.
 Thread synchronization by mutual exclusions or by conditional variables adds latency to the initial execution time of the threads, but this latency (a few microseconds) is infinitely shorter than that of a simple simple wait loop (a few milliseconds at best) containing the shortest sleep ('Sleep 1, 1') with a flag test.

 The following code allows to estimate this synchronization latency between the main thread and a child thread, by using either simple flags, either mutual exclusions, or conditional variables:

```freebasic
Dim Shared As Any Ptr mutex0, mutex1, mutex2, mutex, cond1, cond2, pt

Dim Shared As Integer flag1, flag2

Dim As Double t

'----------------------------------------------------------------------------------

#if defined(__FB_WIN32__)

Declare Function _setTimer Lib "winmm" Alias "timeBeginPeriod"(ByVal As ULong = 1) As Long

Declare Function _resetTimer Lib "winmm" Alias "timeEndPeriod"(ByVal As ULong = 1) As Long

#endif

Sub ThreadFlag(ByVal p As Any Ptr)

   MutexUnlock(mutex0) '' unlock mutex for main thread

   For I As Integer = 1 To 100

   While flag1 = 0

   Sleep 1, 1

   Wend

   flag1 = 0

   ' only child thread code runs (location for example)

   flag2 = 1

   Next I

End Sub

mutex0 = MutexCreate()

MutexLock(mutex0)

pt = ThreadCreate(@ThreadFlag)

MutexLock(mutex0) '' wait for thread launch (mutex unlock from child thread)

Print "Thread synchronization latency by simple flags:"

#if defined(__FB_WIN32__)

   _setTimer()

   Print "(in high resolution OS cycle period)"

#else

   Print "(in normal resolution OS cycle period)"

#endif

t = Timer

For I As Integer = 1 To 100

   flag1 = 1

   While flag2 = 0

   Sleep 1, 1

   Wend

   flag2 = 0

   ' only main thread code runs (location for example)

Next I

t = Timer - t

#if defined(__FB_WIN32__)

   _resetTimer()

#endif

ThreadWait(pt)

Print Using "####.## milliseconds per double synchronization (round trip)"; t * 10

Print

MutexDestroy(mutex0)

'----------------------------------------------------------------------------------

Sub ThreadMutex(ByVal p As Any Ptr)

   MutexUnlock(mutex0) '' unlock mutex for main thread

   For I As Integer = 1 To 100000

   MutexLock(mutex1) '' wait for mutex unlock from main thread

   ' only child thread code runs

   MutexUnlock(mutex2) '' unlock mutex for main thread

   Next I

End Sub

mutex0 = MutexCreate()

mutex1 = MutexCreate()

mutex2 = MutexCreate()

MutexLock(mutex0)

MutexLock(mutex1)

MutexLock(mutex2)

pt = ThreadCreate(@ThreadMutex)

MutexLock(mutex0) '' wait for thread launch (mutex unlock from child thread)

Print "Thread synchronization latency by mutual exclusions:"

t = Timer

For I As Integer = 1 To 100000

   MutexUnlock(mutex1) '' mutex unlock for child thread

   MutexLock(mutex2) '' wait for mutex unlock from child thread

   ' only main thread code runs

Next I

t = Timer - t

ThreadWait(pt)

Print Using "####.## microseconds per double synchronization (round trip)"; t * 10

Print

MutexDestroy(mutex0)

MutexDestroy(mutex1)

MutexDestroy(mutex2)

'----------------------------------------------------------------------------------

Sub ThreadCondVar(ByVal p As Any Ptr)

   MutexUnlock(mutex0) '' unlock mutex for main thread

   For I As Integer = 1 To 100000

   MutexLock(mutex)

   While flag1 = 0

   CondWait(cond1, mutex) '' wait for conditional signal from main thread

   Wend

   flag1 = 0

   ' only child thread code runs (location for example)

   flag2 = 1

   CondSignal(cond2) '' send conditional signal to main thread

   MutexUnlock(mutex)

   Next I

End Sub

mutex0 = MutexCreate()

mutex = MutexCreate()

MutexLock(mutex0)

cond1 = CondCreate()

cond2 = CondCreate()

pt = ThreadCreate(@ThreadCondVar)

MutexLock(mutex0) '' wait for thread launch (mutex unlock from child thread)

Print "Thread synchronization latency by conditional variables:"

t = Timer

For I As Integer = 1 To 100000

   MutexLock(mutex)

   flag1 = 1

   CondSignal(cond1) '' send conditional signal to main thread

   While flag2 = 0

   CondWait(Cond2, mutex) '' wait for conditional signal from child thread

   Wend

   flag2 = 0

   ' only child thread code runs (location for example)

   MutexUnlock(mutex)

Next I

t = Timer - t

ThreadWait(pt)

Print Using "####.## microseconds per double synchronization (round trip)"; t * 10

Print

MutexDestroy(mutex0)

MutexDestroy(mutex)

CondDestroy(cond1)

CondDestroy(cond2)

'----------------------------------------------------------------------------------

Sleep
```

 Example of results:

```freebasic
Thread synchronization latency by simple flags:  
(in high resolution OS cycle period)
   2.02 milliseconds per double synchronization (round trip)

Thread synchronization latency by mutual exclusions:
   5.93 microseconds per double synchronization (round trip)

Thread synchronization latency by conditional variables:
   7.54 microseconds per double synchronization (round trip)
```

Example of thread synchronization for executing in concurrent or exclusive mode by using conditional variable:

```freebasic
Dim Shared As Any Ptr pt, mutex1, mutex2, cond1, cond2

Dim Shared As Integer quit, flag1, flag2

Print "'1': Main thread procedure running (alone)"

Print "'2': Child thread procedure running (alone)"

Print "'-': Main thread procedure running (with the one of child thread)"

Print "'=': Child thread procedure running (with the one of main thread)"

Print

Sub Prnt(ByRef s As String, ByVal n As Integer)

   For I As Integer = 1 To n

   Print s;

   Sleep 20, 1

   Next I

End Sub

Sub ThreadCondCond(ByVal p As Any Ptr)

   Do

   MutexLock(mutex1)

   While flag1 = 0 '' test flag set from main thread

   CondWait(cond1, mutex1) '' wait for conditional signal from main thread

   Wend

   flag1 = 0 '' reset flag

   MutexUnlock(mutex1)

   If quit = 1 Then Exit Sub '' exit the threading loop

   Prnt("=", 10)

   MutexLock(mutex2)

   flag2 = 1 '' set flag to main thread

   CondSignal(cond2) '' send conditional signal to main thread

   Prnt("2", 10)

   MutexUnlock(mutex2)

   Loop

End Sub

mutex1 = MutexCreate()

mutex2 = MutexCreate()

cond1 = CondCreate()

cond2 = CondCreate()

pt = ThreadCreate(@ThreadCondCond)

For I As Integer = 1 To 5

   MutexLock(mutex1)

   flag1 = 1 '' set flag to child thread

   CondSignal(cond1) '' send conditional signal to child thread

   MutexUnlock(mutex1)

   Prnt("-", 10)

   MutexLock(mutex2)

   While flag2 = 0 '' test flag set from child thread

   CondWait(Cond2, mutex2) '' wait for conditional signal from child thread

   Wend

   flag2 = 0 '' reset flag

   Prnt("1", 10)

   MutexUnlock(mutex2)

Next I

MutexLock(mutex1)

quit = 1 '' set quit for child thread

flag1 = 1

CondSignal(cond1) '' send conditional signal to child thread

MutexUnlock(mutex1)

ThreadWait(pt) '' wait for child thread to end

Print

MutexDestroy(mutex1)

MutexDestroy(mutex2)

CondDestroy(cond1)

CondDestroy(cond2)

Sleep
```

 Output:

```freebasic
'1': Main thread procedure running (alone)  
'2': Child thread procedure running (alone)  
'-': Main thread procedure running (with the one of child thread)  
'=': Child thread procedure running (with the one of main thread)

-==-=-=--==--==-=-=-22222222221111111111-=-=-=-==--==-=--==-22222222221111111111-=-=-==-=-=--=-=-==-22222222221111111111
-=-=-=-=-=-=--==-=-=22222222221111111111-==--==--==-=-=--==-22222222221111111111
```

Back to top

14. What happens when multiple threads are waiting on the same condition variable?

- If 'CondSignal()' is used:

The specification states that the thread scheduler arbitrarily notifies one of the threads waiting on the condition variable.
 Since this method notifies an arbitrary thread, some documentation also states that it is therefore possible for a waiting thread to never be notified if it is never alone in the queue on the condition variable.
 But my tests on Windows seem to show that the order of entry into the queue on a same condition variable determines the order of exit: first in, first out.
 I have not tested this on Linux or any other platform, but in any case this behavior I observed is unspecified.

- If 'CondBroadcast()' is used:

The specification states that the thread scheduler notifies all threads waiting on the condition variable in an arbitrary order.

The example below works with 6 threads (in addition to the main thread).
 The first 3 threads (#1 to #3) are waiting on their own condition variable, while the last 3 threads (#4 to #6) are waiting on a same other condition variable.
 These last 3 threads are awakened either on 'CondSignal()' or on 'CondBroadcast()'.

```freebasic
Type ThreadData

   Dim As Integer id

   Dim As Any Ptr mutex

   Dim As Any Ptr cond

   Dim As Boolean flag

   Dim As Boolean quit

   Dim As Any Ptr handle

   Declare Static Sub Thread(ByVal p As Any Ptr)

End Type

Sub ThreadData.Thread(ByVal p As Any Ptr)

   Dim As ThreadData Ptr pdata = p

   Print " thread #" & pdata->id & " is running"

   Do

   MutexLock(pdata->mutex)

   While pdata->flag = False

   CondWait(pdata->cond, pdata->mutex)

   Wend

   pdata->flag = False

   MutexUnlock(pdata->mutex)

   If pdata->quit = False Then

   Print " thread #" & pdata->id & " is signaled"

   Else

   Exit Do

   End If

   Loop

   Print " thread #" & pdata->id & " is finishing"

End Sub

Dim As Any Ptr mutex = MutexCreate()

Dim As Any Ptr cond(0 To 3) = {CondCreate(), CondCreate(), CondCreate(), CondCreate()}

Dim As ThreadData mythreads(1 To 6) = {Type(1, mutex, cond(1)), Type(2, mutex, cond(2)), Type(3, mutex, cond(3)), _

   Type(4, mutex, cond(0)), Type(5, mutex, cond(0)), Type(6, mutex, cond(0))}

Print "Threads from #1 to #6 are created:"

For I As Integer = LBound(mythreads) To UBound(mythreads)

   mythreads(I).handle = ThreadCreate(@ThreadData.Thread, @mythreads(I))

Next I

Sleep 1000, 1 '' wait for all threads started

Print

Print "----------------------------------------------------------"

Print

For I As Integer = 3 To 1 Step -1

   Print "Send a CondSignal to thread #" & I &":"

   MutexLock(mutex)

   mythreads(I).flag = True

   CondSignal(cond(I))

   MutexUnlock(mutex)

   Sleep 1000, 1 '' wait for the thread loop completed

   Print

Next I

Print "----------------------------------------------------------"

Print

Print "Send a single CondBroadcast to all threads from #4 to #6:"

MutexLock(mutex)

   For I As Integer = 4 To 6

   mythreads(I).flag = True

   Next I

   CondBroadcast(cond(0))

MutexUnlock(mutex)

Sleep 1000, 1 '' wait for all thread loops completed

Print "Send a single CondBroadcast to all threads from #4 to #6:"

MutexLock(mutex)

   For I As Integer = 4 To 6

   mythreads(I).flag = True

   Next I

   CondBroadcast(cond(0))

MutexUnlock(mutex)

Sleep 1000, 1 '' wait for all thread loops completed

Print "Send a single CondBroadcast to all threads from #4 to #6:"

MutexLock(mutex)

   For I As Integer = 4 To 6

   mythreads(I).flag = True

   Next I

   CondBroadcast(cond(0))

MutexUnlock(mutex)

Sleep 1000, 1 '' wait for all thread loops completed

Print

Print "----------------------------------------------------------"

Print

Print "Send a CondSignal to any thread among #4 to #6:"

MutexLock(mutex)

   For I As Integer = 4 To 6

   mythreads(I).flag = True

   Next I

   CondSignal(cond(0))

MutexUnlock(mutex)

Sleep 1000, 1 '' wait for a thread loop completed

Print "Send a CondSignal to any thread among #4 to #6:"

MutexLock(mutex)

   For I As Integer = 4 To 6

   mythreads(I).flag = True

   Next I

   CondSignal(cond(0))

MutexUnlock(mutex)

Sleep 1000, 1 '' wait for a thread loop completed

Print "Send a CondSignal to any thread among #4 to #6:"

MutexLock(mutex)

   For I As Integer = 4 To 6

   mythreads(I).flag = True

   Next I

   CondSignal(cond(0))

MutexUnlock(mutex)

Sleep 1000, 1 '' wait for a thread loop completed

Print

Print "Send a CondSignal to any thread among #4 to #6:"

MutexLock(mutex)

   For I As Integer = 4 To 6

   mythreads(I).flag = True

   Next I

   CondSignal(cond(0))

MutexUnlock(mutex)

Sleep 1000, 1 '' wait for a thread loop completed

Print "Send a CondSignal to any thread among #4 to #6:"

MutexLock(mutex)

   For I As Integer = 4 To 6

   mythreads(I).flag = True

   Next I

   CondSignal(cond(0))

MutexUnlock(mutex)

Sleep 1000, 1 '' wait for a thread loop completed

Print "Send a CondSignal to any thread among #4 to #6:"

MutexLock(mutex)

   For I As Integer = 4 To 6

   mythreads(I).flag = True

   Next I

   CondSignal(cond(0))

MutexUnlock(mutex)

Sleep 1000, 1 '' wait for a thread loop completed

Print

Print "Send a CondSignal to any thread among #4 to #6:"

MutexLock(mutex)

   For I As Integer = 4 To 6

   mythreads(I).flag = True

   Next I

   CondSignal(cond(0))

MutexUnlock(mutex)

Sleep 1000, 1 '' wait for a thread loop completed

Print "Send a CondSignal to any thread among #4 to #6:"

MutexLock(mutex)

   For I As Integer = 4 To 6

   mythreads(I).flag = True

   Next I

   CondSignal(cond(0))

MutexUnlock(mutex)

Sleep 1000, 1 '' wait for a thread loop completed

Print "Send a CondSignal to any thread among #4 to #6:"

MutexLock(mutex)

   For I As Integer = 4 To 6

   mythreads(I).flag = True

   Next I

   CondSignal(cond(0))

MutexUnlock(mutex)

Sleep 1000, 1 '' wait for a thread loop completed

Print

Print "----------------------------------------------------------"

Print

For I As Integer = 1 To 3

   Print "Send to finish a CondSignal to thread #" & I &":"

   MutexLock(mutex)

   mythreads(I).flag = True

   mythreads(I).quit = True

   CondSignal(cond(I))

   MutexUnlock(mutex)

   Sleep 1000, 1 '' wait for the thread loop completed

   Print

Next I

Print "----------------------------------------------------------"

Print

Print "Send to finish a single CondBroadcast to all threads from #4 to #6:"

MutexLock(mutex)

   For I As Integer = 4 To 6

   mythreads(I).flag = True

   mythreads(I).quit = True

   Next I

   CondBroadcast(cond(0))

MutexUnlock(mutex)

Sleep 1000, 1 '' wait for all thread loops completed

Print

Print "----------------------------------------------------------"

Print

For I As Integer = 1 To 3

   ThreadWait(mythreads(I).handle)

   CondDestroy(cond(I))

Next I

For I As Integer = 4 To 6

   ThreadWait(mythreads(I).handle)

Next I

Print "All threads from #1 to #6 are finished."

Print

MutexDestroy(mutex)

CondDestroy(cond(0))

Sleep
```

 Output (for example):

```freebasic
Threads from #1 to #6 are created:  
   thread #1 is running  
   thread #3 is running  
   thread #2 is running  
   thread #5 is running  
   thread #4 is running  
   thread #6 is running

----------------------------------------------------------

Send a CondSignal to thread #3:  
   thread #3 is signaled

Send a CondSignal to thread #2:  
   thread #2 is signaled

Send a CondSignal to thread #1:  
   thread #1 is signaled

----------------------------------------------------------

Send a single CondBroadcast to all threads from #4 to #6:  
   thread #5 is signaled  
   thread #6 is signaled  
   thread #4 is signaled  
Send a single CondBroadcast to all threads from #4 to #6:  
   thread #6 is signaled  
   thread #4 is signaled  
   thread #5 is signaled  
Send a single CondBroadcast to all threads from #4 to #6:  
   thread #5 is signaled  
   thread #4 is signaled  
   thread #6 is signaled

----------------------------------------------------------

Send a CondSignal to any thread among #4 to #6:  
   thread #5 is signaled  
Send a CondSignal to any thread among #4 to #6:  
   thread #4 is signaled  
Send a CondSignal to any thread among #4 to #6:  
   thread #6 is signaled

Send a CondSignal to any thread among #4 to #6:  
   thread #5 is signaled  
Send a CondSignal to any thread among #4 to #6:  
   thread #4 is signaled  
Send a CondSignal to any thread among #4 to #6:  
   thread #6 is signaled

Send a CondSignal to any thread among #4 to #6:  
   thread #5 is signaled  
Send a CondSignal to any thread among #4 to #6:  
   thread #4 is signaled  
Send a CondSignal to any thread among #4 to #6:  
   thread #6 is signaled

----------------------------------------------------------

Send to finish a CondSignal to thread #1:  
   thread #1 is finishing

Send to finish a CondSignal to thread #2:  
   thread #2 is finishing

Send to finish a CondSignal to thread #3:  
   thread #3 is finishing

----------------------------------------------------------

Send to finish a single CondBroadcast to all threads from #4 to #6:  
   thread #4 is finishing  
   thread #5 is finishing  
   thread #6 is finishing

----------------------------------------------------------

All threads from #1 to #6 are finished.
```

Back to top

15. How to optimize sequencing of successive user tasks executed by threading?

The delay between the return of 'ThreadCreate()' and the start of the thread code (first line of thread code) can be estimated at about 50 microseconds on average, but can go up to a few milliseconds at worst.
 (see FAQ 12. What is the execution delay of the code of a thread after the thread is created by 'ThreadCreate'?)

 This is why a child thread can be launched only once (by a constructor for example) and execute a permanent waiting loop of user tasks (to avoid a thread launch latency each time), then at end stopped (by a destructor).
 The synchronization between the main thread and the child thread (start of each user task and user task completed) can be managed by means of 2 mutexes.

 Example to estimate the average time to execute a sequence of user tasks (with empty user procedure body):

**-** either launched by successive threads,
 **-** or launched by a single thread.

```freebasic
Sub userTask(ByVal p As Any Ptr) '' task to execute

End Sub

Dim As Double t

'---------------------------------------------------------------------------

Print "Successive (empty) user tasks executed by one thread for each:"

t = Timer

For i As Integer = 1 To 10000

   Dim As Any Ptr p = ThreadCreate(@userTask)

   ThreadWait(p)

Next i

t = Timer - t

Print Using "######.### microdeconds per user task"; t * 100

Print

'---------------------------------------------------------------------------

Type thread

   Public:

   Dim As Sub(ByVal p As Any Ptr) task '' pointer to user task

   Declare Sub Launch() '' launch user task

   Declare Sub Wait() '' wait for user task completed

   Declare Constructor()

   Declare Destructor()

   Private:

   Dim As Any Ptr mutex1

   Dim As Any Ptr mutex2

   Dim As Any Ptr handle

   Dim As Boolean quit

   Declare Static Sub proc(ByVal pthread As thread Ptr)

End Type

Constructor thread()

   This.mutex1 = MutexCreate

   This.mutex2 = MutexCreate

   MutexLock(This.mutex1)

   MutexLock(This.mutex2)

   This.handle = ThreadCreate(CPtr(Any Ptr, @thread.proc), @This)

End Constructor

Destructor thread()

   This.quit = True

   MutexUnlock(This.mutex1)

   ThreadWait(This.handle)

   MutexDestroy(This.mutex1)

   MutexDestroy(This.mutex2)

End Destructor

Sub thread.proc(ByVal pthread As thread Ptr)

   Do

   MutexLock(pthread->mutex1) '' wait for launching task

   If pthread->quit = True Then Exit Sub

   pthread->task(pthread)

   MutexUnlock(pthread->mutex2) '' task completed

   Loop

End Sub

Sub thread.Launch()

   MutexUnlock(This.mutex1)

End Sub

Sub thread.Wait()

   MutexLock(This.mutex2)

End Sub

Print "Successive (empty) user tasks executed by a single thread for all:"

t = Timer

Dim As thread Ptr pThread = New Thread

pThread->task = @userTask

For i As Integer = 1 To 10000

   pThread->Launch()

   pThread->Wait()

Next i

Delete pThread

t = Timer - t

Print Using "######.### microdeconds per user task"; t * 100

Print

Sleep
```

 Output (for example):

```freebasic
Successive (empty) user tasks executed by one thread for each:
   145.004 microdeconds per user task

Successive (empty) user tasks executed by a single thread for all:
6.691 microdeconds per user task
```

Back to top

16. Why is multi-threading performance penalized by many shared memory accesses (even more in writing mode)?

Each core has its own cache memory that allows to buffer the useful data (in read and write) of the shared memory.
 Consequently, a cache coherence algorithm between cores is executed, to keep, in case of writing in the cache and for the common memory areas between caches, the most recent values ​​among all the caches concerned.
 It is this algorithm which penalizes the performance of multi-threading in the case of multiple accesses in shared memory, even more particularly in write mode.

 It is therefore necessary to limit as much as possible the access of threads to shared memory, even more in writing.
 For example, all intermediate results of threads could be performed in local memory, and only the final useful ones put in shared memory.

 Example of a member thread procedures computing the sum of the first N integers, by accumulation directly in the shared memory ('SumUpTo_1()') or internally in its local memory before copy back ('SumUpTo_2'()'):

```freebasic
Type Thread

   Dim As UInteger valueIN

   Dim As Double valueOUT

   Dim As Any Ptr pHandle

   Declare Static Sub SumUpTo_1(ByVal pt As Thread Ptr)

   Declare Static Sub SumUpTo_2(ByVal pt As Thread Ptr)

End Type

Sub Thread.SumUpTo_1(ByVal pt As Thread Ptr)

   pt->valueOut = 0

   For I As UInteger = 1 To pt->valueIN

   pt->valueOUT += I

   Next I

End Sub

Sub Thread.SumUpTo_2(ByVal pt As Thread Ptr)

   Dim As Double value = 0

   For I As UInteger = 1 To pt->valueIN

   value += I

   Next I

   pt->valueOUT = value

End Sub

Sub MyThreads(ByVal pThread As Any Ptr, ByVal threadNB As UInteger = 1)

   Dim As Thread td(1 To threadNB)

   Dim As Double t

   t = Timer

   For i As Integer = 1 To threadNB

   td(i).valueIN = 100000000 + i

   td(i).pHandle = ThreadCreate(pThread, @td(i))

   Next I

   For i As Integer = 1 To threadNB

   ThreadWait(td(i).pHandle)

   Next I

   t = Timer - t

   For i As Integer = 1 To threadNB

   Print " SumUpTo(" & td(i).valueIN & ") = " & td(i).valueOUT, _

   "(right result : " & (100000000# + i) * (100000000# + i + 1) / 2 & ")"

   Next I

   Print " total time : " & t & " s"

   Print

End Sub

Print

For i As Integer = 1 To 4

   Print "Each thread (in parallel) accumulating result directly in shared memory:"

   Mythreads(@Thread.SumUpTo_1, I)

   Print "Each thread (in parallel) accumulating result internally in its local memory:"

   Mythreads(@Thread.SumUpTo_2, I)

   Print "-----------------------------------------------------------------------------"

   Print

Next i

Sleep
```

 Output (for example):

```freebasic
Each thread (in parallel) accumulating result directly in shared memory:  
   SumUpTo(100000001) = 5000000150000001 (right result : 5000000150000001)  
total time : 1.668927300015184 s

Each thread (in parallel) accumulating result internally in its local memory:  
   SumUpTo(100000001) = 5000000150000001 (right result : 5000000150000001)  
total time : 1.004467599958389 s

-----------------------------------------------------------------------------

Each thread (in parallel) accumulating result directly in shared memory:  
   SumUpTo(100000001) = 5000000150000001 (right result : 5000000150000001)  
   SumUpTo(100000002) = 5000000250000003 (right result : 5000000250000003)  
total time : 4.314032700025791 s

Each thread (in parallel) accumulating result internally in its local memory:  
   SumUpTo(100000001) = 5000000150000001 (right result : 5000000150000001)  
   SumUpTo(100000002) = 5000000250000003 (right result : 5000000250000003)  
total time : 1.032165899962706 s

-----------------------------------------------------------------------------

Each thread (in parallel) accumulating result directly in shared memory:  
   SumUpTo(100000001) = 5000000150000001 (right result : 5000000150000001)  
   SumUpTo(100000002) = 5000000250000003 (right result : 5000000250000003)  
   SumUpTo(100000003) = 5000000350000006 (right result : 5000000350000006)  
total time : 6.727616399944395 s

Each thread (in parallel) accumulating result internally in its local memory:  
   SumUpTo(100000001) = 5000000150000001 (right result : 5000000150000001)  
   SumUpTo(100000002) = 5000000250000003 (right result : 5000000250000003)  
   SumUpTo(100000003) = 5000000350000006 (right result : 5000000350000006)  
total time : 1.128656100041894 s

-----------------------------------------------------------------------------

Each thread (in parallel) accumulating result directly in shared memory:  
   SumUpTo(100000001) = 5000000150000001 (right result : 5000000150000001)  
   SumUpTo(100000002) = 5000000250000003 (right result : 5000000250000003)  
   SumUpTo(100000003) = 5000000350000006 (right result : 5000000350000006)  
   SumUpTo(100000004) = 5000000450000010 (right result : 5000000450000010)  
total time : 6.829728199980309 s

Each thread (in parallel) accumulating result internally in its local memory:  
   SumUpTo(100000001) = 5000000150000001 (right result : 5000000150000001)  
   SumUpTo(100000002) = 5000000250000003 (right result : 5000000250000003)  
   SumUpTo(100000003) = 5000000350000006 (right result : 5000000350000006)  
   SumUpTo(100000004) = 5000000450000010 (right result : 5000000450000010)  
total time : 1.164915200012842 s

-----------------------------------------------------------------------------
```

One can check that the multi-threading performance is strongly penalized by many shared memory accesses in write mode:

For the case where the thread accumulates the result in shared memory, there is no longer any gain from multi-threading (and even a little loss), whereas for the case where the thread accumulates the result in internal memory, the gain is almost at the theoretical maximum value.

On the other hand, we observe a smaller degradation in multi-threading performance when accessing shared memory in read-only mode.

Back to top

17. Why is multi-threading performance heavily penalized by many manipulation of var-len strings and var-len arrays?

For all pseudo-objects like var-len strings and var-len arrays, only the descriptors can be put into local memory but not the data itself which is always on the heap (only fixed-length data can be put into local memory).
 The heap is shared memory and this incurs penality on multi-threading performance as described in the above FAQ.
 (see FAQ 16. Why is multi-threading performance penalized by many shared memory accesses (even more in writing mode)?)

 For var-len arrays, local fixed-len arrays can be used instead, since this array data is always placed in local scope memory.
 Not only do you have to define a fixed maximum size to allocate for each array, but for each of them you have to associate an index variable (per dimension if necessary) that points to the last useful element ('Redim' is replaced by updating this index variable).

 For var-len strings, local fix-len \[z\]strings can be used instead, since these \[z\]string data are always placed in local scope memory.
 All built-in string functions except 'Len()' and 'Asc()' and all string operators should also not be used on \[z\]strings since they work internally with var-len strings. Instead, use user code that only works on \[z\]string indexes.
 *Note:*

But fix-len strings ('Dim As String \* N') are less convenient to use than fix-len zstrings ('Dim As Zstring \* N'), because the former cannot be passed by reference to a procedure (but only by copy), unlike the latter ('Byref As Zstring').

Additionally, all dynamic memory allocation/reallocation/deallocation requests (to be thread-safe) are serialized internally using mutex locking and unlocking.

 The following example compares the multithreaded performance of two types of code:

**-** code with var-len strings using its built-in functions and operators like '= (assign)', 'Instr()', 'Mid()' and 'Ucase()',
 **-** code with fix-len zstrings with user code equivalent to the previous built-in functions and operators, but operating only on zstring indexes.

("Asc()" and "Len()" are the only ones used because they have no impact on performance)

```freebasic
Type Thread

   Dim As UInteger value

   Dim As Any Ptr pHandle

   Declare Static Sub thread1(ByVal pt As Thread Ptr)

   Declare Static Sub thread2(ByVal pt As Thread Ptr)

End Type

Sub Thread.thread1(ByVal pt As Thread Ptr)

   Dim As Integer result

   For n As Integer = 1 To pt->value

   Dim As String s1

   Dim As String s2

   Dim As String s3

   s1 = "FreeBASIC rev 1.20"

   result = InStr(s1, "rev")

   s2 = Mid(s1, result)

   s3 = UCase(s2)

   Next n

End Sub

Sub Thread.thread2(ByVal pt As Thread Ptr)

   Dim As Integer result

   For n As Integer = 1 To pt->value

   Dim As ZString * 256 z1

   Dim As ZString * 256 z2

   Dim As ZString * 256 z3

   ' instead of: z1 = "FreeBASIC rev 1.20"

   For i As Integer = 0 To Len("FreeBASIC rev 1.20")

   z1[i] = ("FreeBASIC rev 1.20")[i]

   Next i

   ' instead of: result = Instr(z1, "rev")

   result = 0

   For i As Integer = 0 To Len(z1) - Len("rev")

   For j As Integer = 0 To Len("rev") - 1

   If z1[i + j] <> ("rev")[j] Then Continue For, For

   Next j

   result = i + 1

   Exit For

   Next i

   ' instead of: z2 = Mid(z1, result)

   For i As Integer = result - 1 To Len(z1)

   z2[i - result + 1] = z1[i]

   Next i

   ' instead of: z3 = Ucase(z2)

   For i As Integer = 0 To Len(z2)

   z3[i] = z2[i]

   If z3[i] >= Asc("a") AndAlso z3[i] <= Asc("z") Then z3[i] -= 32

   Next i

   Next n

End Sub

Sub MyThreads(ByVal pThread As Any Ptr, ByVal threadNB As UInteger = 1)

   Dim As Thread td(1 To threadNB)

   Dim As Double t

   t = Timer

   For i As Integer = 1 To threadNB

   td(i).value = 100000

   td(i).pHandle = ThreadCreate(pThread, @td(i))

   Next I

   For i As Integer = 1 To threadNB

   ThreadWait(td(i).pHandle)

   Next I

   t = Timer - t

   Print " total time for " & threadNB & " threads in parallel: " & t & " s"

   Print

End Sub

Print

For i As Integer = 1 To 8

   Print "Each thread using var-len strings, with its built-in functions and operators:"

   Mythreads(@Thread.thread1, I)

   Print "Each thread using fix-len zstrings, with user code working on zstring indexes:"

   Mythreads(@Thread.thread2, I)

   Print "------------------------------------------------------------------------------"

   Print

Next i

Sleep
```

 Output (for example):

```freebasic
Each thread using var-len strings, with its built-in functions and operators:  
total time for 1 threads in parallel: 0.08449090004432946 s

Each thread using fix-len zstrings, with user code working on zstring indexes:  
total time for 1 threads in parallel: 0.02201449999120086 s

------------------------------------------------------------------------------

Each thread using var-len strings, with its built-in functions and operators:  
total time for 2 threads in parallel: 0.1947050000308082 s

Each thread using fix-len zstrings, with user code working on zstring indexes:  
total time for 2 threads in parallel: 0.02090729994233698 s

------------------------------------------------------------------------------

Each thread using var-len strings, with its built-in functions and operators:  
total time for 3 threads in parallel: 0.3338784999214113 s

Each thread using fix-len zstrings, with user code working on zstring indexes:  
total time for 3 threads in parallel: 0.0279372000368312 s

------------------------------------------------------------------------------

Each thread using var-len strings, with its built-in functions and operators:  
total time for 4 threads in parallel: 0.4927077000029385 s

Each thread using fix-len zstrings, with user code working on zstring indexes:  
total time for 4 threads in parallel: 0.02361949998885393 s

------------------------------------------------------------------------------

Each thread using var-len strings, with its built-in functions and operators:  
total time for 5 threads in parallel: 0.7089884000597522 s

Each thread using fix-len zstrings, with user code working on zstring indexes:  
total time for 5 threads in parallel: 0.02638950000982732 s

------------------------------------------------------------------------------

Each thread using var-len strings, with its built-in functions and operators:  
total time for 6 threads in parallel: 0.9172402999829501 s

Each thread using fix-len zstrings, with user code working on zstring indexes:  
total time for 6 threads in parallel: 0.0310587000567466 s

------------------------------------------------------------------------------

Each thread using var-len strings, with its built-in functions and operators:  
total time for 7 threads in parallel: 1.159198799985461 s

Each thread using fix-len zstrings, with user code working on zstring indexes:  
total time for 7 threads in parallel: 0.02898070006631315 s

------------------------------------------------------------------------------

Each thread using var-len strings, with its built-in functions and operators:  
total time for 8 threads in parallel: 1.403980100061744 s

Each thread using fix-len zstrings, with user code working on zstring indexes:  
total time for 8 threads in parallel: 0.03312029992230237 s

------------------------------------------------------------------------------
```

One can check that the multi-threading performance is strongly penalized by many var-len string manipulation:

For the case where the thread uses var-len strings and its built-in functions and operators, there is no longer any gain from multi-threading (and even losses), whereas for the case where the thread uses fix-len zstrings and user code working on zstring indexes only (except 'Asc()' and 'Len()' usage), the gain is almost at the theoretical maximum value.

Back to top

See also

- [Multi-Threading Overview](Multi-Threading)
  [Threads](Threads)
  [Mutual Exclusion](Mutual-Exclusion)
  [Conditional Variables](Conditional-Variables)
  [Critical Sections](Critical-Sections)
  [Emulate a TLS (Thread Local Storage) and a TP (Thread Pooling) feature](Emulate-a-Tls-Thread-Local-Storage-and-a-Tp-Thread-Pooling-Feature)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
