'' GOSUB jumps to a label; RETURN comes back. tiko refuses it.
dim as long total = 0
gosub add_one
gosub add_one
print total
end

add_one:
    total = total + 1
    return
