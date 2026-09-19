[Home](Home) › [Tutorials](Category-Tutorials) › **A Brief Introduction To Trigonometry**

# A Brief Introduction To Trigonometry

*Written by RandyKeeling*

 This tutorial includes:

- Right Triangles
- Pythagoras' Theorem
- Trigonometric Functions
- Applying Trigonometric functions
- Inverse Trigonometric functions
- Other Trigonometric functions
- Law of Sines, Law of Cosines, and other relationships

Trigonometry can be thought of as the study of triangles. There is more to it than that, but this will suffice for this tutorial. While this may seem to be of limited use, many problems in both the real and virtual worlds can be solved by creative application of triangles.

 A triangle has three sides and in 'normal' (i.e. Euclidean) space has three angles whose measurements add to be exactly 180 degrees (or Pi radians). For this tutorial we will deal only with 'normal' triangles (for those interested in other spaces, search for non-Euclidean triangles or non-Euclidean geometry).

 **Right Triangles**
 To begin with, we will deal with a special class of triangles known as right triangles. A right triangle has one angle that measures 90 degrees. Because the angles of a triangles must be exactly 180 degrees, there can be only one 90 degree angle in a triangle (and it is the largest angle in a right triangle). Below is FreeBASIC code to draw an image of a right triangle. (This image will be referred to throughout the tutorial.) In this image, uppercase letters denote sides, and their corresponding lowercase letters denote the angle opposite of the side. For example, angle y is the angle opposite side Y.

```freebasic
ScreenRes 640,480,8

'Triangle

Color 7

Line (220,140) - (220,340)

Line (220,140) - (420,340)

Line (220,340) - (420,340)

'right angle

Color 12

Line (220,320) - (240,320)

Line (240,320) - (240,340)

'angles

Color 13

Locate 20,29

Print "x"

Locate 42,50

Print "y"

'Sides

Color 14

Locate 31,43

Print "Z"

Locate 31, 26

Print "Y"

Locate 45, 40

Print "X"

Sleep
```

 The box in the lower right hand corner means that it is a right angle (measures 90 degrees). The side opposite of that angle (side Z) is called the hypotenuse and is the longest side in a right triangle.

 **Pythagoras' Theorem**

 Perhaps the first bit of trigonometry that most people learn is the relationship commonly known as Pythagoras' Theorem. It simply states that the square of the hypotenuse of a right triangle is equal to the sum of the square of the other two sides. It is easier to understand in equation form.

 Z^2 = X^2 + Y^2

 A trivial example application of this law might be the following.

 If player one is 100 meters due east of a marked location (the origin) and player two is 150 meters due north of the same location, how far apart are they?

 D = SQR(100^2 + 150^2)

 **Trigonometric Functions**

 Long ago people discovered that regardless of the size of the triangle, certain ratios were always the same. For example, in the image of the triangle above, if the measure of angle y is 45 degrees, then regardless of the size of the triangle, the ratio Y/X will always be the same. Collections of these ratios are trigonometric functions.

 The three primary functions are Sine ([Sin](Sin)), Cosine ([Cos](Cos)), and Tangent (TAN). There are many different ways to define these three functions. One way is with relationships between sides of a right triangle.

- Sine ([Sin](Sin)) is the ratio of the side opposite the angle in question to the hypotenuse. In the above triangle, the sine of the angle y (written as SIN(y)) is the length of side Y divided by the length of side Z.
  Cosine ([Cos](Cos)) is the ratio of the side adjacent to the angle in question to the hypotenuse. In the above triangle, the cosine of angle y (written COS(y)) is the length of Side X divided by the length of side Z.  
  Tangent ([Tan](Tan)) is the ratio of the side opposite to the angle in question to the side adjacent to the angle in question. In the above triangle, the tangent of angle y (written as [Tan](Tan)(y)) is the length of side Y divided by the length of side X.

Many people remember these relationships with the mnemonic device SOHCAHTOA (pronounced Sow Cah Toe-a) which is of course [Sin](Sin) = opposite/hypotenuse, [Cos](Cos) = adjacent/hypotenuse, and [Tan](Tan) = opposite/adjacent.

 FreeBASIC has functions for these trigonometric functions and others.

 **Applying Trigonometric functions**

 Referring again to the triangle image above, let's say that player one is on the ground at the point near angle y and player two is at the point near angle x (off of the ground). If player one knows how far he or she is from the side Y (let's say 25.2 meters) and can measure the value of angle y (let's say 31.5 degrees) how far off the ground is player two? How far away is player one from player two?

 To solve this we look at what pieces of information we know. We know the adjacent side to angle y (25.2 meters) and the measure of angle y (31.5 degrees). This is enough information to use the tangent function. [Tan](Tan) ( y ) = Opposite/adjacent, or TAN(31.5 degrees) = Opposite/25.2 meters. Using a little algebra to rearrange this we get opposite = [Tan](Tan)(31.5 degrees) \* 25.2 meters. To find the distance between the players we could use Pythagoras's Theorem now that we know the two non-hypotenuse sides of the triangle or we could use the cosine. Using cosine would give [Cos](Cos) ( y ) = adjacent/hypotenuse. With some algebra we get, hypotenuse = 25.2/[Cos](Cos)(31.5 degrees).

 Before we can write a program to solve this, we must remember that FreeBASIC, like most programming languages, works with radians, not degrees (see [Angles](Different-Ways-Angles-Are-Measured) ).

 In FreeBASIC we could get the answer with this code.

```freebasic
Const PI As Double = 3.1415926535897932

Dim Opposite As Double

Dim Hypotenuse As Double

Dim Angle As Double

Angle = 31.5 * Pi / 180

Opposite = Tan ( Angle ) * 25.2

Hypotenuse = 25.2 / Cos ( Angle )

Print Opposite

Print Hypotenuse

Sleep
```

 The above code tells us that player two is about 15.4 meters off the ground and around 29.5 meters away (along the hypotenuse).

 **Inverse Trigonometric functions**

 But what if you know the sides of a triangle and need to find the angle? You would then use the inverse trigonometric functions.

- ArcSine (or Inverse Sine)
- ArcCosine (or Inverse Cosine)
- ArcTangent (or Inverse Tangent)

For example, using the above set-up, if player two was 30 meters off the ground and 50 meters away from player one (along the hypotenuse) what is the measure of angle y? Looking at our trigonometric functions it looks like we have need of the sine function (an opposite and a hypotenuse). [Sin](Sin) ( y ) = opposite/hypotenuse, ArcSine (opposite/hypotenuse) = y.

 `Print Asin (30/50)`  
 This gives an angle of about 0.6435 radians, or around 36.9 degrees. The FreeBASIC command for each of these inverse functions are:

- [Asin](Asin) (arcsine)
  [Acos](Cos) (arccosine)  
  [Atn](Atn) (arctan, there is also [Atan2](Atan2) which takes the opposite and adjacent sides of the triangle, not their ratio)

*Editors note:
 ATN returns the arctangent of the argument number as a Double within the range of -Pi/2 to Pi/2.  
 ATAN2 returns the arctangent of the ratio y/x as a Double within the range of -Pi to Pi*

 **Other Trigonometric functions**

 There are other trigonometric functions that are defined in terms of the above functions. Although none of the below are defined in FreeBASIC.

- Secant (sec(y)) is 1/[Cos](Cos)(y)
- Cosecant (csc(y)) is 1/[Sin](Sin)(y)
- Cotangent (cot(y)) is 1/[Tan](Tan)(y)

Each of these has an inverse (or arc) functions as well.

 **Law of Sines, Law of Cosines, and other relationships**
 All of the above has assumed a right triangle, but this was an aid in explaining the basic trigonometric functions. The following does not rely on right triangles; these identities are valid for any triangle.

 Law of Sines  
 [Sin](Sin) (y)/Y = [Sin](Sin) (x)/X = [Sin](Sin) (z)/Z

 Law of Cosines  
 Z^2 = X^2 + Y^2 - 2\*X\*Y\*[Cos](Cos)(z)

 Other Identities

 [Sin](Sin)^2(y) + [Cos](Cos)^2(y) = 1  
 This means the same as [Sin](Sin)(y)\*[Sin](Sin)(y) + [Cos](Cos)(y)\*[Cos](Cos)(y) = 1

 [Tan](Tan)(y) = [Sin](Sin)((y)/[Cos](Cos)(y)

 There are several more useful identities out there. Search for trigonometric identities or consult any higher mathematical reference.

 *Last reviewed by sancho3 on February 15, 2018 Note: Added clarification of ATN and ATAN2 funcitons as requested*

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
