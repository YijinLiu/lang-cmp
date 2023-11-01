// 417348878 ns used to find 7584 Ulam numbers.

#define _POSIX_C_SOURCE 200809L

#include <inttypes.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef struct UlamVec {
    int size;
    int capacity;
    int64_t* ulam_numbers;
    int64_t* elapsed_ns_list;
} UlamVec;

static bool is_ulam_number(UlamVec* vec, int64_t num) {
    int i = 0, j = vec->size - 1;
    bool fnd = false;
    while (i < j) {
        const int64_t sum = vec->ulam_numbers[i] + vec->ulam_numbers[j];
        if (sum == num) {
            if (fnd) return false;
            fnd = true;
            i++;
            j--;
        } else if (sum < num) {
            i++;
        } else {
            j--;
        }
    }
    return fnd;
}

static void add_ulam_number(UlamVec* vec, int64_t num, int64_t elapsed_ns) {
    if (vec->size == vec->capacity) {
        if (vec->capacity == 0) {
            vec->capacity = 16;
        } else {
            vec->capacity *= 2;
        }
        vec->ulam_numbers = realloc(vec->ulam_numbers, vec->capacity * sizeof(int64_t));
        vec->elapsed_ns_list = realloc(vec->elapsed_ns_list, vec->capacity * sizeof(int64_t));
    }
    vec->ulam_numbers[vec->size] = num;
    vec->elapsed_ns_list[vec->size] = elapsed_ns;
    vec->size++;
}

int main(int argc, char* argv[]) {
    UlamVec vec = {.size = 0, .capacity = 0, .ulam_numbers = NULL, .elapsed_ns_list = NULL};
    add_ulam_number(&vec, 1, 0);
    add_ulam_number(&vec, 2, 0);
    int64_t total_elapsed_ns = 0;
    struct timespec start = {0, 0};
    clock_gettime(CLOCK_MONOTONIC, &start);
    for (int64_t i = 3; i <= 100000ll; i++) {
        int64_t elapsed_ns = 0;
        if (is_ulam_number(&vec, i)) {
            struct timespec end = {0, 0};
            clock_gettime(CLOCK_MONOTONIC, &end);
            const int64_t elapsed_ns = (end.tv_sec - start.tv_sec) * 1000000000 +
                end.tv_nsec - start.tv_nsec;
            printf("%" PRId64 " ns used to find Ulam number %" PRId64 ".\n", elapsed_ns, i);
            total_elapsed_ns += elapsed_ns;
            clock_gettime(CLOCK_MONOTONIC, &start);
            add_ulam_number(&vec, i, elapsed_ns);
        }
    }
    printf("%" PRId64 " ns used to find %d Ulam numbers.\n", total_elapsed_ns, vec.size);

    return 0;
}
