namespace NS
    type P
        as long v
    end type
    operator = ( byref a as P, byref b as P ) as long
        print "NS.eq";
        return a.v = b.v
    end operator
    operator <> ( byref a as P, byref b as P ) as long
        print "NS.ne";
        return a.v <> b.v
    end operator
end namespace
type Q
    as long v
    declare operator cast( ) as long
end type
operator Q.cast( ) as long : return v : end operator
operator = ( byref a as Q, byref b as Q ) as long
    print "Q.eq";
    return a.v = b.v
end operator
dim as NS.P p1 = ( 1 ), p2 = ( 1 )
dim as Q q1 = ( 2 ), q2 = ( 3 )
dim as ( long, NS.P ) t1 = ( 5, p1 ), t2 = ( 5, p2 )
print t1 = t2
print t1 <> t2
dim as ( Q, long ) u1 = ( q1, 1 ), u2 = ( q2, 1 )
print u1 = u2
print u1 <> u2
