'' ON n GOTO jumps to the n-th label in its list.
for choice as long = 0 to 4
    print "choice"; choice; ": ";
    on choice goto add, list, quit
    '' Out of range -- 0, or past the end of the list -- falls through.
    print "no such option"
    goto next_choice
add:
    print "adding a record"
    goto next_choice
list:
    print "listing the records"
    goto next_choice
quit:
    print "quitting"
next_choice:
next
