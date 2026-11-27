/* membermacro.h -- macros named like a record member or a parameter, but for case. */
#define CHARSET_DIR "charsets/"
#define BUFSIZE 16
#define PORTNO 5432
struct mm_opts {
    char *host;
    char *charset_dir;
    unsigned bufsize;
};
int mm_set(struct mm_opts *o, int bufsize);
int mm_connect(const char *host, int portno);
