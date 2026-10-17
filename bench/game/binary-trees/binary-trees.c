/* binary-trees: allocate, walk and free many perfect binary trees. */
#include <stdio.h>
#include <stdlib.h>
#ifdef _WIN32
#include <fcntl.h>
#include <io.h>
#endif

typedef struct Node { struct Node *left, *right; } Node;

static Node *bottom_up(int depth) {
    Node *t = malloc(sizeof(Node));
    if (depth > 0) {
        t->left = bottom_up(depth - 1);
        t->right = bottom_up(depth - 1);
    } else {
        t->left = t->right = NULL;
    }
    return t;
}

static int check(const Node *t) {
    if (t->left == NULL)
        return 1;
    return 1 + check(t->left) + check(t->right);
}

static void delete_tree(Node *t) {
    if (t->left != NULL) {
        delete_tree(t->left);
        delete_tree(t->right);
    }
    free(t);
}

int main(int argc, char **argv) {
#ifdef _WIN32
    _setmode(_fileno(stdout), _O_BINARY);
#endif
    int n = argc > 1 ? atoi(argv[1]) : 10;
    int min_depth = 4;
    int max_depth = n > min_depth + 2 ? n : min_depth + 2;
    int stretch = max_depth + 1;

    Node *t = bottom_up(stretch);
    printf("stretch tree of depth %d\t check: %d\n", stretch, check(t));
    delete_tree(t);

    Node *long_lived = bottom_up(max_depth);
    for (int depth = min_depth; depth <= max_depth; depth += 2) {
        int iterations = 1 << (max_depth - depth + min_depth);
        int sum = 0;
        for (int i = 0; i < iterations; i++) {
            t = bottom_up(depth);
            sum += check(t);
            delete_tree(t);
        }
        printf("%d\t trees of depth %d\t check: %d\n", iterations, depth, sum);
    }
    printf("long lived tree of depth %d\t check: %d\n", max_depth, check(long_lived));
    delete_tree(long_lived);
    return 0;
}
