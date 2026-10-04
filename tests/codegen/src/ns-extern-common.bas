namespace N1
    extern v as long
    dim v as long = 1
end namespace
namespace N2
    extern v as long
    dim v as long = 2
end namespace
print N1.v, N2.v
common shared comv as long
comv = 11
print comv
namespace NC
    common cmv as long
end namespace
NC.cmv = 5
print NC.cmv
extern ext0 alias "myext0" as long
dim ext0 as long = 9
print ext0
