/* spectral-norm: the spectral norm of an infinite matrix, by the power method. */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#ifdef _WIN32
#include <fcntl.h>
#include <io.h>
#endif

static double a(int i, int j) {
    return 1.0 / ((i + j) * (i + j + 1) / 2 + i + 1);
}

static void mult_av(int n, const double *v, double *av) {
    for (int i = 0; i < n; i++) {
        double sum = 0.0;
        for (int j = 0; j < n; j++)
            sum += a(i, j) * v[j];
        av[i] = sum;
    }
}

static void mult_atv(int n, const double *v, double *atv) {
    for (int i = 0; i < n; i++) {
        double sum = 0.0;
        for (int j = 0; j < n; j++)
            sum += a(j, i) * v[j];
        atv[i] = sum;
    }
}

static void mult_atav(int n, const double *v, double *atav, double *tmp) {
    mult_av(n, v, tmp);
    mult_atv(n, tmp, atav);
}

int main(int argc, char **argv) {
#ifdef _WIN32
    _setmode(_fileno(stdout), _O_BINARY);
#endif
    int n = argc > 1 ? atoi(argv[1]) : 100;
    double *u = malloc(n * sizeof(double));
    double *v = malloc(n * sizeof(double));
    double *tmp = malloc(n * sizeof(double));
    for (int i = 0; i < n; i++)
        u[i] = 1.0;
    for (int i = 0; i < 10; i++) {
        mult_atav(n, u, v, tmp);
        mult_atav(n, v, u, tmp);
    }
    double vbv = 0.0, vv = 0.0;
    for (int i = 0; i < n; i++) {
        vbv += u[i] * v[i];
        vv += v[i] * v[i];
    }
    printf("%.9f\n", sqrt(vbv / vv));
    free(u);
    free(v);
    free(tmp);
    return 0;
}
