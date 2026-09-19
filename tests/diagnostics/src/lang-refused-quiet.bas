'' A unit whose '#lang' tiko-lang refuses gets that one error and no undeclared-name
'' report: in 'qb' an undeclared name is an implicit variable, so there it would be noise.
#lang "qb"
x = 1
print y
