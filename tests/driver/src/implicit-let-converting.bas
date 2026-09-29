'' A type with a destructor and only a CONVERTING 'operator let': copying one is the
'' synthesised same-type 'let' (fbx's COleDateTimeSpan, 'operator = dateSpanTemp').
type Span
    m_span as double
    m_status as boolean = true
    declare destructor
    declare operator let( byval d as double )
end type
destructor Span
end destructor
operator Span.let( byval d as double )
    m_span = d
end operator
operator + ( byref a as Span, byref b as Span ) as Span
    dim as Span t
    t.m_span = a.m_span + b.m_span
    operator = t
end operator
dim as Span x, y
x.m_span = 40 : y.m_span = 2
print ( x + y ).m_span
