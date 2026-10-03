/* geom.h -- a small C library for Chapter 28. */
#ifndef GEOM_H
#define GEOM_H

#define GEOM_VERSION_MAJOR 1

typedef struct geom_point {
    double x, y;
} geom_point;

typedef void (*geom_visit)(const geom_point *p, void *user);

const char *geom_version(void);
double geom_distance(geom_point a, geom_point b);
int geom_centroid(const geom_point *pts, int n, geom_point *out);
void geom_each(const geom_point *pts, int n, geom_visit fn, void *user);

#endif
