/* vendor/miniaudio: a target's real pthread type sizes, which prepare.py writes into the header
   c2t translates -- compile and run it ON the target (clang pthread-sizes.c && ./a.out). */
#include <pthread.h>
#include <stdio.h>
int main(void) {
    printf("pthread_t %zu/%zu mutex %zu/%zu cond %zu/%zu\n", sizeof(pthread_t), _Alignof(pthread_t),
           sizeof(pthread_mutex_t), _Alignof(pthread_mutex_t), sizeof(pthread_cond_t), _Alignof(pthread_cond_t));
    return 0;
}
