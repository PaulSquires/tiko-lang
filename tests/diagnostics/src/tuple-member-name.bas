'' A TUPLE's MEMBERS ARE '_1' TO '_n': fbc-modern 1.20 gives error 18 on lines 13 to 18 and on 26.
'' TIKO ALSO TAKES AN ELEMENT's OWN NAME (symbols/tuplenames.bas): 'nt.a' is line 26; line 16 names none.
'' tiko once skipped tuples in the member check, and a PRINT of any of these printed nothing.
dim as (long, string) t = (1, "a")
dim as (a as long, b as string) nt = (2, "b")
dim as ((long, long), long) tt = ((1, 2), 3)
dim as long n
dim as string s
function F( ) as (long, long)
    return (3, 4)
end function

n = t._0
n = t._3
n = t.item1
n = nt.zz
nt.q = 1
n = tt._1.z

n = t._1
s = t._2
n = nt._1
t._1 = 5
n = tt._1._2
n = F( )._2
n = nt.a
