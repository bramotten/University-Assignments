#include <stdlib.h>
#include <stdio.h>

#include "stack.h"

struct stack {
    int items[STACK_SIZE];
    int top;
    int n_pushes;
    int n_pops;
    int max_top;
};

struct stack *stack_init() {
    struct stack *s = malloc(sizeof(struct stack));
    s->top = s->max_top = s->n_pushes = s->n_pops = 0;
    return s; // malloc returns NULL if it should.
}

void stack_cleanup(struct stack* s) {
    fprintf(stderr, "stats %d %d %d\n", s->n_pushes, s->n_pops, s->max_top);
    free(s);
}

int stack_push(struct stack *s, int c) {
    // Without an overflow, fill in c and move the pointer on.
    if (s->top >= STACK_SIZE) {
        fprintf(stderr, "Overflow while pushing.\n");
        return 1;
    }
    s->items[s->top++] = c;
    s->n_pushes++;
    // Update stats.
    if (s->top > s->max_top) s->max_top = s->top;
    return 0;    
}

int stack_pop(struct stack *s) {
    // Check or underflow this time.
    if (stack_empty(s) == 1) {
        fprintf(stderr, "Underflow while popping.\n");
        return -1;
    }
    // items[top] is not yet,
    // so iterate down first. Then
    // return the top value.
    s->n_pops++;
    return s->items[--s->top];
}

int stack_peek(struct stack *s) {
    if (stack_empty(s) == 1) return -1;
    return s->items[s->top - 1];
}

int stack_empty(struct stack *s) {
    if (s->n_pushes <= s->n_pops) return 1;
    return 0;
}
