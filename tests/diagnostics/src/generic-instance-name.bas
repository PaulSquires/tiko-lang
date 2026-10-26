'' A generic instance in a diagnostic is spelled as the source writes it: TKO0818 at line 6
'' names 'orderedmapiterator( of long, long ).Value( )', not the internal key
'' 'orderedmapiterator<6,6>' (by-example BUG-iterators-1).
#import "std/containers"
dim om as containers.OrderedMap( of long, long )
for each byref e in om
next
