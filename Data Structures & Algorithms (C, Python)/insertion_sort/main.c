#include <ctype.h>
#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "list.h"

/* Helper for handling command line arguments. */
struct config {
    // You can ignore these options until/unless you implement the
    // bonus features.

    // Set to 1 if -u is specified, 0 otherwise.
    int remove_duplicates;

    // Set to 1 if -S is specified, 0 otherwise.
    int add_sum;

    // Set to N if -s N is specified, 0 otherwise.
    int select_multiple;

    // Set to N if -x N is specified, 0 otherwise.
    int remove_multiple;

    // Set to N if -h N is specified, 0 otherwise.
    int show_first;

    // Set to N if -t N is specified, 0 otherwise.
    int show_last;

    // Set to 1 if -3 is specified, 0 otherwise.
    int scribble;
};

static int parse_options(struct config *cfg, int argc, char *argv[]);

#define BUF_SIZE 1024
static char buf[BUF_SIZE];

/* Sorts input from stdin, outputs resulting ints,
 * one per newline. */
int main(int argc, char *argv[]) {

    // NOTE I've removed all my own fprintfs to stderr, because I don't know
    // what caused some errors on my previous submission.

    struct config cfg;
    if (parse_options(&cfg, argc, argv) != 0)
        return 1;

    struct list *l = list_init();

    list_add(l, 0); // 1337
    int i_line = 0, number = 0;
    // buf = '\0' on a newline, this while continues until EOF.
    while (fgets(buf, BUF_SIZE, stdin)) {

        // It's a little ambiguous what is meant with a multiple, I take it
        // to mean the line number, indexed 1, 2, 3, etc.
        if (cfg.select_multiple > 0 && (++i_line % cfg.select_multiple) != 0)
            continue;

        if (cfg.remove_multiple > 0 && (++i_line % cfg.remove_multiple) == 0)
            continue;

        int n_input = 0, in_number = 0;
        char current_c = buf[n_input];
        while (current_c != '\0') {

            // Handle previously 'gathered' number
            if (isspace(current_c) && in_number != 0) {
                if (cfg.scribble == 1 &&
                    (number == 51 || number == 69 || number == 42))
                    number = 666;

                // Insert number in l.
                // Start at head, iter until finding something bigger.
                // Might still have to initialize.
                struct node *n = list_head(l); // not NULL since before while.
                // Iterate through until finding a bigger value,
                // or reaching the end of the list.
                while (number > list_node_data(n)) {
                    if (list_next(n) != NULL)
                        n = list_next(n);
                    else
                        break;
                }
                list_insert_before(l, list_new_node(number), n);
                number = 0; // reset
                in_number = 0;
            } else if (isdigit(current_c)) {
                in_number = 1;
                number *= 10; // handle the n-th digit of this base 10 number
                number += ((int)current_c - 48); // ascii 0 == 48
            }
            current_c = buf[++n_input];
        }
    }

    // More ugly off-by-one type errors to deal with an EOF
    // without a newline. Basically just deal with that last number
    // as if the EOF is another space or newline: copy-paste the above.
    struct node *n = list_head(l);
    if (number != 0) {
        while (number > list_node_data(n)) {
            if (list_next(n) != NULL)
                n = list_next(n);
            else
                break;
        }
        list_insert_before(l, list_new_node(number), n);
    }

    // Get rid of the added zero up there.
    n = list_tail(l);
    if (list_node_data(n) == 0) {
        list_unlink_node(l, n);
        list_free_node(n);
    }


    // Iterate from head, print and jumping to next until reaching tail's NULL.
    n = list_head(l);
    if (n == NULL) {
        list_cleanup(l);
        return 0;
    }
    int prev = list_node_data(n) + 1; // so pretty, just has to be different.
    int sum = 0, i_shown = 0, i_not_shown = 0;
    while (n != NULL) {

        // This weird construction is just for show_last: skip
        // however many of the earlier prints.
        // Needs that couple of possibly superflous ops outside of the loop.
        int data = list_node_data(n);
        if (cfg.show_last == 0 || ++i_not_shown >= cfg.show_last) {

            // The whole prev/data thing is for checking current number
            // against the previous one, an ofc not printing it the same.
            if (cfg.remove_duplicates == 0 || data != prev) {
                printf("%d\n", data);
                sum += data;
            }
        }
        prev = data;
        n = list_next(n);

        // This is easier: just stop before completely done.
        if (cfg.show_first > 0 && ++i_shown >= cfg.show_first)
            break;
    }

    if (cfg.add_sum) {
        printf("%d\n", sum);
    }

    list_cleanup(l);
    return 0;
}

/* Parses command line arguments, sets cfg options. */
int parse_options(struct config *cfg, int argc, char *argv[]) {
    memset(cfg, 0, sizeof(struct config));
    int c;
    while ((c = getopt(argc, argv, "uSs:x:h:t:3")) != -1)
        switch (c) {
        case 'u':
            cfg->remove_duplicates = 1;
            break;
        case 'S':
            cfg->add_sum = 1;
            break;
        case '3':
            cfg->scribble = 1;
            break;
        case 's':
            cfg->select_multiple = atoi(optarg);
            break;
        case 'x':
            cfg->remove_multiple = atoi(optarg);
            break;
        case 'h':
            cfg->show_first = atoi(optarg);
            break;
        case 't':
            cfg->show_last = atoi(optarg);
            break;
        default:
            fprintf(stderr, "invalid option: -%c\n", optopt);
            return 1;
        }
    if (cfg->show_first != 0 && cfg->show_last != 0) {
        fprintf(stderr, "cannot specify both -h and -t\n");
        return 1;
    }
    return 0;
}
