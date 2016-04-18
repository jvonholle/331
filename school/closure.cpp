// closure.cpp
// Glenn G. Chappell
// 3 Feb 2016
//
// For CS 331 Spring 2016
// Closures in C++11
// Compare the "Closures" section of prog2.lua

#include <iostream>
using std::cout;
using std::endl;
#include <functional>
using std::function;


// make_multiplier
// Return a function object (a closure) that multiplies by the given k.
function<int(int)> make_multiplier(int k)
{
    auto mult = [=](int x)
    {
        return k * x;
    };

    // Return value is a function object: an object wrapping an unnamed
    // function (a.k.a. "lambda function"). The "[=]" above means that
    // the closure keeps a copy of every variable it uses. Replace this
    // with "[k]" to specify that only a copy of k should be kept.
    return mult;
}


// Main program
// Demonstrate make_multiplier by creating a couple of closures and
// using them.
int main()
{
    auto times2 = make_multiplier(2);
    auto triple = make_multiplier(3);

    cout << "17 times 2 is " << times2(17) << endl;
    cout << "25 tripled is " << triple(25) << endl;

    return 0;
}

