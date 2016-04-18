// lifetime.cpp
// Glenn G. Chappell
// 7 Mar 2016
//
// For CS 331 Spring 2016
// Demonstrate Lifetime of Values

#include <iostream>
using std::cout;
using std::endl;
using std::cin;
#include <string>
using std::string;


// class Foo
// Value whose construction and destruction result in messages printed.
// Constructor gets string, prints "Construct" message with that string.
// Destructor prints "Destroy" message with same string.
//
// Note: Nothing has been done about the copy & move ctors and
// assignment operators. Do not use these.
class Foo {

// ***** Foo: ctor, dctor *****
public:

    // ctor from string
    // Save given string in _s; print "Construct" message.
    explicit Foo(const string & s)
        :_s(s)
    { cout << "Construct Foo(" << _s << ")" << endl; }

    // dctor
    // Print "Destroy" message.
    ~Foo()
    { cout << "Destroy Foo(" << _s << ")" << endl; }

    // Eliminate copy operations
    Foo(const Foo & other) = delete;
    Foo & operator=(const Foo & rhs) = delete;

// ***** Foo: data members *****
private:

    string _s;  // The message

};


// zz
// Do-nothing function that takes a Foo object.
void zz(const Foo & z)
{}


// Make a couple of globals
Foo a("global 1");
Foo b("global 2");


// bar
// Call this to see construction & destruction of static, automatic, and
// temporary Foo values.
void bar()
{
    cout << "bar: START" << endl;

    static Foo c("bar-local static 1");
    Foo d("bar-local automatic 1");
    Foo e("bar-local automatic 2");
    static Foo f("bar-local static 2");

    cout << "bar: FIRST MARKER" << endl;
    zz(Foo("bar-temporary 1"));
    cout << "bar: SECOND MARKER" << endl;
    zz(Foo("bar-temporary 2"));

    cout << "bar: END" << endl;
}


// Main Program
// Print various messages, call function bar.
int main()
{
    cout << "main: START" << endl;

    bar();

    //bar();
    // Uncomment above line to see how static local variables are
    // handled when a function is called more than once.

    // Quit when user hits Enter
    cout << "Press ENTER to quit ";
    while (cin.get() != '\n') ;
    cout << endl;

    cout << "main: END" << endl;
}

