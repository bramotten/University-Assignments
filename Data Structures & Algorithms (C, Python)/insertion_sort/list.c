#include <stdio.h>
#include <stdlib.h>

#include "list.h"

/* Handle to list data structure. */
struct list {
    int n_nodes;
    struct node *head, *tail;
};

/* Handle to list node. */
struct node {
    int value;
    struct node *next_node;
};

/* Initialise a linked list and return a pointer to it.
 * Return NULL on failure. */
struct list *list_init() {
    struct list *l = malloc(sizeof(struct list));
    l->n_nodes = 0;
    l->head = l->tail = NULL;
    return l;
}

/* Cleanup linked list data structure.
 * Return 0 if succesful, 1 otherwise. */
int list_cleanup(struct list *l) {
    if (l) {
        // Iterate towards head from tail.
        struct node *current_head = l->head;
        int i = 0;
        while (current_head != NULL) {
            i++;
            struct node *temp = list_next(current_head);
            list_free_node(current_head);
            current_head = temp;
        }

        int bad = list_length(l) != i;
        free(l);
        if (bad) {
            return 1;
        }
        return 0;
    }
    return 1;
}

/* Return a pointer to a new list node that contains the
 * number num. Return NULL on failure. */
struct node *list_new_node(int num) {
    struct node *n = malloc(sizeof(struct node));
    n->next_node = NULL;
    n->value = num;
    return n;
}

/* Add item to the front of the list.
 * Return 0 if succesful, 1 otherwise. */
int list_add(struct list *l, int num) {
    if (l) {
        struct node *n = list_new_node(num);

        // Check if this is l's first node.
        if (l->tail == NULL)
            l->tail = n;

        n->next_node = l->head;
        l->head = n;
        l->n_nodes++;
        return 0;
    }
    return 1;
}

/* Add item to the back of the list.
 * Return 0 if succesful, 1 otherwise. */
int list_add_back(struct list *l, int num) {
    if (l) {
        struct node *n = list_new_node(num);
        if (l->head == NULL)
            l->head = n;
        if (l->tail != NULL)
            l->tail->next_node = n;
        l->tail = n;
        l->n_nodes++;
        return 0;
    }
    return 1;
}

/* Return the first node of the list or NULL is list is empty. */
struct node *list_head(struct list *l) {
    if (l) {
        return l->head;
    }
    return NULL;
}

/* Return the last node of the list or NULL is list is empty. */
struct node *list_tail(struct list *l) {
    if (l) {
        return l->tail;
    }
    return NULL;
}

/* Return list length. */
int list_length(struct list *l) {
    if (l)
        return l->n_nodes;
    return 0;
}

/* Return the data element of the list node. */
int list_node_data(struct node *n) {
    return n->value;
}

/* Return a pointer to the next node in the list or NULL if
 * 'n' is the last node in the list. */
struct node *list_next(struct node *n) {
    if (n)
        return n->next_node;
    return NULL; // error, actually
}

/* Return a pointer to the previous node in the list l or NULL if
 * 'n' is the first node in the list. */
struct node *list_prev(struct list *l, struct node *n) {
    if (l) {
        // This feels pretty stupid, look from an end until finding n.
        struct node *previous = NULL; // to deal with n being and end already.
        struct node *maybe_n = l->head;
        while (maybe_n != n) {
            previous = maybe_n;
            maybe_n = list_next(previous);
            if (maybe_n == NULL) // reached head without finding n.
                return NULL;     // error
        }
        return previous;
    }
    return NULL; // error
}

/* Unlink node n from list l.
 * Return 0 if n was succesfully removed from list l,
 * return 1 if an error unoccured during unlinking. */
int list_unlink_node(struct list *l, struct node *n) {
    if (n == NULL || l == NULL)
        return 1;

    // Replace previous's pointer if it exists.
    struct node *np = list_prev(l, n);
    if (np != NULL) {
        np->next_node = list_next(n); // can be NULL
    } else if (n != l->head) {
        return 1;
    }

    // Make a new head or tail if this was it.
    if (l->head == n)
        l->head = n->next_node;
    if (l->tail == n)
        l->tail = np;

    n->next_node = NULL;

    l->n_nodes--;
    return 0;
}

/* Free node n. */
void list_free_node(struct node *n) {
    if (n)
        free(n);
}

/* Insert node n after node m in list l. Node n must already be unlinked.
 * Return 0 if n was succesfully inserted, 1 otherwise.  */
int list_insert_after(struct list *l, struct node *n, struct node *m) {
    if (n == NULL || l == NULL)
        return 1;

    if (m != NULL) {
        // Update previous pointers or become tail.
        if (list_next(m) != NULL)
            n->next_node = list_next(m);
        else
            l->tail = n;
        m->next_node = n; // order is sort of important.
    } else
        l->tail = n;

    l->n_nodes++;
    return 0;
}

/* Insert node n before node m in list l. Node n must already be unlinked.
 * Return 0 if n was succesfully inserted, 1 otherwise.  */
int list_insert_before(struct list *l, struct node *n, struct node *m) {
    if (n == NULL || l == NULL)
        return 1;

    // n was not unlinked.
    if (list_prev(l, n) != NULL) {
        return 1;
    }

    n->next_node = m;

    // Update prev pointer.
    struct node *mp = list_prev(l, m);
    if (m != NULL && mp != NULL)
        mp->next_node = n;
    else
        l->head = n;

    l->n_nodes++;
    return 0;
}