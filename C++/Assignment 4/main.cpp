// Bram Otten, May 2017.

// g++ --std=c++98 -g main.cpp && ./a.out 12

#include <stdlib.h>
#include <iostream>
#include <stdio.h>
#include <sstream>

using namespace std;

// TODO: define SIZE, then everything relative to size.
#define SIZE           4
#define MAX         9999
#define ONE         1000
#define REMAINDER      1
#define FORMAT    "%04i"

class Number {

public:

    Number() {};

    Number(string s) { };                                 // constructor based in string representation of number
    virtual ~Number() { };                                // makes destructor virtual
    virtual Number *factoryMethod(string s) const = 0;    // returns new Number object
    virtual Number *factoryMethod(int n) const = 0;       // returns new Number object

    virtual bool operator==(const Number &n) const = 0;   // test for equality
    virtual bool operator!=(const Number &n) const {      // test for inequality
        return !((*this) == n);
    }

    virtual Number &operator++()=0;                       // increment number
    virtual Number *operator+(const Number &n) const = 0; // returns new Number object after addition
    virtual Number *operator*(const Number &n) const = 0; // returns new Number object after multiplication

    friend std::ostream &operator<<(std::ostream &os, const Number &n);

protected:

    virtual void print(std::ostream &os) const = 0;      // prints the number

};

ostream &operator<<(ostream &os, const Number &n) // this enables "cout<<Number("123");" type printing
{
    n.print(os);
    return os;
}

// Math library that computes fibonacci and factorial numbers, uses the Number interface
class Math {

public:

    // compute n-th fibonacci number

    static Number *fibonacci(const Number &n) {
        Number *fib0 = n.factoryMethod(0); // zero-th number is defined
        if (n == *fib0)
            return fib0;
        Number *fib1 = n.factoryMethod(1); // first number is defined
        if (n == *fib1) {
            delete fib0;
            return fib1;
        }
        Number *result = NULL;
        Number *i = n.factoryMethod(1);
        for (; (*i) != n; ++(*i)) // later numbers are computed by adding previous two
        {
            result = (*fib0) + (*fib1); // add
            if (DEBUG)
                cout << "fib(" << *i << "):" << *result << endl;
            delete fib0;
            fib0 = fib1;
            fib1 = result;
        }
        delete i;
        delete fib0;
        return result;
    }

    // compute n-th factorial number

    static Number *factorial(const Number &n) {
        Number *result = n.factoryMethod(1);
        Number *i = n.factoryMethod(0);
        if ((*i) != n) // zero-th number is defined
        {
            ++(*i);
            while ((*i) != n) // later numbers are computed by multiplying by all i from 1 to n
            {
                ++(*i);
                Number *temp = result;
                result = (*result) * (*i); // multiply
                if (DEBUG)
                    cout << "fac(" << *i << "):" << *result << endl;
                delete temp;
            }
        }
        delete i;
        return result;
    }

};

struct node {
    int data;
    node *next, *prev;
};

static node *prepend(node *n,int i) {
    node *content = new node;
    content->data = i;
    n->prev = content;
    content->next = n;
    content->prev = NULL;
    return content;
}

class LargeNumber : public Number {

    LargeNumber() {
        head = NULL;
        tail = NULL;
    }

    LargeNumber(int n) {
        if (n > MAX) {
            cerr < "number too large (only used internally)\n";
        }
        head = NULL;
        tail = NULL;
        appendNode(n);
    }

    LargeNumber(string s) {
        unsigned int n = s.length();
        head = NULL;
        tail = NULL;
        while (n >= SIZE) {
            prependNode(atoi(s.substr(n-SIZE,SIZE).c_str()));
            n -= SIZE;
        }
        if (n > 0) {
            prependNode(atoi(s.substr(0,n).c_str()));
        }
    }

    virtual ~LargeNumber() {
        while (head) {
            node *n = head ;
            head = head->next;
            delete n;
        }
    }

    virtual Number *factoryMethod(int n) const {
        return new LargeNumber(n);
    }

    virtual Number *factoryMethod(string s) const {
        return new LargeNumber(s);
    }

    virtual bool operator==(const Number &n) const {

        const LargeNumber &sn = static_cast<const LargeNumber &>(n);

        // Iterate over nodes, stop if they're different.
        node *here = head;
        node *there = sn.head;
        while (here != NULL && there != NULL) {
            if (here->data != there->data) {
                return false;
            }
            here = here->next;
            there = there->next;
        }
        return (here == NULL && there == NULL);
    }

    virtual Number &operator++() {
        int temp = tail->data + 1 ;
        node *n = tail;
        while (temp > MAX) {
            n->data = 0;
            if (n->prev == NULL) {
                prependNode(1);
                return *this;
            } else {
                n = n->prev ;
                temp = n->data + 1 ;
            }
        }
        n->data = temp;
    }

    virtual Number *operator+(const Number &n) const {
        LargeNumber *result = new LargeNumber(0);
        const LargeNumber &sn = static_cast<const LargeNumber &>(n);
        int temp = 0;
        int more = 0;
        int remainder = 0;
        node *one = tail;
        node *two = sn.tail;
        node *r = NULL;
        while (one != NULL && two != NULL) {
            temp = one->data + two->data + remainder ;
            if (temp > MAX) {
                temp = temp - 10*ONE ;
                remainder = 1 ;
            } else {
                remainder = 0 ;
            }
            if (r == NULL) {
                r = result->head;
                r->data = temp;
            } else {
                r = prepend(r,temp);
            }
            one = one->prev;
            two = two->prev;
        }
        if (two != NULL) {
            one = two ;
        }
        while (one != NULL) {
            temp = one->data + remainder ;
            if (temp > MAX) {
                temp = temp - 10*ONE ;
                remainder = 1 ;
            } else {
                remainder = 0 ;
            }
            r = prepend(r,temp);
            one = one->prev;
        }
        if (remainder == 1) {
            r = prepend(r,remainder);
        }
        result->head = r;
        return result;
    }

    /*
        We can combine result and total but it makes the code even more ugly. A
        variant can be to set all data fields in result to zero and then reuse
        that list.
    */

    virtual Number *operator*(const Number &n) const {
        Number *total = factoryMethod(0) ;
        const LargeNumber &sn = static_cast<const LargeNumber &>(n);
        int temp = 0;
        int more = 0;
        int now = 0;
        int remainder = 0;
        int step = 0 ;
        int i;
        node *two = sn.tail;
        while (two != NULL) {
            step += 1 ;
            now = two->data ;
            if (now != 0) {
                LargeNumber *result = new LargeNumber(0) ;
                node *r = NULL;
                for (i=1;i<step;i++) {
                    if (r == NULL) {
                        r = result->head;
                    } else {
                        r = prepend(r,0);
                    }
                }
                remainder = 0;
                node *one = tail;
                while (one != NULL) {
                    temp = one->data * now + remainder ;
                    if (temp > MAX) {
                        more = temp % (10*ONE) ;
                        remainder = (temp - more) / (10*ONE) ;
                        temp = more ;
                    } else {
                        remainder = 0 ;
                    }
                    if (r == NULL) {
                        r = result->head;
                        r->data = temp;
                    } else {
                        r = prepend(r,temp);
                    }
                    one = one->prev;
                }
                while (remainder > 0) {
                    temp = remainder;
                    if (temp > MAX) {
                        more = temp % 10*ONE ;
                        remainder = (temp - more) / 10*ONE ;
                        temp = more ;
                    } else {
                        temp = remainder ;
                        remainder = 0 ;
                    }
                    r = prepend(r,temp);
                }
                result->head = r;
                Number *crap = total;
                total = (*crap) + (*result) ;
                delete crap;
                delete result;
        //  } else {
        //      cout << "skipping zero\n";
            }
            two = two->prev;
        }
        return total;
    }

protected:

    virtual void print(std::ostream &os) const {
        node *temp = head;
        while (temp != NULL) {
            if (temp == head) {
                cout << temp->data;
            } else {
                printf(FORMAT,temp->data);
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
        if (tail == NULL) {
            head = content ;
        } else {
            tail->next = content;
        }
        tail = content;
        return content ;
    }

    node *prependNode(int n) {
        node *content = new node;
        content->data = n;
        content->prev = NULL;
        content->next = head;
        if (head == NULL) {
            tail = content ;
        } else {
            head->prev = content;
        }
        head = content;
        return content ;
    }

};

int main(int argc, char **argv) {
    if (argc < 2) {
        cout << "Computes the n-th fibonacci and factorial." << endl;
        cout << "usage: " << argv[0] << " <n>" << endl;
        exit(0);
    }

    LargeNumber m(argv[1]);

    ///*
    Number *fibo = Math::fibonacci(m);
    cout << "fibonacci(" << m << ") = " << *fibo << endl;
    delete fibo;
    //*/
    
    ///*
    Number *fact = Math::factorial(m);
    cout << "factorial(" << m << ") = " << *fact << endl;
    delete fact;
    //*/

    return 0;
}
