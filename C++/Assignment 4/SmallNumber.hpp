#ifndef ASS4_SMALLNUMBER_HPP
#define ASS4_SMALLNUMBER_HPP

#include <stdlib.h>
#include <iostream>
#include <sstream>

using namespace std;

const bool DEBUG = false;

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
            //   if (DEBUG)
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
        if ((*i) == n) // zero-th number is defined
        {
            delete i;
            return result;
        }
        ++(*i);
        while ((*i) != n) // later numbers are computed by multiplying by all i from 1 to n
        {
            ++(*i);
            Number *temp = result;
            result = (*result) * (*i); // multiply
            //if (DEBUG)
            cout << "fac(" << *i << "):" << *result << endl;
            delete temp;
        }
        delete i;
        cout << " OK";
        return result;
    }

};

// Simple implementation of Number interface

class SmallNumber : public Number {

private:

    int number;

public:

    SmallNumber() {
        if (DEBUG) cout << "SmallNumber:: SmallNumber()" << endl;
        number = 0;
    }

    SmallNumber(int n) {
        if (DEBUG) cout << "SmallNumber:: SmallNumber(" << n << ")" << endl;
        number = n;
    }

    SmallNumber(string s) {
        if (DEBUG) cout << "SmallNumber:: SmallNumber(" << s << ")" << endl;
        stringstream ss;
        ss << s;
        ss >> number;
        if (number < 0) number = -number; // make non-negative, just in case
    }

    virtual ~SmallNumber() {
        if (DEBUG) cout << "SmallNumber:: ~SmallNumber()" << endl;
    }

    virtual Number *factoryMethod(int n) const {
        if (DEBUG) cout << "SmallNumber:: factoryMethod(" << n << ")" << endl;
        return new SmallNumber(n);
    }

    virtual Number *factoryMethod(string s) const {
        if (DEBUG) cout << "SmallNumber:: factoryMethod(" << s << ")" << endl;
        return new SmallNumber(s);
    }

    virtual bool operator==(const Number &n) const {
        if (DEBUG) cout << "SmallNumber:: " << *this << "==" << n << endl;
        const SmallNumber &sn = static_cast<const SmallNumber &>(n); // get reference to sub-class
        return this->number == sn.number;
    }

    virtual Number &operator++() {
        if (DEBUG) cout << "SmallNumber:: " << "++" << *this << endl;
        ++number;
        return *this;
    }

    virtual Number *operator+(const Number &n) const {
        if (DEBUG) cout << "SmallNumber:: " << *this << " + " << n << endl;
        SmallNumber *result = new SmallNumber();
        const SmallNumber &sn = static_cast<const SmallNumber &>(n); // get reference to sub-class
        result->number = number + sn.number;
        return result;
    }

    virtual Number *operator*(const Number &n) const {
        if (DEBUG) cout << "SmallNumber:: " << *this << " * " << n << endl;
        SmallNumber *result = new SmallNumber();
        const SmallNumber &sn = static_cast<const SmallNumber &>(n); // get reference to sub-class
        result->number = number * sn.number;
        return result;
    }

protected:

    virtual void print(std::ostream &os) const {
        os << number;
    }

};

#endif
