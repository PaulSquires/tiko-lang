'' A DIAGNOSTIC AFTER '#line' IS REPORTED UNDER THE PRESENTED NAME AND NUMBER, and
'' fbc does exactly this: a file whose first line is '#line 100 "fake.bas"' reports a
'' fault on its fourth physical line as 'fake.bas(103)'.
''
'' The half worth a test is the SNIPPET. The header counts in presented lines and the
'' source text is indexed in physical ones, so a renderer that used one number for
'' both would print the wrong line of code underneath a correct header -- or, here,
'' walk off the end of a four-line file looking for line 102.
#line 100 "fake.bas"
dim as integer x
x = "not a number"
