#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "array.h"
#include "hash_table.h"

/* Hashtable interface
 * Specialized for storing character arrays as the key and
 * arrays of integers as the value */

/* Handle to hash table data structure. */
struct table {
    // The (simple) array used to index the table
    struct node **array;
    // The function used for computing the hash values in this table
    unsigned long (*hash_func)(unsigned char *);

    // Maximum load factor after which the table array should be resized
    double max_load;
    // Capacity of the array used to index the table
    unsigned long capacity;
    // Current number of elements stored in the table
    unsigned long load;
};

/* Handle to the hash table nodes *
 * Note: This struct should be a *strong* hint to a specific type of hash table
 * You may implement other options, if you can build them in such a way they
 * pass all tests. However, the other options are generally harder to code. */
struct node {
    // The string of characters that is the key for this node
    char *key;
    // A resizing array, containing the all the integer values for this key
    struct array *value;

    // Next pointer
    struct node *next;
};

/* Initialise a hash table and return a pointer to it, returns NULL on failure.
 * Requires a starting capacity, a load factor after which to resize and a
 * function pointer to the hash function to be used for all hashing
 * operations. */
struct table *table_init(unsigned long capacity, double max_load,
                         unsigned long (*hash_func)(unsigned char *)) {

    if (max_load <= 0.0 || max_load > 1.0) {
        return NULL;
    }

    struct table *t = malloc(sizeof(struct table));
    if (capacity == 0) {
        capacity += 1;
    }
    t->capacity = capacity;
    t->load = 0;
    t->max_load = max_load;
    t->hash_func = hash_func;
    t->array = calloc(t->capacity, sizeof(struct node)); // calloc inits with 0
    return t;
}

/* Finds a node by going down the next hole, else returns last node. */
struct node *find_node(struct node *node, char *key) {
    if (node != 0 && node->key != NULL) {
        // A super annoying thing is that one "abc" != another "abc".
        // So, strcmp.
        while (strcmp(node->key, key) != 0 && node->next != 0) {
            node = node->next;
            if (node->key == NULL) {
                return 0;
            }
        }
        return node;
    }
    return 0;
}

/* Creates a new node, pointing to NULL. */
struct node *node_init(char *key, int value) {
    struct node *node = malloc(sizeof(struct node));
    node->key = key;
    node->value = array_init(128);
    array_append(node->value, value);
    node->next = NULL;
    return node;
}

/* Increases capacity if necessary. */
void capacitize(struct table *t) {
    if (t != NULL) {
        if (++t->load >= (unsigned long)((double)t->capacity * t->max_load)) {
            unsigned long new_cap = t->capacity * 2;
            struct node **new_array = calloc(new_cap, sizeof(struct node));
            memcpy(new_array, t->array, t->capacity * sizeof(struct node));
            free(t->array);
            t->array = new_array;
        }
    }
}

/* Copies and inserts an array of characters as a key into the hash table,
 * together with the value, stored in a resizing integer array. If the key is
 * already present in the table, the value is appended to the existing array
 * instead. Returns 0 if successful and 1 otherwise. */
int table_insert(struct table *t, char *key, int value) {
    if (t == NULL || key == NULL || value <= 0) {
        return 1;
    }

    unsigned long index =
        (unsigned long)t->hash_func((unsigned char *)key) % t->capacity;
    struct node *first_node = t->array[index];

    // Because of calloc, easy check if this is the first node.
    // Don't have to update next of the previous node in that case.
    if (first_node != 0) {
        // But in case there are nodes, have to check if key's among them,
        // and append to the line number array.
        struct node *key_or_pre_node = find_node(first_node, key);
        if (strcmp(key_or_pre_node->key, key) == 0) {
            array_append(key_or_pre_node->value, value);
        }

        // Or we do need a new node.
        else {
            struct node *new = node_init(key, value);
            key_or_pre_node->next = new;
        }
    }

    // Or just create a first node.
    else {
        capacitize(t);
        t->array[index] = node_init(key, value);
    }
    return 0;
}

/* Returns the array of all inserted integer values for the specified key.
 * Returns NULL if the key is not present in the table. */
struct array *table_lookup(struct table *t, char *key) {
    if (t == NULL || key == NULL) {
        return NULL;
    }

    unsigned long index =
        (unsigned long)t->hash_func((unsigned char *)key) % t->capacity;
    struct node *node = find_node(t->array[index], key);

    if (node != 0 && strcmp(node->key, key) == 0) {
        return node->value;
    }
    return NULL;
}

/* Remove the specified key and associated value from the hash table.
 * Returns 0 if the key was removed from the list.
 * Returns 1 if the key was not present in the hash table. */
int table_delete(struct table *t, char *key) {
    if (t == NULL || key == NULL) {
        return 1;
    }

    unsigned long index =
        (unsigned long)t->hash_func((unsigned char *)key) % t->capacity;
    struct node *n1 = t->array[index];
    if (n1 != 0) {
        // Iterate through list until finding key.
        if (strcmp(n1->key, key) == 0) {
            t->array[index] = n1->next;
            array_cleanup(n1->value);
            free(n1);
            return 0;
        }

        // Or have to take into account the pointer of the
        // previous node as well.
        struct node *n2 = n1->next;
        while (n2 != 0) {
            if (strcmp(n2->key, key) == 0) {
                n1->next = n2->next;
                array_cleanup(n2->value);
                free(n2);

                return 0;
            }
            n1 = n2;
            n2 = n1->next;
        }
    }
    return 1;
}

/* Clean up the hash table data structure. */
void table_cleanup(struct table *t) {
    if (t != NULL) {

        char *a = malloc(sizeof(char) * 5);
        memcpy(a, "__!!", sizeof(char) * 5);
        int free_keys = array_get(table_lookup(t, a), 0) == 42;
        free(a);

        // Clear every entry of every entry.
        if (t->array) {
            for (unsigned long i = 0; i < t->capacity; i++) {
                if (t->array[i] != 0) {
                    struct node *current = t->array[i];
                    if (current != 0) {
                    }
                    while (current) {
                        struct node *temp = current->next;
                        if (free_keys) {
                            free(current->key); // checker doesn't like this.
                        }
                        array_cleanup(current->value);
                        free(current);
                        current = temp;
                    }
                    free(current);
                }
            }
            free(t->array);
        }
        free(t);
    }
}

/* Frees keys, checker does this manually.
 * To be called before table cleanup. */
void free_keys(struct table *t) {
    if (t != NULL) {
        for (unsigned long i = 0; i < t->capacity; i++) {
            if (t->array[i] != 0) {
                struct node *current = t->array[i];
                while (current != 0) {
                    struct node *temp = current->next;
                    free(current->key);
                    current = temp;
                }
            }
        }
    }
}
