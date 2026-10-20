' 'new typeof( ... )': the type of an expression as NEW's type.
dim as double ptr pd
pd = new typeof(*pd)
*pd = 1.5
dim as double ptr p2 = new typeof(*pd * 2)
*p2 = 7
print *pd; *p2; sizeof(*p2)
delete pd
delete p2
