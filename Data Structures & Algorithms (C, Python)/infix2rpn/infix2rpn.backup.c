#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#include "stack.h"

void stack_check_prints(struct stack *s) {
    for (int i = 0; i < 9; i++) stack_push(s, i);
    for (int i = 0; i < 4; i++) {
        printf("s->top: %d\n", stack_peek(s));
        stack_pop(s);
    }
    for (int i = 0; i < 2; i++) stack_push(s, i);
}

int is_operator(char c) {
    return c == '+' || c == '-' || c == '*' || c == '/';
}

int prec_compare(char a, char b) {
    // Precedence levels:
    // 1 - function (???)
    // 2 - negation
    // 3 - exponentiation (^)
    // 4 - division and multiplication
    // 5 - addition and subtraction

    // TODO

    return 0;
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Nope, use like:%s \"infix_expr\"\n", argv[0]);
        return 1;
    }

    // file:///home/bram/Grive/UvA/DnA/Assignments/infix2rpn/README.pdf
    // make clean && make && echo && ./infix2rpn "3 * (1 + 2)"
    // apt install -y llvm clang clang-format

    struct stack* operators = stack_init();
    if (operators == NULL) return 1;
    // stack_check_prints(operators);

    char *input = argv[1];
    char rpn[STACK_SIZE];
    int n = 0, i = 0;
    char cur_c = input[n];
    while (cur_c != '\0') {
        // https://rosettacode.org/wiki/Parsing/Shunting-yard_algorithm#C
        // https://en.wikipedia.org/wiki/Shunting-yard_algorithm 

        // Push numbers to output.
        if (isdigit(cur_c)) rpn[i++] = cur_c;

        // Push opening parentheses to operators, but remove later.
        else if (cur_c == '(') stack_push(operators, cur_c);

        // Push all operators since opening parentheses.
        else if (cur_c == ')') {
            // TODO: bounds check, only for incorrect input.
            while (stack_peek(operators) != '(') {
                rpn[i++] = (char) stack_peek(operators);
                stack_pop(operators);
            }
            stack_pop(operators); // also pop the '('.
        }

        else if (is_operator(cur_c)) { 
            if (stack_peek(operators) != -1) {
                if ((char) stack_peek(operators) != '(' & prec_compare(cur_c, stack_peek(operators)) <= 0) {
                    rpn[i++] = stack_peek(operators);
                    stack_pop(operators);
                    stack_push(operators, cur_c);
                }
            }
        }
        printf("Peek at out / ops: %c / %c\n", rpn[i], stack_peek(operators));
        cur_c = input[++n];
    }

    while (stack_peek(operators) != -1) {
        rpn[n++] = stack_peek(operators);
        stack_pop(operators);
    }
    
    for (int j = 0; j < i; j++) {
        char c = rpn[j];
        if (!isspace(c) && c != NULL) printf("%c ", c);
    }
    printf("\n");
    stack_cleanup(operators);
    return 0;
}
