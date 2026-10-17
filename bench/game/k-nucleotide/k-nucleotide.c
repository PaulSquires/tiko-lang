/* k-nucleotide: count every k-nucleotide of the third sequence, k = 1 2 3 4 6 12 18. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef _WIN32
#include <fcntl.h>
#include <io.h>
#endif

/* C has no standard map: a minimal open-addressing table, linear probing,
   power-of-two capacity, grown at a load factor of 3/4. Key 0 is a valid
   k-mer (all A), so occupancy is a separate flag. */
typedef struct { uint64_t key; uint32_t count; uint32_t used; } Slot;
typedef struct { Slot *slots; size_t cap, size; } Table;

static size_t slot_of(uint64_t key, size_t cap) {
    return (size_t)((key * 0x9E3779B97F4A7C15ull) >> 32) & (cap - 1);
}

static void table_init(Table *t, size_t cap) {
    t->slots = calloc(cap, sizeof(Slot));
    t->cap = cap;
    t->size = 0;
}

static void table_grow(Table *t) {
    Table bigger;
    table_init(&bigger, t->cap * 2);
    for (size_t i = 0; i < t->cap; i++) {
        if (!t->slots[i].used)
            continue;
        size_t j = slot_of(t->slots[i].key, bigger.cap);
        while (bigger.slots[j].used)
            j = (j + 1) & (bigger.cap - 1);
        bigger.slots[j] = t->slots[i];
    }
    bigger.size = t->size;
    free(t->slots);
    *t = bigger;
}

static void table_add(Table *t, uint64_t key) {
    size_t i = slot_of(key, t->cap);
    while (t->slots[i].used) {
        if (t->slots[i].key == key) {
            t->slots[i].count++;
            return;
        }
        i = (i + 1) & (t->cap - 1);
    }
    t->slots[i].key = key;
    t->slots[i].count = 1;
    t->slots[i].used = 1;
    if (++t->size * 4 > t->cap * 3)
        table_grow(t);
}

static uint32_t table_get(const Table *t, uint64_t key) {
    size_t i = slot_of(key, t->cap);
    while (t->slots[i].used) {
        if (t->slots[i].key == key)
            return t->slots[i].count;
        i = (i + 1) & (t->cap - 1);
    }
    return 0;
}

static int code_of(unsigned char c) {
    switch (c) {
    case 'A': return 0;
    case 'C': return 1;
    case 'G': return 2;
    default:  return 3;
    }
}

static const char letters[] = "ACGT";

static void count_all(Table *t, const unsigned char *seq, size_t len, int k) {
    uint64_t mask = k == 32 ? ~0ull : (1ull << (2 * k)) - 1;
    uint64_t key = 0;
    for (int i = 0; i < k - 1; i++)
        key = (key << 2) | code_of(seq[i]);
    for (size_t i = k - 1; i < len; i++) {
        key = ((key << 2) | code_of(seq[i])) & mask;
        table_add(t, key);
    }
}

typedef struct { uint64_t key; uint32_t count; } Entry;

static int by_count_then_key(const void *a, const void *b) {
    const Entry *x = a, *y = b;
    if (x->count != y->count)
        return x->count < y->count ? 1 : -1;
    return x->key < y->key ? -1 : x->key > y->key;
}

static void write_frequencies(const unsigned char *seq, size_t len, int k) {
    Table t;
    table_init(&t, 64);
    count_all(&t, seq, len, k);
    Entry *e = malloc(t.size * sizeof(Entry));
    size_t n = 0;
    for (size_t i = 0; i < t.cap; i++)
        if (t.slots[i].used) {
            e[n].key = t.slots[i].key;
            e[n].count = t.slots[i].count;
            n++;
        }
    qsort(e, n, sizeof(Entry), by_count_then_key);
    size_t total = len - k + 1;
    for (size_t i = 0; i < n; i++) {
        char name[33];
        for (int j = 0; j < k; j++)
            name[j] = letters[(e[i].key >> (2 * (k - 1 - j))) & 3];
        name[k] = 0;
        printf("%s %.3f\n", name, 100.0 * e[i].count / total);
    }
    printf("\n");
    free(e);
    free(t.slots);
}

static void write_count(const unsigned char *seq, size_t len, const char *frag) {
    int k = (int)strlen(frag);
    Table t;
    table_init(&t, 64);
    count_all(&t, seq, len, k);
    uint64_t key = 0;
    for (int i = 0; i < k; i++)
        key = (key << 2) | code_of((unsigned char)frag[i]);
    printf("%u\t%s\n", table_get(&t, key), frag);
    free(t.slots);
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
    size_t len;
    unsigned char *in = read_all(stdin, &len);
    /* the sequence after the ">THREE" header line, upper-cased, newlines dropped */
    size_t i = 0;
    for (;;) {
        if (len - i >= 6 && memcmp(in + i, ">THREE", 6) == 0)
            break;
        while (in[i] != '\n')
            i++;
        i++;
    }
    while (in[i] != '\n')
        i++;
    i++;
    size_t n = 0;
    for (; i < len; i++)
        if (in[i] != '\n')
            in[n++] = (unsigned char)(in[i] & ~0x20);

    write_frequencies(in, n, 1);
    write_frequencies(in, n, 2);
    write_count(in, n, "GGT");
    write_count(in, n, "GGTA");
    write_count(in, n, "GGTATT");
    write_count(in, n, "GGTATTTTAATT");
    write_count(in, n, "GGTATTTTAATTTATAGT");
    free(in);
    return 0;
}
