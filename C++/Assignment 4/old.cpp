// C++ assignment 4: large numbers, May 2017.
// bram.otten@student.uva.nl, ID 10992456.
// Tested with g++ 5.4+ (as c++98, on x64).

//  g++ main.cpp --std=c++98 && a.exe 123456

#include <stdlib.h>
#include <iostream>
#include <sstream>
#include <math.h> // for pow()

using namespace std;

const int k = 4;

/*
// Copied from Savitch, don't think I'll use.
class DoublyLinkedIntNode
{
public:
    DoublyLinkedIntNode ( ) {}
    DoublyLinkedIntNode ( int theData, DoublyLinkedIntNode* previous,
                          DoublyLinkedIntNode* next)
            : data(theData), nextLink(next), previousLink(previous) {}
    DoublyLinkedIntNode* getNextLink( ) const { return nextLink; }
    DoublyLinkedIntNode* getPreviousLink( ) const { return previousLink; }
    
    int getData( ) const { return data; }
    void setData( int theData) { data = theData; }
    void setNextLink(DoublyLinkedIntNode* pointer) { nextLink = pointer; }
    void setPreviousLink(DoublyLinkedIntNode* pointer) { 
        previousLink = pointer; 
    }

    void headInsert(DoublyLinkedIntNodePtr& head, int theData)
    {
        DoublyLinkedIntNode* newHead = new Doubly LinkedIntNode
                                                (theData, NULL, head);
        head->setPreviousLink(newHead);
        head = newHead;
    }

    void deleteNode(DoublyLinkedIntNodePtr& head, 
                    DoublyLinkedIntNodePtr discard) {
        if (head == discard) {
            head = head->getNextLink( );
            head->setPreviousLink(NULL);
        }
        else {
            DoublyLinkedIntNodePtr prev = discard->getPreviousLink( );
            DoublyLinkedIntNodePtr next = discard->getNextLink( );
            prev->setNextLink(next);
            if (next != NULL)
                next->setPreviousLink(prev);
        }
        delete discard;
    }
private:
    int data;
    DoublyLinkedIntNode *nextLink;
    DoublyLinkedIntNode *previousLink;
}
typedef DoublyLinkedIntNode* DoublyLinkedIntNodePtr;
*/
// Interface of Number type
// its methods are virtual so they can be overridden in derived classes
class Number {
public:

    Number() {};

    Number(string s) {};                                    // constructor based in string representation of number
    virtual ~Number() {};                                   // makes destructor virtual
    virtual Number *factoryMethod(string s) const =0;       // returns new Number object

    virtual bool operator==(const Number &n) const =0;      // test for equality
    virtual bool operator!=(const Number &n) const          // test for inequality
    { return !((*this) == n); }

    virtual Number &operator++()=0;                         // increment number
    virtual Number *operator+(const Number &n) const =0;    // returns new Number object after addition
    virtual Number *operator*(const Number &n) const =0;    // returns new Number object after multiplication

    friend std::ostream &operator<<(std::ostream &os, const Number &n);

protected:

    virtual void print(std::ostream &os) const =0;          // prints the number

};

ostream &operator<<(ostream &os, const Number &n)           // this enables "cout<<Number("123");" type printing
{
    n.print(os);
    return os;
}

// Math library that computes fibonacci and factorial numbers, uses the Number interface
class Math {
public:

    // compute n-th fibonacci number
    static Number *fibonacci(const Number &n) {
        Number *fib0 = n.factoryMethod("0");                // zero-th number is defined
        if (n == *fib0)
            return fib0;
        Number *fib1 = n.factoryMethod("1");                // first number is defined
        if (n == *fib1) {
            delete fib0;
            return fib1;
        }
        Number *result = NULL;
        Number *i = n.factoryMethod("1");

        cout << "\n\nAm entering FOR in Math::Number fibonacci something\n";

        for (; (*i) != n; ++(*i))                           // later numbers are computed by adding previous two
        {
            cout << "\nAbout to use +\n";
            result = (*fib0) + (*fib1); // add
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
        cout << "This factorial is very TODO.\n";

        Number *result = n.factoryMethod("1");
        Number *i = n.factoryMethod("0");
        if ((*i) == n)                                      // zero-th number is defined
        {
            delete i;
            return result;
        }
        ++(*i);
        while ((*i) != n)                                   // later numbers are computed by multiplying
            // by all i from 1 to n
        {
            ++(*i);
            Number *temp = result;
            result = (*result) * (*i); // multiply
            delete temp;
        }
        delete i;
        return result;
    }

};

struct node {
    int data;
    node *next;
    node *prev;
};

// Implementation of Number interface that should hande larger numbers.
class LargeNumber : public Number {
public:
    LargeNumber() {}

    LargeNumber(string s) {


        head = tail = NULL;
        unsigned int n = s.length();
        unsigned int i = 0;

        // k is the number of digits per node
        while (n >= k) {
            makeNode(s.substr(i,k));
            n -= k;
            i += k ;
        }
        if (n > 0) makeNode(s.substr(i,n));

        printNodes();
    }

    // Makes a node of a string containing k digits.
    void makeNode(string dataString) {
        content = new node;
        content->data = atoi(dataString.c_str());
        content->prev = tail;
        head == NULL ? head = content : tail->next = content;
        tail = content;

        // TODO: delete content (the new node).
        // Just a delete makes the entire thing 0.
    }

    void printNodes() {
        cout << "\n--The list, head -> tail: ";
        node *temp = head;
        while (temp != NULL) {
            if (temp != head) cout << " -> ";
            cout << temp->data;
            temp = temp->next;
        }
        cout << endl;
    }

    virtual ~LargeNumber() {}

    // TODO (maybe).
    virtual Number *factoryMethod(string s) const {
        return new LargeNumber(s);
    }

    // TODO and in some kind of progress.
    virtual bool operator==(const Number &n) const {

        const LargeNumber &sn = static_cast<const LargeNumber &>(n);        // get reference to sub-class

        // I'm guessing: iterate over nodes, and check if equal.
        int nodeCounter = 0;
        node *here = this->head;
        node *there = sn.head;

        while (here != NULL && there != NULL) {
            cout << here->data << " is here and there is " << there->data << endl;
            if (here->data != there->data) return false;

            cout << "Not false?!\n";

            here = here->next;
            there = there->next;
            nodeCounter++;
        }

        cout << "A match?!\n";

        return true;
    }

    // TODO, but only kind of. I can push the entire thing to +.
    virtual Number &operator++() {
        cout << "In the ++\n";

        // Add 1 to the last node in the list?
        node *last = this->tail;

        // maybe I could throw it to the to-be-defined +
        if (last->data != 9999) last->data = last->data + 1;
        else cout << 9999 << " support coming soon\n";

        return *this;
    }

    // TODO, it's VERY inefficiently ++'ing now.
    // Is used like: result = (*fib0) + (*fib1);
    virtual Number *operator+(const Number &n) const {

        LargeNumber *result = new LargeNumber();
        const LargeNumber &sn = static_cast<const LargeNumber &>(n);
        
        cout << "*result: " << *result << endl;
        cout << "sn: " << sn << endl;

        return result;
    }

    // TODO, completely.
    virtual Number *operator*(const Number &n) const {
        //return 0;
        LargeNumber *result = new LargeNumber();
        const LargeNumber &sn = static_cast<const LargeNumber &>(n);        // get reference to sub-class
        //result->dublyList = dublyList * sn.dublyList;
        return result;
    }

protected:

    virtual void print(std::ostream &os) const {
        // TODO
        node *temp = head;
        while (temp != NULL) {
            cout << temp->data;
            temp = temp->next;
        }
    }

private:

    node *head;
    node *tail;
    node *content;
};

int main(int argc, char **argv) {
    if (argc < 2) {
        cout << "Computes the n-th fibonacci and factorial." << endl;
        cout << "usage: " << argv[0] << " <n>" << endl;
        exit(0);
    }

    LargeNumber n(argv[1]);

    Number *fib = Math::fibonacci(n);
    cout << "fibonacci(" << argv[1] << ") = " << *fib << endl;
    delete fib;

    /*
    Number *fac = Math::factorial(n);
    cout << "factorial(" << n << ") = " << *fac << endl;
    delete fac;
    */

    cout << "Done.\n";
    return 0;
}