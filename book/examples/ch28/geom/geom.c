/* geom.c -- a small C library for Chapter 28. Built by build.sh. */
#include <math.h>
#include "geom.h"

const char *geom_version(void) { return "geom 1.0"; }

double geom_distance(geom_point a, geom_point b) {
    return sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y));
}

int geom_centroid(const geom_point *pts, int n, geom_point *out) {
    double sx = 0, sy = 0;
    if (n <= 0) return 0;
    for (int i = 0; i < n; i++) { sx += pts[i].x; sy += pts[i].y; }
    out->x = sx / n;
    out->y = sy / n;
    return 1;
}

void geom_each(const geom_point *pts, int n, geom_visit fn, void *user) {
    for (int i = 0; i < n; i++) fn(&pts[i], user);
}
