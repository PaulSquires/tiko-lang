[Home](Home) › [Miscellaneous](Category-Miscellaneous) › **Comparison of C/C++ and FreeBASIC**

# Comparison of C/C++ and FreeBASIC

**C/C++**

**FreeBASIC**

 **variable declaration**

```freebasic
int a;

int a, b, c;
```

```freebasic
dim a as long

dim as long a, b, c
```

 **uninitialized variable**

`int a;`

`dim a as long = any`

 **zero-initialized variable**

`int a = 0;`

`dim a as long`

 **initialized variable**

`int a = 123;`

`dim a as long = 123`

 **array**

```freebasic
int a[4];

a[0] = 1;
```

```freebasic
dim a(0 to 3) as long

a(0) = 1
```

 **pointer**

```freebasic
int a;

int *p;

p = &a;

*p = 123;
```

```freebasic
dim a as long

dim p as long ptr

p = @a

*p = 123
```

 **structure, user-defined type**

```freebasic
struct UDT {

int myfield;

}
```

```freebasic
type UDT

myfield as long

end type
```

 **typedef, type alias**

`typedef int myint;`

`type myint as long`

 **struct pointer**

```freebasic
struct UDT x;

struct UDT *p;

p = &x;

p->myfield = 123;
```

```freebasic
dim x as UDT

dim p as UDT ptr

p = @x

p->myfield = 123
```

 **function declaration**

`int foo( void );`

`declare function foo( ) as long`

 **function body**

```freebasic
int foo( void ) {

return 123;

}
```

```freebasic
function foo( ) as long

return 123

end function
```

 **sub declaration**

`void foo( void );`

`declare sub foo( )`

 **sub body**

```freebasic
void foo( void ) {

}
```

```freebasic
sub foo( )

end sub
```

 **byval parameters**

```freebasic
void foo( int param );

foo( a );
```

```freebasic
declare sub foo( byval param as long )

foo( a )
```

 **byval pointers to parameters**

```freebasic
void foo( int *param );

foo( &a );
```

```freebasic
declare sub foo( byval param as long ptr )

foo( @a )
```

 **byref parameters**

```freebasic
void foo( int& param );

foo( a );
```

```freebasic
declare sub foo( byref param as long )

foo( a )
```

 **statement separator**

`;`

`:`  
`<end-of-line>`

 **for loop**

```freebasic
for (int i = 0; i < 10; i++) {

...

}
```

```freebasic
for i as long = 0 to 9

...

next
```

 **while loop**

```freebasic
while (condition) {

...

}
```

```freebasic
while condition

...

wend
```

 **do-while loop**

```freebasic
do {

...

} while (condition);
```

```freebasic
do

...

loop while condition
```

 **if block**

```freebasic
if (condition) {

...

} else if (condition) {

...

} else {

...

}
```

```freebasic
if condition then

...

elseif condition then

...

else

...

end if
```

 **switch, select**

```freebasic
switch (a) {

case 1:

...

break;

case 2:

case 3:

...

break;

default:

...

break;

}
```

```freebasic
select case a

case 1

...

case 2, 3

...

case else

...

end select
```

 **string literals, zstrings**

```freebasic
char *s = "Hello!";

char s[] = "Hello!";
```

```freebasic
dim s as zstring ptr = @"Hello!"

dim s as zstring * 6+1 = "Hello!"
```

 **hello world**

```freebasic
#include <stdio.h>

int main() {

printf("Hello!\n");

return 0;

}
```

`print "Hello!"`

 **comments**

```freebasic
// foo

/* foo */
```

```freebasic
' foo

/' foo '/
```

 **compile-time checks**

`#if a`  
`#elif b`  
`#else`  
`#endif`

`#if a`  
`#elseif b`  
`#else`  
`#endif`

 **compile-time target system checks**

`#ifdef _WIN32`

`#ifdef __FB_WIN32__`

 **module/header file names**

`foo.c, foo.h`

`foo.bas, foo.bi`

 **typical compiler command to create an executable**

`gcc foo.c -o foo`

`fbc foo.bas`

 *Last reviewed by MrSwiss on April 6, 2018 Note: changed Integer to Long (where needed)*

---

**Category:** [Miscellaneous](Category-Miscellaneous)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
