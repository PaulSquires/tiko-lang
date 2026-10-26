'' 'offsetof( OUTER, tooltip.text )' with a namespace 'tooltip' in effect: the path names
'' FIELDS, whatever 'tooltip' means in ordinary scope. It was TKO0745 'the namespace tooltip
'' has no member named text' (tiko-editor TE-006, through sys/win/gui's ToolTip module).
namespace tooltip
    dim as long other
end namespace
using tooltip
type INNER
    pad as long
    text as long
end type
type OUTER
    a as double
    tooltip as INNER
end type
print offsetof( OUTER, tooltip.text )
