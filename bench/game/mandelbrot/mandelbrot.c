/* mandelbrot: the Mandelbrot set as a 1-bit portable bitmap. */
#include <stdio.h>
#include <stdlib.h>
#ifdef _WIN32
#include <fcntl.h>
#include <io.h>
#endif

int main(int argc, char **argv) {
#ifdef _WIN32
    _setmode(_fileno(stdout), _O_BINARY);
#endif
    int n = argc > 1 ? atoi(argv[1]) : 200;
    int w = n, h = n;
    int row_bytes = (w + 7) / 8;
    unsigned char *out = malloc((size_t)row_bytes * h);
    unsigned char *p = out;
    for (int y = 0; y < h; y++) {
        double ci = 2.0 * y / h - 1.0;
        int byte = 0, bits = 0;
        for (int x = 0; x < w; x++) {
            double cr = 2.0 * x / w - 1.5;
            double zr = 0.0, zi = 0.0, tr = 0.0, ti = 0.0;
            int i = 0;
            while (i < 50 && tr + ti <= 4.0) {
                zi = (zr + zr) * zi + ci;
                zr = tr - ti + cr;
                tr = zr * zr;
                ti = zi * zi;
                i++;
            }
            byte = (byte << 1) | (tr + ti <= 4.0);
            bits++;
            if (bits == 8) {
                *p++ = (unsigned char)byte;
                byte = 0;
                bits = 0;
            }
        }
        if (bits)
            *p++ = (unsigned char)(byte << (8 - bits));
    }
    printf("P4\n%d %d\n", w, h);
    fwrite(out, 1, p - out, stdout);
    free(out);
    return 0;
}
