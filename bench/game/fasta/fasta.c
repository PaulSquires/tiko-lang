/* fasta: generate DNA sequences by copying and by weighted random selection. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef _WIN32
#include <fcntl.h>
#include <io.h>
#endif

#define LINE 60
#define IM 139968
#define IA 3877
#define IC 29573

static const char *alu =
    "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG"
    "GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA"
    "CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT"
    "ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA"
    "GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG"
    "AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC"
    "AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";

typedef struct { char c; double p; } Freq;

static Freq iub[] = {
    { 'a', 0.27 }, { 'c', 0.12 }, { 'g', 0.12 }, { 't', 0.27 },
    { 'B', 0.02 }, { 'D', 0.02 }, { 'H', 0.02 }, { 'K', 0.02 },
    { 'M', 0.02 }, { 'N', 0.02 }, { 'R', 0.02 }, { 'S', 0.02 },
    { 'V', 0.02 }, { 'W', 0.02 }, { 'Y', 0.02 },
};

static Freq homosapiens[] = {
    { 'a', 0.3029549426680 }, { 'c', 0.1979883004921 },
    { 'g', 0.1975473066391 }, { 't', 0.3015094502008 },
};

static int seed = 42;

static double rnd(void) {
    seed = (seed * IA + IC) % IM;
    return 1.0 * seed / IM;
}

static void repeat_fasta(const char *s, int n) {
    int len = (int)strlen(s);
    char *doubled = malloc(len + LINE);
    memcpy(doubled, s, len);
    memcpy(doubled + len, s, LINE);
    char line[LINE + 1];
    int pos = 0;
    while (n > 0) {
        int count = n < LINE ? n : LINE;
        memcpy(line, doubled + pos, count);
        line[count] = '\n';
        fwrite(line, 1, count + 1, stdout);
        pos += count;
        if (pos > len)
            pos -= len;
        n -= count;
    }
    free(doubled);
}

static void random_fasta(const Freq *table, int size, int n) {
    double cum[16];
    double p = 0.0;
    for (int i = 0; i < size; i++) {
        p += table[i].p;
        cum[i] = p;
    }
    int last = size - 1;
    char line[LINE + 1];
    while (n > 0) {
        int count = n < LINE ? n : LINE;
        for (int i = 0; i < count; i++) {
            double r = rnd();
            int j = 0;
            while (j < last && r >= cum[j])
                j++;
            line[i] = table[j].c;
        }
        line[count] = '\n';
        fwrite(line, 1, count + 1, stdout);
        n -= count;
    }
}

int main(int argc, char **argv) {
#ifdef _WIN32
    _setmode(_fileno(stdout), _O_BINARY);
#endif
    static char outbuf[1 << 16];
    setvbuf(stdout, outbuf, _IOFBF, sizeof outbuf);
    int n = argc > 1 ? atoi(argv[1]) : 1000;
    fputs(">ONE Homo sapiens alu\n", stdout);
    repeat_fasta(alu, n * 2);
    fputs(">TWO IUB ambiguity codes\n", stdout);
    random_fasta(iub, sizeof iub / sizeof iub[0], n * 3);
    fputs(">THREE Homo sapiens frequency\n", stdout);
    random_fasta(homosapiens, sizeof homosapiens / sizeof homosapiens[0], n * 5);
    return 0;
}
