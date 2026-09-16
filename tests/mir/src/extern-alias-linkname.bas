'' 'ALIAS' ON AN EXTERN NAMES THE LINK SYMBOL. win/cguid.bi declares every COM GUID
'' this way -- 'extern IID_NULL alias "GUID_NULL" as const IID' -- and the reference
'' used to go out under the FreeBASIC spelling, undefined at the link.
extern plainOne as long
extern aliased alias "TheRealName" as long
extern "C"
    extern cAliased alias "AlsoReal" as long
end extern

print plainOne, aliased, cAliased
