[Home](Home) › [Tutorials](Category-Tutorials) › **Replace Recursion with Iteration**

# Replace Recursion with Iteration

How to **replace** any **recursion** with simple **iteration**, or unlimited **iteration** with its own stack.

 **Preamble:**

 Iteration and recursion are two very useful ways to program, especially to perform a certain number of times a certain script, and thus allow optimization of the code. If iteration is relatively easy to understand, recursion is a concept not necessarily obvious at the beginning.  
 When speaking of a recursive procedure (subroutine or function), we refer to a syntactic characteristic: the procedure, in its own definition, refers to itself (it calls itself).  
 But when talking about recursive process, linear or tree, we are interested in the process flow, not in the syntax of the procedure's writing.  
 Thus, a procedure can have a recursive definition but correspond to an iterative process.

 Some treatments are naturally implemented as a recursive algorithm (although this is not always the most optimal solution).  
 The main problem of the recursive approach is that it consumes potentially a lot of space on the execution stack: from a certain level of "depth" of recursion, the space allocated for the execution stack of the thread is exhausted, and causes an error of type "stack overflow".  
 Repeatedly calling the same procedure can also make the execution slower, although this may make the code easier.  
 To increase the speed of execution, simple recursive algorithms can be recreated in little more complicated iterative algorithms using loops that execute much faster.

 What is the use of recursion if it increases the execution time and memory space compared to an iterative solution?  
 There are still cases where it is not possible to do otherwise, where iterative translation does not exist or, where it exists, is much heavier to implement (requiring for example a dynamic storage capacity to substitute for the execution stack).

 *Table of Contents*

**1. Recursion and iteration definition**
 **2. Problem of replacing recursion with iteration**
 **3. Replace tail recursion with simple iteration**
 **4. Replace non-tail recursion with more complex iteration**

1. Recursion and iteration definition

Recursion and iteration both repeatedly execute the instruction set:

**-** Recursion occurs when an instruction in a procedure calls the procedure itself repeatedly.
 **-** Iteration occurs when a loop executes repeatedly until the control condition becomes false.

The main difference between recursion and iteration is that recursion is a process always applied to a procedure, while iteration is applied to a set of instructions to execute repeatedly.

 *Definition of Recursion*

FreeBASIC allows a procedure to call itself in its code. This means that the procedure definition has a procedure call to itself.  
 The set of local variables and parameters used by the procedure are newly created each time the procedure is called and are stored at the top of the execution stack.  
 But every time a procedure calls itself, it does not create a new copy of that procedure.  
 The recursive procedure does not significantly reduce the size of the code and does not even improve the memory usage, but it does a little bit compared to iteration.

 To end recursion, a condition must be tested to force the return of the procedure without giving a recursive call to itself.  
 The absence of a test of a condition in the definition of a recursive procedure would leave the procedure in infinite recursion once called.

 **Note:** When the parameters of a recursive procedure are passed by reference, take care to work with local variables when the code body needs to modify their values.

 Simple example with a recursive function which returns the factorial of the integer:

The code body of the recursive function is defined by using the recursive definition of the factorial function:

**`Case (n = 0) : factorial(0) = 1`**
 **`Case (n > 0) : factorial(n) = n * factorial(n-1)`**

The first line allows to determine the end condition: `If (n = 0) Then Return 1`  
 The second line allows to determine the statement syntax which calls the function itself: `Return n * factorial(n - 1)`

 Full code:

```freebasic
Function recursiveFactorial (ByVal n As Integer) As Integer

    If (n = 0) Then                           '' end condition

        Return 1

    Else                                      '' recursion loop

        Return n * recursiveFactorial(n - 1)  '' recursive call

    End If

End Function
```

*Definition of Iteration*

Iteration is a process of repeatedly executing a set of instructions until the iteration condition becomes false.  
 The iteration block includes the initialization, the comparison, the execution of the instructions to be iterated and finally the update of the control variable.  
 Once the control variable is updated, it is compared again and the process is repeated until the condition in the iteration is false.  
 Iteration blocks are "for" loop, "while" loop, ...

 The iteration block does not use the execution stack to store the variables at each cycle. Therefore, the execution of the iteration block is faster than the recursion block.  
 In addition, iteration does not have the overhead of repeated procedure calls that also make its execution faster than a recursion.  
 The iteration is complete when the control condition becomes false.

 Simple example with a iterative function which returns the factorial of the integer:

The code body of the iterative function is defined by using the iterative definition of the factorial function:

**`Case (n = 0) : factorial(0) = 1`**
 **`Case (n > 0) : factorial(n) = (1) * ..... * (n - 2) * (n - 1) * (n)`**

The first line allows to determine the cumulative variable initialization: `result = 1`  
 The second line allows to determine the statement syntax which accumulates: `result = result * I`

 Full code:

```freebasic
Function iterativeFactorial (ByVal n As Integer) As Integer

    Dim As Integer result = 1  '' variable initialization

    For I As Integer = 1 To n  '' iteration loop

        result = result * I    '' iterative accumulation

    Next I

    Return result

End Function
```

Back to top

2. Problem of replacing recursion with iteration

Whatever the problem to be solved, there is the choice between the writing of an iterative procedure and that of a recursive procedure.  
 If the problem has a natural recursive structure, then the recursive program is a simple adaptation of the chosen structure. This is the case of the factorial functions (seen above) for example.  
 The recursive approach, however, has drawbacks: some languages ​​do not allow recursion (like the machine language!), and a recursive procedure is often expensive in memory (for execution stack) as in execution time.

 These disadvantages can be overcome by transforming the recursive procedure, line by line, into an iterative procedure: it is always possible.  
 Replace a recursion with an iteration allows to suppress the limitation on the number of cycles due to the execution stack size available.  
 But for an iteration with its own storage stack, the time spent to calls to the procedures for pushing and pulling stack data is generally greater than the one for passing the parameters of a recursive procedure at each calling cycle.

 The complexity of the iterative procedure obtained by such a transformation depends on the structure of the recursive procedure:

**-** For some form of recursive procedure (see below the tail recursion), the transformation into an iterative procedure is very simple by means of just defining local variables corresponding to the parameters of the recursive procedure (passed arguments).
 **-** At opposite for other forms of recursive procedure (non-tail recursions), the use of a user storage stack in the iterative procedure is necessary to save the context, as the recursive calls do (values ​​of the passed arguments at each call):

- when executing a recursive procedure, each recursive call leads to push the context on execution stack,
 - when the condition of stopping recursion occurs, the different contexts are progressively popped from execution stack to continue executing the procedure.

Back to top

3. Replace tail recursion with simple iteration

The recursive procedure is a tail recursive procedure if the only recursive call is at the end of the recursion and is therefore not followed by any other statement:

**-** For a recursive subroutine, the only recursive call is at the end of the recursion.
 **-** For a recursive function, the only recursive call is at the end of the recursion and consists in taking into account the return of the function without any other additional operation on it.

A tail recursive procedure is easy to transform into an iterative procedure.  
 The principle is that if the recursive call is the last instruction of a procedure, it is not necessary to keep on the execution stack the context of the current call, since it is not necessary to return to it:

**-** It suffices to replace the parameters by their new values, and resume execution at the beginning of the procedure.
 **-** The recursion is thus transformed into iteration, so that there is no longer any risk of causing an overflow of the execution stack.

Some non-tail recursive procedures can be transformed into tail recursive procedures, sometimes with a little more complex code, but even before they are subsequently transformed into iterative procedures, these tail recursive procedures often already gain in memory usage and execution time.

 Example with the simple "factorial" recursive function:

Non-tail recursive form (already presented above):

```freebasic
Function recursiveFactorial (ByVal n As Integer) As Integer

    If (n = 0) Then                           '' end condition

        Return 1

    Else                                      '' recursion loop

        Return n * recursiveFactorial(n - 1)  '' recursive call

    End If

End Function
```

 This function has a non-tail recursive form because even though the recursive call is at the end of the function, this recursive call is not the last instruction of the function because one has to multiplied again by `n` when `recursiveFactorial(n - 1)` is got.  
 This calculation is done when popping context from execution stack.

It is quite easy to transform this function so that the recursion is a tail recursion.  
 To achieve this, it is necessary to add a new parameter to the function: the `result` parameter which will serve as accumulator:

```freebasic
Function tailRecursiveFactorial (ByVal n As Integer, ByVal result As Integer = 1) As Integer

    If (n = 0) Then                                       '' end condition

        Return result

    Else                                                  '' recursion loop

        Return tailRecursiveFactorial(n - 1, result * n)  '' tail recursive call

    End If

End Function
```

 This time, the calculation is done when pushing context on execution stack.

Tail recursion is more explicit by calculating `n - 1` and `result * n` just before the recursive call:

```freebasic
Function explicitTailRecursiveFactorial (ByVal n As Integer, ByVal result As Integer = 1) As Integer

    If (n = 0) Then                                       '' end condition

        Return result

    Else                                                  '' recursion loop

        result = result * n

        n = n - 1

        Return explicitTailRecursiveFactorial(n, result)  '' tail recursive call

    End If

End Function
```

Now it is sufficient to resume execution at the beginning of the procedure by a `Goto begin` instead of the function call, to obtain an iterative function:

```freebasic
Function translationToIterativeFactorial (ByVal n As Integer, ByVal result As Integer = 1) As Integer

    begin:

    If (n = 0) Then          '' end condition

        Return result

    Else                     '' iteration loop

        result = result * n  '' iterative accumulation

        n = n - 1

        Goto begin           '' iterative jump

    End If

End Function
```

Finally it is better to avoid the `If ... Goto ... End If` instructions by using for example a `While ... Wend` block instead, and the added `result` parameter can be transformed into a local variable:

```freebasic
Function  betterTranslationToIterativeFactorial (ByVal n As Integer) As Integer

    Dim As Integer result = 1

    While Not (n = 0)        '' end condition of iterative loop

        result = result * n  '' iterative accumulation

        n = n - 1

    Wend

    Return result

End Function
```

Similar transformation steps for the simple "reverse string" recursive function following:

```freebasic
Function recursiveReverse (ByVal s As String) As String

    If (s = "") Then                                     '' end condition

        Return s

    Else                                                 '' recursion loop

        Return recursiveReverse(Mid(s, 2)) & Left(s, 1)  '' recursive call

    End If

End Function
```

```freebasic
Function tailRecursiveReverse (ByVal s As String, ByVal cumul As String = "") As String

    If (s = "") Then                                                '' end condition

        Return cumul

    Else                                                            '' recursion loop

        Return tailRecursiveReverse(Mid(s, 2), Left(s, 1) & cumul)  '' tail recursive call

    End If

End Function
```

 Note: As the `&` operator (string concatenation) is not a symmetric operator `((a & b) <> (b & a)`, while `(x * y) = (y * x)` like previously), the two operand order must to be reversed when pushing context on execution stack instead of before when popping context from execution stack.

```freebasic
Function explicitTailRecursiveReverse (ByVal s As String, ByVal cumul As String = "") As String

    If (s = "") Then                                   '' end condition

        Return cumul

    Else                                               '' recursion loop

        cumul = Left(s, 1) & cumul

        s = Mid(s, 2)

        Return explicitTailRecursiveReverse(s, cumul)  '' tail recursive call

    End If

End Function
```

```freebasic
Function translationToIterativeReverse (ByVal s As String, ByVal cumul As String = "") As String

    begin:

    If (s = "") Then                '' end condition

        Return cumul

    Else                            '' iteration loop

        cumul = Left(s, 1) & cumul  '' iterative accumulation

        s = Mid(s, 2)

        Goto begin                  '' iterative jump

    End If

End Function
```

```freebasic
Function betterTranslationToIterativeReverse (ByVal s As String) As String

    Dim As String cumul = ""

    While Not (s = "")              '' end condition of iterative loop

        cumul = Left(s, 1) & cumul  '' iterative accumulation

        s = Mid(s, 2)

    Wend

    Return cumul

End Function
```

As less simple example, the "Fibonacci series" non-tail recursive function:

Sometimes, the transformation to a tail recursive function is less obvious.  
 The code body of the recursive function is defined by using the recursive definition of the Fibonacci series:

**`Case (n = 0) : F(0) = 0`**
 **`Case (n = 1) : F(1) = 1`**
 **`Case (n > 1) : F(n) = F(n-1) + F(n-2)`**

The first two lines allow to determine the end condition: `If n = 0 Or n = 1 Then Return n`  
 The third line allows to determine the statement syntax which calls the function itself: `Return F(n - 1) + F(n - 2)`

 Non-tail recursive form code:

```freebasic
Function recursiveFibonacci (ByVal n As UInteger) As LongInt

    If n = 0 Or n = 1 Then                                            '' end condition

        Return n

    Else                                                              '' recursion loop

        Return recursiveFibonacci(n - 1) + recursiveFibonacci(n - 2)  '' recursive call

    End If

End Function
```

The execution time duration for the highest values becomes no more negligible.  
 Indeed, to compute F(n), there are 2^(n-1) calls: about one milliard for n=31.

 Try to make the recursive algorithm linear, using a recursive function which have 2 other parameters corresponding to the previous value and the last value of the series, let f(n, a, b).  
 We obtain:

**`Case (n = 1): a = F(0) = 0, b = F(1) = 1`**
 **`Case (n-1): a = F(n-2), b = F(n-1)`**
 **`Case (n): F(n-1) = b, F(n) = F(n-1) + F(n-2) = a + b`**

Consequently, for this new function f(n, a, b), the recursive call becomes f(n-1, b, a+b), and there are only (n-1) calls.

 Tail recursive form code:

```freebasic
Function tailRecursiveFibonacci (ByVal n As UInteger, ByVal a As UInteger = 0, ByVal b As UInteger = 1) As LongInt

    If n <= 1 Then                                      '' end condition

        Return b * n

    Else                                                '' recursion loop

        Return tailRecursiveFibonacci(n - 1, b, a + b)  '' tail recursive call

    End If

End Function
```

Then, similar transformations as previously in order to obtain the iterative form:

```freebasic
Function explicitTailRecursiveFibonacci (ByVal n As UInteger, ByVal a As UInteger = 0, ByVal b As UInteger = 1) As LongInt

    If n <= 1 Then                                      '' end condition

        Return b * n

    Else                                                '' recursion loop

        n = n - 1

        Swap a, b

        b = b + a

        Return explicitTailRecursiveFibonacci(n, a, b)  '' tail recursive call

    End If

End Function
```

```freebasic
Function translationToIterativeFibonacci (ByVal n As UInteger, ByVal a As UInteger = 0, ByVal b As UInteger = 1) As LongInt

    begin:

    If n <= 1 Then    '' end condition

        Return b * n

    Else              '' iteration loopp

        n = n - 1

        Swap a, b

        b = b + a

        Goto begin    '' iterative jump

    End If

End Function
```

```freebasic
Function betterTranslationToIterativeFibonacci (ByVal n As UInteger) As LongInt

    Dim As UInteger a = 0, b = 1

    While Not (n <= 1)  '' end condition of iterative loop

        n = n - 1

        Swap a, b

        b = b + a

    Wend

    Return b * n

End Function
```

Back to top

4. Replace non-tail recursion with more complex iteration

The recursive procedure is a non-tail recursive procedure if there is at least one recursive call followed by at least one instruction.  
 A non-tail recursion cannot be normally transformed into a simple iteration, or it could have been transformed already into tail recursion.

 To avoid limitation due to the execution stack size, a non-tail recursive algorithm can always (more or less easily) be replaced by an iterative algorithm, by pushing the parameters that would normally be passed to the recursive procedure onto an own storage stack.  
 In fact, the execution stack is replaced by a user stack (less limited in size).

 In the following examples, the below user stack macro (compatible with any datatype) is used:

```freebasic
'' save as file: "DynamicUserStackTypeCreateMacro.bi"

#macro DynamicUserStackTypeCreate(typename, datatype)

    Type typename

        Public:

            Declare Constructor ()                       '' pre-allocating user stack memory

            Declare Property push (ByRef i As datatype)  '' pushing on the user stack

            Declare Property pop () ByRef As datatype    '' popping from the user stack

            Declare Property used () As Integer          '' outputting number of used elements in the user stack

            Declare Property allocated () As Integer     '' outputting number of allocated elements in the user stack

            Declare Destructor ()                        '' deallocating user stack memory

        Private:

            Dim As datatype ae (Any)  '' array of elements

            Dim As Integer nue        '' number of used elements

            Dim As Integer nae        '' number of allocated elements

            Dim As Integer nae0       '' minimum number of allocated elements

    End Type

    Constructor typename ()

        This.nae0 = 2^Int(Log(1024 * 1024 / SizeOf(datatype)) / Log(2) + 1) '' only a power of 2 (1 MB < stack memory < 2 MB here)

        This.nue = 0

        This.nae = This.nae0

        ReDim This.ae(This.nae - 1)                                         '' pre-allocating user stack memory

    End Constructor

    Property typename.push (ByRef i As datatype)  '' pushing on the user stack

        This.nue += 1

        If This.nue > This.nae0 And This.nae < This.nue * 2 Then

            This.nae *= 2

            ReDim Preserve This.ae(This.nae - 1)  '' allocating user stack memory for double used elements at least

        End If

        This.ae(This.nue - 1) = i

    End Property

    Property typename.pop () ByRef As datatype  '' popping from the user stack

        If This.nue > 0 Then

            Property = This.ae(This.nue - 1)

            This.nue -= 1

            If This.nue > This.nae0 And This.nae > This.nue * 2 Then

                This.nae \= 2

                ReDim Preserve This.ae(This.nae - 1)  '' allocating user stack memory for double used elements at more

            End If

        Else

            Static As datatype d

            Dim As datatype d0

            d = d0

            Property = d

            AssertWarn(This.nue > 0)  '' warning if popping while empty user stack and debug mode (-g compiler option)

        End If

    End Property

    Property typename.used () As Integer  '' outputting number of used elements in the user stack

        Property = This.nue

    End Property

    Property typename.allocated () As Integer  '' outputting number of allocated elements in the user stack

        Property = This.nae

    End Property

    Destructor typename  '' deallocating user stack memory

        This.nue = 0

        This.nae = 0

        Erase This.ae  '' deallocating user stack memory

    End Destructor

#endmacro
```

*Translation Quite Simple from Final Recursive Procedure (non-tail) to Iterative Procedure*

A non-tail recursive procedure is final when the recursive call(s) is(are) placed at the end of executed code (no executable instruction line after and between for several recursive calls).

 In the 3 following examples, the transformation of a recursive procedure into an iterative procedure is quite simple because the recursive calls are always at the end of executed code block, and without order constraints:

**-** Make the procedure parameters (and the return value for a function) as local ones.
 **-** Push the initial parameter values in the user stack.
 **-** Enter in a While ... Wend loop to empty the user stack:

- Pull the variables from the user stack.
 - Process the variables similarly to the recursive procedure body.
 - Accumulate the "return" variable for a recursive function (the final value will be returned at function body end).
 - Replace the recursive calls by pushing the corresponding variables on the user stack.

First example (for console window): Computation of the combination coefficients nCp (binomial coefficients calculation) and display of the Pascal's triangle:

The first function `recursiveCombination` is the recursive form (not a tail recursion because there are two recursive calls with summation in the last active statement).  
 The second function `translationToIterativeCombinationStack` is the iterative form using an own stack.

 In the two functions, a similar structure is conserved to enlighten the conversion method.  
 From recursive function to iterative stacking function:

**-** Ahead, declaration of 1 local variable for the accumulator.
 **-** Pushing the two initial parameters values in the user stack.
 **-** Entering in the `While ... Wend` loop to empty the user stack.
 **-** Pulling parameters from the user stack.
 **-** `Return 1` is replaced by `cumul = cumul + 1`.
 **-** `Return recursiveCombination(n - 1, p) + recursiveCombination(n - 1, p - 1)` is replaced by `S.push = n - 1 : S.push = p` and `S.push = n - 1 : S.push = p - 1`.

```freebasic
Function recursiveCombination (ByVal n As UInteger, ByVal p As UInteger) As LongInt

    If p = 0 Or p = n Then

        Return 1

    Else

        Return recursiveCombination(n - 1, p) + recursiveCombination(n - 1, p - 1)

    End If

End Function

'---------------------------------------------------------------------------

#include "DynamicUserStackTypeCreateMacro.bi"

DynamicUserStackTypeCreate(DynamicUserStackTypeForUinteger, UInteger)

Function translationToIterativeCombinationStack (ByVal n As UInteger, ByVal p As UInteger) As LongInt

    Dim cumul As LongInt = 0

    Dim As DynamicUserStackTypeForUinteger S

    S.push = n : S.push = p

    While S.used > 0

        p = S.pop : n = S.pop

        If p = 0 Or p = n Then

            cumul = cumul + 1

        Else

            S.push = n - 1 : S.push = p

            S.push = n - 1 : S.push = p - 1

        End If

    Wend

    Return cumul

End Function

'---------------------------------------------------------------------------

Sub Display(ByVal Combination As Function (ByVal n As UInteger, ByVal p As UInteger) As LongInt, ByVal n As Integer)

    For I As UInteger = 0 To n

        For J As UInteger = 0 To I

            Locate , 6 * J + 3 * (n - I) + 3

            Print Combination(I, J);

        Next J

        Print

    Next I

End Sub

'---------------------------------------------------------------------------

Print " recursion:";

Display(@recursiveCombination, 12)

Print

Print

Print " iteration with own storage stack:";

Display(@translationToIterativeCombinationStack, 12)

Sleep
```

Second example (for graphics window), using a non-tail recursive subroutine (recursive drawing of circles):

Similar transformation steps:

```freebasic
Sub recursiveCircle (ByVal x As Integer, ByVal y As Integer, ByVal r As Integer)

    Circle (x, y), r

    If r > 16 Then

        recursiveCircle(x + r / 2, y, r / 2)

        recursiveCircle(x - r / 2, y, r / 2)

        recursiveCircle(x, y + r / 2, r / 2)

        recursiveCircle(x, y - r / 2, r / 2)

    End If

End Sub

'---------------------------------------------------------------------------

#include "DynamicUserStackTypeCreateMacro.bi"

DynamicUserStackTypeCreate(DynamicUserStackTypeForInteger, Integer)

Sub recursiveToIterativeCircleStack (ByVal x As Integer, ByVal y As Integer, ByVal r As Integer)

    Dim As DynamicUserStackTypeForInteger S

    S.push = x : S.push = y : S.push = r

    Do While S.used > 0

        r = S.pop : y = S.pop : x = S.pop

        Circle (x, y), r

        If r > 16 Then

            S.push = x + r / 2 : S.push = y : S.push = r / 2

            S.push = x - r / 2 : S.push = y : S.push = r / 2

            S.push = x : S.push = y + r / 2 : S.push = r / 2

            S.push = x : S.push = y - r / 2 : S.push = r / 2

        End If

    Loop

End Sub

'---------------------------------------------------------------------------

Screen 12

Locate 2, 2

Print "recursion:"

recursiveCircle(160, 160, 150)

Locate 10, 47

Print "iteration with own storage stack:"

recursiveToIterativeCircleStack(480, 320, 150)

Sleep
```

Third example (for console window), using a non-tail recursive subroutine (Quick Sort algorithm):

Similar transformation steps:

```freebasic
Dim Shared As UByte t(99)

Sub recursiveQuicksort (ByVal L As Integer, ByVal R As Integer)

    Dim As Integer pivot = L, I = L, J = R

    Do

        If t(I) >= t(J) Then

            Swap t(I), t(J)

            pivot = L + R - pivot

        End If

        If pivot = L Then

            J = J - 1

        Else

            I = I + 1

        End If

    Loop Until I = J

    If L < I - 1 Then

        recursiveQuicksort(L, I - 1)

    End If

    If R > J + 1 Then

        recursiveQuicksort(J + 1, R)

    End If

End Sub

#include "DynamicUserStackTypeCreateMacro.bi"

DynamicUserStackTypeCreate(DynamicUserStackTypeForInteger, Integer)

Sub translationToIteraticeQuicksortStack (ByVal L As Integer, ByVal R As Integer)

    Dim As DynamicUserStackTypeForInteger S

    S.push = L : S.push = R

    While S.used > 0

        R = S.pop : L = S.pop

        Dim As Integer pivot = L, I = L, J = R

        Do

            If t(I) >= t(J) Then

                Swap t(I), t(J)

                pivot = L + R - pivot

            End If

            If pivot = L Then

                J = J - 1

            Else

                I = I + 1

            End If

        Loop Until I = J

        If L < I - 1 Then

            S.push = L : S.push = I - 1

        End If

        If R > J + 1 Then

            S.push = J + 1 : S.push = R

        End If

    Wend

End Sub

Randomize

For I As Integer = LBound(t) To UBound(t)

    t(i) = Int(Rnd * 256)

Next I

Print "raw memory:"

For K As Integer = LBound(t) To UBound(t)

    Print Using "####"; t(K);

Next K

Print

recursiveQuicksort(LBound(t), UBound(t))

Print "sorted memory by recursion:"

For K As Integer = LBound(t) To UBound(t)

    Print Using "####"; t(K);

Next K

Print

Print

Randomize

For I As Integer = LBound(t) To UBound(t)

    t(i) = Int(Rnd * 256)

Next I

Print "raw memory:"

For K As Integer = LBound(t) To UBound(t)

    Print Using "####"; t(K);

Next K

Print

translationToIteraticeQuicksortStack(LBound(t), UBound(t))

Print "sorted memory by iteration with stack:"

For K As Integer = LBound(t) To UBound(t)

    Print Using "####"; t(K);

Next K

Print

Sleep
```

*Translation Little More Complex from Non-Final Recursive Procedure to Iterative Procedure*

For theses examples, the transformation of the non-final recursive procedure into an iterative procedure is a little more complex because the recursive call(s) is(are) not placed at the end of executed code.

 The general method used hereafter is to first transform original recursive procedure into a "final" recursive procedure where the recursive call(s) is(are) now placed at the end of executed code block (no executable instruction line between or after).

 First example (for console window), using a non-tail recursive subroutine (tower of Hanoi algorithm):

For this example, the two recursive calls are at the end of executed code block but separated by an instruction line and there is an order constraint.  
 In the two functions, a similar structure is conserved to enlighten the conversion method.  
 From recursive function to iterative stacking function:

**-** The first step consists in removing the instruction line between the two recursive calls by adding its equivalent at top of the recursive code body (2 parameters are added to the procedure to pass the corresponding useful data).
 **-** Then the process of translation to iterative form is similar to the previous examples (using a own storage stack) but reversing the order of the 2 recursive calls when pushing on the storage stack.

```freebasic
Sub recursiveHanoi (ByVal n As Integer, ByVal departure As String, ByVal middle As String, ByVal arrival As String)

    If n > 0 Then

        recursiveHanoi(n - 1, departure, arrival, middle)

        Print "  move one disk from " & departure & " to " & arrival

        recursiveHanoi(n -1 , middle, departure, arrival)

    End If

End Sub

Sub finalRecursiveHanoi (ByVal n As Integer, ByVal departure As String, ByVal middle As String, ByVal arrival As String, ByVal dep As String = "", ByVal arr As String = "")

    If dep <> "" Then Print "  move one disk from " & dep & " to " & arr

    If n > 0 Then

        finalRecursiveHanoi(n - 1, departure, arrival, middle, "")

        finalRecursiveHanoi(n - 1, middle, departure, arrival, departure, arrival)

    End If

End Sub

#include "DynamicUserStackTypeCreateMacro.bi"

DynamicUserStackTypeCreate(DynamicUserStackTypeForString, String)

Sub translationToIterativeHanoi (ByVal n As Integer, ByVal departure As String, ByVal middle As String, ByVal arrival As String)

    Dim As String dep = "", arr = ""

    Dim As DynamicUserStackTypeForString S

    S.push = Str(n) : S.push = departure : S.push = middle : S.push = arrival : S.push = dep : S.push = arr

    While S.used > 0

        arr = S.pop : dep = S.pop : arrival = S.pop : middle = S.pop : departure = S.pop : n = Val(S.pop)

        If dep <> "" Then Print "  move one disk from " & dep & " to " & arr

        If n > 0 Then

            S.push = Str(n - 1) : S.push = middle : S.push = departure : S.push = arrival : S.push = departure : S.push = arrival

            S.push = Str(n - 1) : S.push = departure : S.push = arrival : S.push = middle : S.push = "" : S.push = ""

        End If

    Wend

End Sub

Print "recursive tower of Hanoi:"

recursiveHanoi(3, "A", "B", "C")

Print

Print "final recursive tower of Hanoi:"

finalRecursiveHanoi(3, "A", "B", "C")

Print

Print "iterative tower of Hanoi:"

translationToIterativeHanoi(3, "A", "B", "C")

Print

Sleep
```

Second example (for console window), using a non-tail recursive subroutine (counting-down from n, then re-counting up to n):

For this example, the recursive call is followed by an instruction line before the end of executed code block.  
 In the two functions, a similar structure is conserved to enlighten the conversion method.  
 From recursive function to iterative stacking function:

**-** The first step consists in replacing the instruction line at the end of executed code block by a new recursive call (a parameter is added to the procedure to pass the corresponding useful data).
 **-** An equivalent instruction line is added at top of the recursive code body (using the passed data), executed in this case instead of the normal code.
 **-** Then the process of translation to iterative form is similar to the previous example (using a own storage stack) and reversing the order of the 2 recursive calls when pushing on the storage stack.

```freebasic
Sub recursiveCount (ByVal n As Integer)

    If n >= 0 Then

        Print n & " ";

        If n = 0 Then Print

        recursiveCount(n - 1)

        Print n & " ";

    End If

End Sub

Sub finalRecursiveCount (ByVal n As Integer, ByVal recount As String = "")

    If recount <> "" Then

        Print recount & " ";

    Else

        If n >= 0 Then

            Print n & " ";

            If n = 0 Then Print

            finalRecursiveCount(n - 1, "")

            finalRecursiveCount(n - 1, Str(n))

        End If

    End If

End Sub

#include "DynamicUserStackTypeCreateMacro.bi"

DynamicUserStackTypeCreate(DynamicUserStackTypeForString, String)

Sub translationToIterativeCount (ByVal n As Integer)

    Dim As String recount = ""

    Dim As DynamicUserStackTypeForString S

    S.push = Str(n) : S.push = recount

    While S.used > 0

        recount = S.pop : n = Val(S.pop)

        If recount <> "" Then

            Print recount & " ";

        Else

            If n >= 0 Then

                Print n & " ";

                If n = 0 Then Print

                S.push = Str(n - 1) : S.push = Str(n)

                S.push = Str(n - 1) : S.push = ""

            End If

        End If

    Wend

End Sub

Print "recursive counting-down then re-counting up:"

recursiveCount(9)

Print

Print

Print "final recursive counting-down then re-counting up:"

finalRecursiveCount(9)

Print

Print

Print "iterative counting-down then re-counting up:"

translationToIterativeCount(9)

Print

Print

Sleep
```

*Translation from Other Non-Obvious Recursive Procedure to Iterative Procedure*

Two other cases of translation from recursion to iteration are presented here by means of simple examples:

**-** For mutual recursion.
 **-** For nested recursion.

Two functions are said to be mutually recursive if the first calls the second, and in turn the second calls the first.  
 A recursive function is said nested if an argument passed to the function refers to the function itself.

 Example using mutual recursive functions ('even()' and 'odd()' functions):

From mutual recursive procedures to iterative stacking procedures (for the general case):

**-** The first step consists in transforming the recursive procedures into "final" recursive procedures.
 **-** Then, the method is similar than that already described, with besides an additional parameter (an index) which is also pushed on the user stack in order to select the right code body to execute when pulling data from the stack.
 **-** Therefore, each iterative procedure contains the translation (for stacking) of all code bodies from the recursive procedures.

In this following examples, the simple mutual recursive functions are here processed as in the general case (other very simple iterative solutions exist):

```freebasic
Declare Function recursiveIsEven(ByVal n As Integer) As Boolean

Declare Function recursiveIsOdd(ByVal n As Integer) As Boolean

Function recursiveIsEven(ByVal n As Integer) As Boolean

    If n = 0 Then

        Return True

    Else

        Return recursiveIsOdd(n - 1)

    End If

End Function

Function recursiveIsOdd(ByVal n As Integer) As Boolean

    If n = 0 Then

        Return False

    Else

        Return recursiveIsEven(n - 1)

    End If

End Function

#include "DynamicUserStackTypeCreateMacro.bi"

DynamicUserStackTypeCreate(DynamicUserStackTypeForInteger, Integer)

Function iterativeIsEven(ByVal n As Integer) As Boolean

    Dim As Integer i = 1

    Dim As DynamicUserStackTypeForInteger S

    S.push = n : S.push = i

    While S.used > 0

        i = S.pop : n = S.pop

        If i = 1 Then

            If n = 0 Then

                Return True

            Else

                S.push = n - 1 : S.push = 2

            End If

        ElseIf i = 2 Then

            If n = 0 Then

                Return False

            Else

                S.push = n - 1 : S.push = 1

            End If

        End If

    Wend

End Function

Function iterativeIsOdd(ByVal n As Integer) As Boolean

    Dim As Integer i = 2

    Dim As DynamicUserStackTypeForInteger S

    S.push = n : S.push = i

    While S.used > 0

        i = S.pop : n = S.pop

        If i = 1 Then

            If n = 0 Then

                Return True

            Else

                S.push = n - 1 : S.push = 2

            End If

        ElseIf i = 2 Then

            If n = 0 Then

                Return False

            Else

                S.push = n - 1 : S.push = 1

            End If

        End If

    Wend

End Function

Print recursiveIsEven(16), recursiveIsOdd(16)

Print recursiveIsEven(17), recursiveIsOdd(17)

Print

Print iterativeIsEven(16), iterativeIsOdd(16)

Print iterativeIsEven(17), iterativeIsOdd(17)

Print

Sleep
```

Example using nested recursive function ('Ackermann()' function):

From nested recursive function to iterative stacking function:

**-** Use 2 independent storage stacks, one for the first parameter `m` and another for the second parameter `n` of the function, because of the nested call on one parameter.
 **-** `Return expression` is transformed into a pushing the expression on the stack dedicated to the parameter where the nesting call is.
 **-** Therefore a `Return` of data popping from the same stack is added at code end.

```freebasic
Function recursiveAckermann (ByVal m As Integer, ByVal n As Integer) As Integer

    If m = 0 Then

        Return n + 1

    Else

        If n = 0 Then

            Return recursiveAckermann(m - 1, 1)

        Else

            Return recursiveAckermann(m - 1, recursiveAckermann(m, n - 1))

        End If

    End If

End Function

#include "DynamicUserStackTypeCreateMacro.bi"

DynamicUserStackTypeCreate(DynamicUserStackTypeForInteger, Integer)

Function iterativeAckermann (ByVal m As Integer, ByVal n As Integer) As Integer

    Dim As DynamicUserStackTypeForInteger Sm, Sn

    Sm.push = m : Sn.push = n

    While Sm.used > 0

        m = Sm.pop : n = Sn.pop

        If m = 0 Then

            Sn.push = n + 1                                      ' Return n + 1 (and because of nested call)

        Else

            If n = 0 Then

                Sm.push = m - 1 : Sn.push = 1                    ' Return Ackermann(m - 1, 1)

            Else

                Sm.push = m - 1 : Sm.push = m : Sn.push = n - 1  ' Return Ackermann(m - 1, Ackermann(m, n - 1))

            End If

        End If

    Wend

    Return Sn.pop                                                ' (because of Sn.push = n + 1)

End Function

Print recursiveAckermann(3, 0), recursiveAckermann(3, 1), recursiveAckermann(3, 2), recursiveAckermann(3, 3), recursiveAckermann(3, 4)

Print iterativeAckermann(3, 0), iterativeAckermann(3, 1), iterativeAckermann(3, 2), iterativeAckermann(3, 3), iterativeAckermann(3, 4)

Sleep
```

Back to top

See also

- [Recursion](Recursion)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
