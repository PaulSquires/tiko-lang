' A 2-D var-len string array initialised in ROWS, a ustring one, and a short row.
dim as string a(1 to 2, 1 to 2) = {{"a", "b"}, {"c", "d"}}
dim as ustring u(0 to 1, 0 to 2) = {{"p", "q", "r"}, {"s"}}
dim as string one(2) = {"x", "y"}
print a(1, 1); a(1, 2); a(2, 1); a(2, 2); "|"; u(0, 2); u(1, 0); "["; u(1, 1); "]|"; one(1); "["; one(2); "]"
