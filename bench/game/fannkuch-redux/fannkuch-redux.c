/* fannkuch-redux: the most pancake flips over all permutations of 0..n-1. */
#include <stdio.h>
#include <stdlib.h>
#ifdef _WIN32
#include <fcntl.h>
#include <io.h>
#endif

static int fannkuch(int n, int *checksum) {
    int perm[16], perm1[16], count[16];
    int max_flips = 0, perm_count = 0, r = n;
    *checksum = 0;
    for (int i = 0; i < n; i++)
        perm1[i] = i;
    for (;;) {
        while (r != 1) {
            count[r - 1] = r;
            r--;
        }
        for (int i = 0; i < n; i++)
            perm[i] = perm1[i];
        int flips = 0;
        int k;
        while ((k = perm[0]) != 0) {
            int k2 = (k + 1) >> 1;
            for (int i = 0; i < k2; i++) {
                int t = perm[i];
                perm[i] = perm[k - i];
                perm[k - i] = t;
            }
            flips++;
        }
        if (flips > max_flips)
            max_flips = flips;
        *checksum += perm_count % 2 == 0 ? flips : -flips;
        for (;;) {
            if (r == n)
                return max_flips;
            int perm0 = perm1[0];
            for (int i = 0; i < r; i++)
                perm1[i] = perm1[i + 1];
            perm1[r] = perm0;
            count[r]--;
            if (count[r] > 0)
                break;
            r++;
        }
        perm_count++;
    }
}

int main(int argc, char **argv) {
#ifdef _WIN32
    _setmode(_fileno(stdout), _O_BINARY);
#endif
    int n = argc > 1 ? atoi(argv[1]) : 7;
    int checksum;
    int max_flips = fannkuch(n, &checksum);
    printf("%d\nPfannkuchen(%d) = %d\n", checksum, n, max_flips);
    return 0;
}
