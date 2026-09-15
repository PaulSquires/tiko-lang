'' NUMERIC LITERAL FORMS AND WHERE EACH ONE ENDS, measured literal by literal against fbc.
''
'' A DECIMAL literal is digits, an optional '.' with optional digits, an optional exponent
'' -- 'e' or QB's 'd', an optional sign, and digits that may be ABSENT -- and a suffix.
'' fbc takes '3d' as a DOUBLE 3, '3.' and '3.e' as 3, '3d+1' as 30 and '3.f' as a SINGLE;
'' tiko split every one of them into two tokens and refused the statement.
''
'' The suffix depends on the form: '% & u ul ull l ll' only without a point or an
'' exponent, 'f F ! #' on every form. An octal or binary literal also takes 'd' and 'f' as
'' DOUBLE and SINGLE; a hex one has already read them as digits.
''
'' The last line is where a literal STOPS, which fbc refuses in each case: '1e3d' is
'' '1e3' and an identifier 'd', '3.foo' is the SINGLE '3.f' and 'oo', '3.5ll' is '3.5'
'' and 'll' -- while '3dmod' and '3fand' are a literal and an operator, and compile.
3d 3D 3.d 3. 3.f .5d 3e 3e+ 3d- 3df 3d# 1d3f 1D-3F 3d+1 0d 18446744073709551615d
3 3% 3& 3u 3ul 3ull 3l 3ll 3f 3! 3# 3.5 3.5f 1e3 1e3f 1.5d3
&h3d &h3d! &hFFf# &h3ul &o7d &o7f &o7! &o7ul &b1d &b1f &b101#
3dmod 3fand 1e3d 3.x 3.foo 3.5ll 3d+x
