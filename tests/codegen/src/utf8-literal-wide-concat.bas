	#define hello "Καλημέρα "
	#define world "κόσμε!"
	#define helloworld hello + world
dim as wstring * 32 hw1 = "Καλημέρα κόσμε!"
dim as wstring * 32 hw2 = helloworld
print hw1 = hw2, len(hw1), len(hw2), hw1 = helloworld, helloworld = hw2
dim as wstring * 32 hw3 = hello
print len(hw3), hw3 = hello
