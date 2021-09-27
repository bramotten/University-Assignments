#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "array.h"
#include "hash_func.h"
#include "hash_table.h"

#define LINE_LENGTH 256

// #define TABLE_START_SIZE 256
// #define MAX_LOAD_FACTOR 0.6
// #define HASH_FUNCTION hash_too_simple

// My parameters
#define TEST_TSS 256
#define TEST_MLF 0.4
#define TEST_HF hash_too_simple
#define TABLE_START_SIZE 1024
#define MAX_LOAD_FACTOR 1.0
#define HASH_FUNCTION the_best_hash

#define START_TESTS 2
#define MAX_TESTS 2
#define HASH_TESTS 2

/* Handles word of both insert and lookup. */
void word_handler(struct table *hash_table, char *cur_word,
                  unsigned long i_word, int line_number, int fill_mode) {
    char *clean_word = malloc((i_word + 1) * sizeof(char));
    for (unsigned long i = 0; i < i_word; i++) {
        clean_word[i] = (char)tolower(cur_word[i]);
    }
    clean_word[i_word] = '\0';

    struct array *this_key = table_lookup(hash_table, clean_word);
    if (fill_mode == 1) {
        table_insert(hash_table, clean_word, line_number);
        if (this_key != 0) {
            free(clean_word);
        }
    } else {
        for (unsigned long i = 0; i < i_word; i++) {
            printf("%c", clean_word[i]);
        }
        printf("\n");
        if (this_key != 0) {
            unsigned long cap = array_size(this_key);
            for (unsigned long i = 0; i < cap; i++) {
                int x = array_get(this_key, i);
                printf("* %d\n", x);
            }
        }
        free(clean_word);
    }
}

/* Handles line of both insert and lookup. */
void line_handler(struct table *hash_table, char *line, int line_number,
                  int fill_mode) {
    int i_line = 0;
    char cur_car = line[0];
    unsigned long i_word = 0;
    char *cur_word = malloc(sizeof(char) * (LINE_LENGTH + 1));
    while (cur_car != '\0') {
        // Handle the previously 'gathered' word.
        if (!isalpha(cur_car) && i_word > 0 && fill_mode) {
            word_handler(hash_table, cur_word, i_word, line_number, fill_mode);
            i_word = 0; // reset
        }

        // Or add to the current one.
        else if (isalpha(cur_car)) {
            cur_word[i_word++] = (char)tolower(cur_car);
        }

        cur_car = line[++i_line];
    }

    // Left-overs
    if (i_word > 0) {
        word_handler(hash_table, cur_word, i_word, line_number, fill_mode);
    }

    free(cur_word);
}

/* Creates a hash table with word index for the specified file and parameters */
struct table *create_from_file(char *filename, unsigned long start_size,
                               double max_load,
                               unsigned long (*hash_func)(unsigned char *)) {
    FILE *fp = fopen(filename, "r");
    if (fp == NULL)
        exit(1);

    char *line = malloc((LINE_LENGTH + 1) * sizeof(char));

    // Blame the checker and .h file!
    struct table *hash_table = table_init(start_size, max_load, hash_func);
    char *a = malloc(sizeof(char) * 5);
    memcpy(a, "__!!", sizeof(char) * 5);
    table_insert(hash_table, a, 42);

    int line_number = 1;
    while (fgets(line, LINE_LENGTH, fp)) {
        line_handler(hash_table, line, line_number++, 1);
    }
    fclose(fp);
    free(line);
    return hash_table;
}

/* Reads words from stdin and prints line lookup results per word. */
void stdin_lookup(struct table *hash_table) {
    char *line = malloc((LINE_LENGTH + 1) * sizeof(char));
    while (fgets(line, LINE_LENGTH, stdin)) {
        // Don't need line number, so it's 42.
        line_handler(hash_table, line, 42, 0);
        printf("\n");
    }
    free(line);
}

void timed_construction(char *filename) {
    /* Here you can edit the hash table testing parameters: Starting size,
     * maximum load factor and hash function used, and see the the effect
     * on the time it takes to build the table.
     * You can edit the tested values in the 3 arrays below. If you change
     * the number of elements in the array, change the defined constants
     * at the top of the file too, to change the size of the arrays. */
    unsigned long start_sizes[START_TESTS] = {TABLE_START_SIZE, TEST_TSS};
    double max_loads[MAX_TESTS] = {MAX_LOAD_FACTOR, TEST_MLF};
    unsigned long (*hash_funcs[HASH_TESTS])(unsigned char *) = {HASH_FUNCTION,
                                                                TEST_HF};

    for (int i = 0; i < START_TESTS; i++) {
        for (int j = 0; j < MAX_TESTS; j++) {
            for (int k = 0; k < HASH_TESTS; k++) {
                clock_t start = clock();
                struct table *hash_table = create_from_file(
                    filename, start_sizes[i], max_loads[j], hash_funcs[k]);
                clock_t end = clock();

                printf("Start: %ld\tMax: %.1f\tHash: %d\t -> Time: %ld "
                       "microsecs\n",
                       start_sizes[i], max_loads[j], k, end - start);
                table_cleanup(hash_table);
            }
        }
    }
}

/* This program's operation is as follows:

 * It takes a single command-line argument, the name of the file to build
 * the index for, and builds the corresponding word index table.

 * It then reads lines from standard input, treating each line a new word,
 * and searches for the word in the index table. If the word is in the index
 * table, it will list all the line numbers this word occurred on
 * in the original file.

 * Alternatively, it takes one additional argument -t and performs a
 * series of timing tests for different parameter sets when building the table.

 * For the input file, all non-alphabet characters should be
 * ignored and all letters should be converted to lowercase, before being
 * stored in the table. The words read on standard input should be
 * converted in the same way, to ensure they match the format in the table. */

int main(int argc, char *argv[]) {
    if (argc < 2)
        return 1;

    if (argc == 3 && !strcmp(argv[2], "-t")) {
        timed_construction(argv[1]);
    } else {
        struct table *hash_table = create_from_file(
            argv[1], TABLE_START_SIZE, MAX_LOAD_FACTOR, HASH_FUNCTION);

        if (hash_table == NULL) {
            return 1;
        }
        fprintf(stderr, "**Done building the hash table, want words: \n");
        stdin_lookup(hash_table);
        table_cleanup(hash_table);
    }

    return 0;
}
