'' GOSUB belongs to the qb and fblite dialects. tiko implements fb only.
dim as long total = 0
gosub add_one
print total
end

add_one:
    total += 1
    return
