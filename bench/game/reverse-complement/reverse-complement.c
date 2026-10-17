/* reverse-complement: write the reverse complement of each DNA sequence. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef _WIN32
#include <fcntl.h>
#include <io.h>
#endif

#define LINE 60

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
    unsigned char comp[256];
    for (int i = 0; i < 256; i++)
        comp[i] = (unsigned char)i;
    const char *from = "ACBDGHKMNSRUTWVYacbdghkmnsrutwvy";
    const char *to = "TGVHCDMKNSYAAWBRTGVHCDMKNSYAAWBR";
    for (int i = 0; from[i]; i++)
        comp[(unsigned char)from[i]] = (unsigned char)to[i];

    size_t len;
    unsigned char *in = read_all(stdin, &len);
    unsigned char *seq = malloc(len + 1);
    unsigned char *out = malloc(len + len / LINE + 2);
    size_t o = 0;
    size_t i = 0;
    while (i < len) {
        /* header line, copied as is */
        size_t start = i;
        while (i < len && in[i] != '\n')
            i++;
        memcpy(out + o, in + start, i - start);
        o += i - start;
        out[o++] = '\n';
        i++;
        /* sequence lines up to the next header, newlines dropped */
        size_t s = 0;
        while (i < len && in[i] != '>') {
            if (in[i] != '\n')
                seq[s++] = in[i];
            i++;
        }
        /* reversed and complemented, LINE to a line */
        size_t col = 0;
        while (s > 0) {
            out[o++] = comp[seq[--s]];
            if (++col == LINE) {
                out[o++] = '\n';
                col = 0;
            }
        }
        if (col > 0)
            out[o++] = '\n';
    }
    fwrite(out, 1, o, stdout);
    free(in);
    free(seq);
    free(out);
    return 0;
}
