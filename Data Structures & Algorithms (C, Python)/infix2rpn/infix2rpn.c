#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#include "stack.h"

void stack_test(struct stack *s) {
    for (int i = 0; i < 50; i++) stack_push(s, i);
    for (int i = 0; i < 40; i++) {
        printf("s->top: %d\n", stack_peek(s));
        stack_pop(s);
    }
    for (int i = 0; i < 2; i++) stack_push(s, i);
    printf("s->top: %d\n", stack_peek(s));
}

int isoperator(char c) { return c == '+' || c == '-' || c == '*' || 
                                c == '/' || c == '^' || c == '~'; }

// Return 1 if higher precedence or equal and left-associative.
int precedence(char a, char b) {

    // Precedence levels:
    // 1 - function (handling somewhere else)
    // 2 - negation
    // 3 - exponentiation (^)
    // 4 - division and multiplication
    // 5 - addition and subtraction

    if (a == '~') return 1;
    if (b == '~') return -1;
    if (a == '^') return 1;
    if (b == '^') return -1;
    if (a == '*' || a == '/') return 1;
    if (b == '*' || b == '/') return -1;
    return 1;
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Nope, use like:%s \"infix_expr\"\n", argv[0]);
        return 1;
    }

    char *input = argv[1];
    int n_input = 0;
    while (input[n_input++] != '\0') {}
    char output[n_input * 2]; // including room for spaces.
    
    struct stack* s = stack_init();
    if (s == NULL) {
        free(s);
        return 1;
    }

    bool prev_digit = false;

    int i_input = 0, i_output = 0;
    while (i_input < n_input) {
        
        char c = input[i_input++];
        while (isspace(c)) c = input[i_input++]; // 4 2 = 42

        if (isdigit(c)) {
            if (prev_digit) i_output--;

            while (isdigit(c)) {
                output[i_output++] = c;
                c = input[i_input++];
            }
            output[i_output++] = ' ';
            i_input--; // because of the ++ in the while
            prev_digit = true;
        }
        
        else if (isoperator(c)) {
            
            // Yep, this is ugly.
            prev_digit = false;
            if (c == '~') {
                stack_push(s, c);
                continue;
            }

            char o = (char) stack_peek(s);
            while ((int) o != -1 && precedence(o, c) == 1 && o != '(') {
                output[i_output++] = o;
                output[i_output++] = ' ';
                stack_pop(s);
                o = (char) stack_peek(s);
            }
            stack_push(s, c);
        }

        else if (c == '(') stack_push(s, c);

        else if (c == ')') {
            char o = (char) stack_peek(s);
            while ((int) o != -1 && o != '(') {
                output[i_output++] = o;
                output[i_output++] = ' ';
                prev_digit = false;
                stack_pop(s);
                o = (char) stack_peek(s);
            }
            if ((int) o == -1) {
                fprintf(stderr, "Mismatched parentheses!\n");
                stack_cleanup(s);
                return 1;
            }
            stack_pop(s); // the left bracket.
        }

        else if (isalpha(c)) {
            // stack_push(s, c);
            output[i_output++] = c;
            output[i_output++] = ' ';
            prev_digit = false;
        }

        else {} // ignoring character.
    }

    while ((int) (char) stack_peek(s) != -1) {
        if ((char) stack_peek(s) == '(') {
            fprintf(stderr, "Mismatched parentheses!\n");
            stack_cleanup(s);
            return 1;
        }
        output[i_output++] = (char) stack_peek(s);
        output[i_output++] = ' ';
        stack_pop(s);
    }
    output[i_output] = '\0';

    for (int i = 0; i < i_output - 1; i++) printf("%c", output[i]);
    printf("\n");
    stack_cleanup(s);
    return 0;
}
