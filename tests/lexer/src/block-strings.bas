'' Block strings (docs/tiko-strings RFC-0001). Only a '"""' ending its line opens one;
'' every other spelling below keeps its fbc meaning.
print """abc"""
print """"
dim as string a = """   
    select id, name
      from users
  
    where q = "x" and "" and """ mid
    """
dim as string b = """
  two
"""
dim as string c = """
    line

    """
dim as string d = !"""
    a\tb \
    c\"q\" \\ \u0041
    """
dim as string e = $"""
    C:\new\table
    """
dim as string f = """
    """
dim as string g = """
	x
		y
	"""
print len( """
    arg
    """ & "tail" )
