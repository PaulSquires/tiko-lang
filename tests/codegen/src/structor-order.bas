'' MODULE STRUCTORS GO OUT IN THE ORDER THAT RUNS THEM AS fbc DOES -- which is a
'' different order per target. See codegen/llvmstructors.bas for the measurement.
''
'' fbc-modern runs this program as
''
''     win64         p101 p200 p65535 c3 b2 a1 |main| d1 d2 q101
''     linux-x86_64  p101 p200 a1 b2 c3 p65535 |main| d2 d1 q101
''
'' and tiko ran every structor forwards in declaration order and ignored the numbers.
'' A written 65535 is unnumbered: gcc puts it in plain .ctors / .init_array.

sub a1( ) constructor
	print "a1 ";
end sub
sub p200( ) constructor 200
	print "p200 ";
end sub
sub b2( ) constructor
	print "b2 ";
end sub
sub p101( ) constructor 101
	print "p101 ";
end sub
sub c3( ) constructor
	print "c3 ";
end sub
sub p65535( ) constructor 65535
	print "p65535 ";
end sub

sub d1( ) destructor
	print "d1 ";
end sub
sub q101( ) destructor 101
	print "q101 ";
end sub
sub d2( ) destructor
	print "d2 ";
end sub

print "|main| ";
