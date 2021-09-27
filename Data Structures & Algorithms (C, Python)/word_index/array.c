#include <stdio.h>
#include <stdlib.h>

#include "array.h"

/* Resizing array interface
 * Specialized for integers. */

/* Handle to array data structure. */
struct array {
    int *data;
    unsigned long i, n;
};

/* Initialise an array and return a pointer to it.
 * Return NULL on failure. */
struct array *array_init(unsigned long initial_capacity) {
    struct array *a = malloc(sizeof(struct array));
    a->data = malloc(initial_capacity * sizeof(int));
    a->n = initial_capacity;
    a->i = 0;
    return a;
}

/* Cleanup array data structure. */
void array_cleanup(struct array *a) {
    if (a && a->data) {
        free(a->data); // the only pointer.
        free(a);
    }
}

/* Return the element at the index position in the array.
 * Return -1 if the index is not a valid position in the array. */
int array_get(struct array *a, unsigned long index) {
    if (a != NULL && index <= a->i) { // unsigned so no >= 0
        return a->data[index];
    }
    return -1;
}

/* Add the element at the end of the array.
 * Return 0 if succesful, 1 otherwise. */
/* Note: Although this operation might require the array to be resized and
 * copied, in order to make room for the added element, it is possible to do
 * this in such a way that the amortized complexity is still O(1).
 * Make sure your code is implemented in such a way to guarantee this. */
int array_append(struct array *a, int elem) {
    if (a) { // can't check a->i, it can be 0.
        // We may have to resize
        if (a->i >= array_size(a)) {
            a->n += 32; // make room for 32 elements at once because why not
            a->data = realloc(a->data, a->n * sizeof(int));
        }
        a->data[a->i++] = elem;
        return 0;
    }
    return 1;
}

/* Return the number of elements in the array */
unsigned long array_size(struct array *a) {
    if (a && a->n) {
        return a->i;
    }
    return 0;
}
