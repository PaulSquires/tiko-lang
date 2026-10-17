/* regex-redux: match and replace DNA patterns with PCRE2 (JIT). */
#define PCRE2_CODE_UNIT_WIDTH 8
#include <pcre2.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef _WIN32
#include <fcntl.h>
#include <io.h>
#endif

static const char *variants[] = {
    "agggtaaa|tttaccct",
    "[cgt]gggtaaa|tttaccc[acg]",
    "a[act]ggtaaa|tttacc[agt]t",
    "ag[act]gtaaa|tttac[agt]ct",
    "agg[act]taaa|ttta[agt]cct",
    "aggg[acg]aaa|ttt[cgt]ccct",
    "agggt[cgt]aa|tt[acg]accct",
    "agggta[cgt]a|t[acg]taccct",
    "agggtaa[cgt]|[acg]ttaccct",
};

static const char *subst[][2] = {
    { "tHa[Nt]", "<4>" },
    { "aND|caN|Ha[DS]|WaS", "<3>" },
    { "a[NSt]|BY", "<2>" },
    { "<[^>]*>", "|" },
    { "\\|[^|][^|]*\\|", "-" },
};

static pcre2_code *compile(const char *pattern) {
    int err;
    PCRE2_SIZE off;
    pcre2_code *re = pcre2_compile((PCRE2_SPTR)pattern, PCRE2_ZERO_TERMINATED, 0, &err, &off, NULL);
    pcre2_jit_compile(re, PCRE2_JIT_COMPLETE);
    return re;
}

static size_t count_matches(const char *pattern, const unsigned char *s, size_t len) {
    pcre2_code *re = compile(pattern);
    pcre2_match_data *md = pcre2_match_data_create_from_pattern(re, NULL);
    PCRE2_SIZE *ov = pcre2_get_ovector_pointer(md);
    size_t count = 0, off = 0;
    while (pcre2_jit_match(re, s, len, off, 0, md, NULL) > 0) {
        count++;
        off = ov[1];
    }
    pcre2_match_data_free(md);
    pcre2_code_free(re);
    return count;
}

/* Every match of pattern in src replaced by rep, into dst; returns dst's length. */
static size_t replace_all(const char *pattern, const unsigned char *src, size_t len,
                          const char *rep, unsigned char *dst) {
    pcre2_code *re = compile(pattern);
    pcre2_match_data *md = pcre2_match_data_create_from_pattern(re, NULL);
    PCRE2_SIZE *ov = pcre2_get_ovector_pointer(md);
    size_t rep_len = strlen(rep), o = 0, off = 0;
    while (pcre2_jit_match(re, src, len, off, 0, md, NULL) > 0) {
        memcpy(dst + o, src + off, ov[0] - off);
        o += ov[0] - off;
        memcpy(dst + o, rep, rep_len);
        o += rep_len;
        off = ov[1];
    }
    memcpy(dst + o, src + off, len - off);
    o += len - off;
    pcre2_match_data_free(md);
    pcre2_code_free(re);
    return o;
}

static unsigned char *read_all(FILE *f, size_t *len) {
    size_t cap = 1 << 20, n = 0;
    unsigned char *buf = malloc(cap);
    for (;;) {
        if (n == cap) {
            cap *= 2;
            buf = realloc(buf, cap);
        }
        size_t got = fread(buf + n, 1, cap - n, f);
        if (got == 0)
            break;
        n += got;
    }
    *len = n;
    return buf;
}

int main(void) {
#ifdef _WIN32
    _setmode(_fileno(stdin), _O_BINARY);
    _setmode(_fileno(stdout), _O_BINARY);
#endif
    size_t ilen;
    unsigned char *seq = read_all(stdin, &ilen);
    /* room for the substitutions, which can lengthen the text */
    unsigned char *a = malloc(ilen * 2 + 16);
    unsigned char *b = malloc(ilen * 2 + 16);
    size_t clen = replace_all(">.*\n|\n", seq, ilen, "", a);

    for (size_t i = 0; i < sizeof variants / sizeof variants[0]; i++)
        printf("%s %zu\n", variants[i], count_matches(variants[i], a, clen));

    size_t len = clen;
    for (size_t i = 0; i < sizeof subst / sizeof subst[0]; i++) {
        len = replace_all(subst[i][0], a, len, subst[i][1], b);
        unsigned char *t = a;
        a = b;
        b = t;
    }
    printf("\n%zu\n%zu\n%zu\n", ilen, clen, len);
    free(seq);
    free(a);
    free(b);
    return 0;
}
