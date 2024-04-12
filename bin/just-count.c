#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char** argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s N\nCount from 0 to 2**N-1\n", argv[0]);
        return 1;
    }

    clock_t start = clock();

    size_t count = 1ull << atoi(argv[1]);
    for (unsigned long long i = 0; i < count; i += 1) {
        __asm__("nop");
    }

    double timing = (double) (clock() - start) / CLOCKS_PER_SEC;
    printf("I counted from 0 to %zu in %gs\n", count - 1, timing);

    return 0;
}
