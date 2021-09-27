// C++ assignment 4: large numbers, May 2017.
// Bram Otten, bram.otten@student.uva.nl, student ID 10992456.

// g++ --std=c++98 -g -Wall -Werror -pedantic -LargeNumber.cpp && ./a.out 10000
// 10000 takes about 2 seconds on an i7 6700HQ.

#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <sstream>
#include <string>
#include <math.h>

using namespace std;

#define SIZE 4
#define MAX pow(10, SIZE - 1) - 1
#define ONE pow(10, SIZE - 2)

// This Number class is only useful as a parent.
class Number {
public:
    Number() {};

    Number(string s) {};

    virtual ~Number() {};

    virtual Number *factoryMethod(string s) const = 0;

    virtual Number *factoryMethod(int n) const = 0;

    virtual bool operator==(const Number &n) const = 0;

    virtual bool operator!=(const Number &n) const { return !((*this) == n); }

    virtual Number &operator++() = 0;

    virtual Number *operator+(const Number &n) const = 0;

    virtual Number *operator*(const Number &n) const = 0;

    friend std::ostream &operator<<(std::ostream &os, const Number &n);

protected:
    virtual void print(std::ostream &os) const = 0;
};

// This enables "cout<<Number("123");" type printing.
ostream &operator<<(ostream &os, const Number &n) {
    n.print(os);
    return os;
}

class Math {
public:
    static Number *fibonacci(const Number &n) {
        Number *fib0 = n.factoryMethod(0);
        if (n == *fib0) return fib0;
        Number *fib1 = n.factoryMethod(1);
        if (n == *fib1) {
            delete fib0;
            return fib1;
        }
        Number *result = NULL;
        Number *i = n.factoryMethod(1);
        for (; (*i) != n; ++(*i)) {
            result = (*fib0) + (*fib1);
            delete fib0;
            fib0 = fib1;
            fib1 = result;
        }
        delete i;
        delete fib0;
        return result;
    }

    static Number *factorial(const Number &n) {
        Number *result = n.factoryMethod(1);
        Number *i = n.factoryMethod(0);
        if ((*i) != n) {
            ++(*i);
            while ((*i) != n) {
                ++(*i);
                Number *temp = result;
                result = (*result) * (*i);
                delete temp;
            }
        }
        delete i;
        return result;
    }
};

// Used in the double linked list.
struct node {
    int data;
    node *next, *prev;
};

// This prepend function outside of the class to allow
// for non-this list operations.
static node *prepend(node *n, int i) {
    node *content = new node;
    content->data = i;
    n->prev = content;
    content->next = n;
    content->prev = NULL;
    return content;
}

class LargeNumber : public Number {
public:
    LargeNumber() { head = tail = NULL; }

    // Allow using ints internally.
    LargeNumber(int n) {
        if (n > MAX) cerr << "Number too large (shouldn't ever happen).\n";
        head = tail = NULL;
        appendNode(n);
    }

    // Or the less intuitive strings like from argv[1].
    LargeNumber(string s) {
        head = tail = NULL;
        unsigned int n = s.length();

        // Create new nodes starting from the tail.
        while (n >= SIZE) {
            prependNode(atoi(s.substr(n - SIZE, SIZE).c_str()));
            n -= SIZE;
        }

        // Dealing with left-overs.
        if (n > 0) prependNode(atoi(s.substr(0, n).c_str()));
    }

    virtual ~LargeNumber() {
        // Delete everything in the list.
        while (head) {
            node *n = head;
            head = head->next;
            delete n;
        }
    }

    virtual Number *factoryMethod(int n) const { return new LargeNumber(n); }

    virtual Number *factoryMethod(string s) const { return new LargeNumber(s); }

    virtual bool operator==(const Number &n) const {
        const LargeNumber &sn = static_cast<const LargeNumber &>(n);

        // Iterate over nodes, stop if they're different.
        node *here = head;
        node *there = sn.head;
        while (here != NULL && there != NULL) {
            if (here->data != there->data) return false;
            here = here->next;
            there = there->next;
        }

        // All the NULL checking is so that uneven lengths don't get through.
        return (here == NULL && there == NULL);
    }

    virtual Number &operator++() {
        node *n = tail;
        int temp = n->data + 1;

        // 9999 becomes 1-0000.
        if (temp > MAX) {
            n->data = 0;
            if (n->prev == NULL) {
                prependNode(1);
                return *this;
            } else {
                n = n->prev;
                temp = n->data + 1;
            }
        }

        n->data = temp;
        return *this;
    }

    // TODO: more comments!!! (Also in *)

    virtual Number *operator+(const Number &n) const {
        LargeNumber *result = new LargeNumber(0);
        const LargeNumber &sn = static_cast<const LargeNumber &>(n);
        int temp = 0, leftover = 0;
        node *here = tail, *there = sn.tail, *rest = NULL;

        while (here != NULL && there != NULL) {
            temp = here->data + there->data + leftover;
            if (temp > MAX) {
                temp = temp - 10 * ONE;
                leftover = 1;
            } else
                leftover = 0;

            if (rest == NULL) {
                rest = result->head;
                rest->data = temp;
            } else
                rest = prepend(rest, temp);

            here = here->prev;
            there = there->prev;
        }

        if (there != NULL) here = there;

        while (here != NULL) {
            temp = here->data + leftover;
            if (temp > MAX) {
                temp = temp - 10 * ONE;
                leftover = 1;
            } else
                leftover = 0;
            rest = prepend(rest, temp);
            here = here->prev;
        }

        if (leftover == 1) rest = prepend(rest, leftover);
        result->head = rest;
        return result;
    }

    virtual Number *operator*(const Number &n) const {
        Number *total = factoryMethod(0);
        const LargeNumber &sn = static_cast<const LargeNumber &>(n);
        int temp = 0, more = 0, now = 0, leftover = 0, step = 0, i;
        node *two = sn.tail;

        while (two != NULL) {
            step += 1;
            now = two->data;
            if (now != 0) {
                LargeNumber *result = new LargeNumber(0);
                node *r = NULL;

                for (i = 1; i < step; i++)
                    r == NULL ? r = result->head : r = prepend(r, 0);

                leftover = 0;
                node *one = tail;
                while (one != NULL) {
                    temp = one->data * now + leftover;

                    if (temp > MAX) {
                        more = temp % (10 * (int) ONE);
                        leftover = (temp - more) / (10 * (int) ONE);
                        temp = more;
                    } else
                        leftover = 0;

                    if (r == NULL) {
                        r = result->head;
                        r->data = temp;
                    } else
                        r = prepend(r, temp);

                    one = one->prev;
                }
                while (leftover > 0) {
                    temp = leftover;

                    if (temp > MAX) {
                        more = temp % 10 * ONE;
                        leftover = (temp - more) / 10 * ONE;
                        temp = more;
                    } else {
                        temp = leftover;
                        leftover = 0;
                    }

                    r = prepend(r, temp);
                }
                result->head = r;
                Number *classytotal = total;
                total = (*classytotal) + (*result);
                delete classytotal;
                delete result;
            }

            two = two->prev;
        }

        return total;
    }

protected:
    virtual void print(std::ostream &os) const {
        node *temp = head;
        while (temp != NULL) {
            if (temp == head)
                cout << temp->data;
            else {
                stringstream formatstream;
                formatstream << "%0" << SIZE << "i";
                const char *format = formatstream.str().c_str();
                printf(format, temp->data);
            }
            temp = temp->next;
        }
    }

private:
    node *head;
    node *tail;

    node *appendNode(int n) {
        node *content = new node;
        content->data = n;
        content->prev = tail;
        content->next = NULL;
        if (tail == NULL)
            head = content;
        else
            tail->next = content;
        tail = content;
        return content;
    }

    node *prependNode(int n) {
        node *content = new node;
        content->data = n;
        content->prev = NULL;
        content->next = head;
        if (head == NULL)
            tail = content;
        else
            head->prev = content;
        head = content;
        return content;
    }
};

int main(int argc, char **argv) {
    if (argc < 2) {
        cout << "Computes the n-th fibonacci and factorial." << endl;
        cout << "usage: " << argv[0] << " <n>" << endl;
        exit(0);
    }

    LargeNumber m(argv[1]);

    Number *fibo = Math::fibonacci(m);
    cout << "fibonacci(" << m << ") = " << *fibo << endl;
    delete fibo;

    Number *fact = Math::factorial(m);
    cout << "factorial(" << m << ") = " << *fact << endl;
    delete fact;

    return 0;
}
