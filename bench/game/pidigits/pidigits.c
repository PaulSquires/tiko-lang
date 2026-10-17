/* pidigits: the digits of pi, by the unbounded spigot algorithm on GMP integers. */
#include <gmp.h>
#include <stdio.h>
#include <stdlib.h>
#ifdef _WIN32
#include <fcntl.h>
#include <io.h>
#endif

static mpz_t tmp1, tmp2, acc, den, num;

static unsigned long extract_digit(unsigned long nth) {
    mpz_mul_ui(tmp1, num, nth);
    mpz_add(tmp2, tmp1, acc);
    mpz_tdiv_q(tmp1, tmp2, den);
    return mpz_get_ui(tmp1);
}

static void eliminate_digit(unsigned long d) {
    mpz_submul_ui(acc, den, d);
    mpz_mul_ui(acc, acc, 10);
    mpz_mul_ui(num, num, 10);
}

static void next_term(unsigned long k) {
    unsigned long k2 = k * 2 + 1;
    mpz_addmul_ui(acc, num, 2);
    mpz_mul_ui(acc, acc, k2);
    mpz_mul_ui(den, den, k2);
    mpz_mul_ui(num, num, k);
}

int main(int argc, char **argv) {
#ifdef _WIN32
    _setmode(_fileno(stdout), _O_BINARY);
#endif
    int n = argc > 1 ? atoi(argv[1]) : 30;
    mpz_init(tmp1);
    mpz_init(tmp2);
    mpz_init_set_ui(acc, 0);
    mpz_init_set_ui(den, 1);
    mpz_init_set_ui(num, 1);
    char line[11];
    int col = 0;
    unsigned long k = 0;
    for (int i = 0; i < n;) {
        next_term(++k);
        if (mpz_cmp(num, acc) > 0)
            continue;
        unsigned long d = extract_digit(3);
        if (d != extract_digit(4))
            continue;
        line[col++] = (char)('0' + d);
        i++;
        if (col == 10 || i == n) {
            while (col < 10)
                line[col++] = ' ';
            line[10] = 0;
            printf("%s\t:%d\n", line, i);
            col = 0;
        }
        eliminate_digit(d);
    }
    return 0;
}
