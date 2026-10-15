/* c2t P0 probe 1: does clang_tokenize return comment tokens? */
// a line comment
int a; /* trailing block */
int b; // trailing line
/** a doc comment */
struct S {
    int x;   // field comment
    /* leading field comment */
    int y;
};
