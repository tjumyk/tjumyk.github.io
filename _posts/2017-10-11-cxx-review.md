---
layout: post
title: Review of C++
description: "Review the most important features of C++ in an intermediate-level programmer's perspective"
modified: 2017-10-11
tags: [C++]
image:
  feature: smart_pointer.jpg
  thumbnail: smart_pointer_thumbnail.jpg
comments: true
share: true
---

In this article, I try to summarize the most of the **distinct features or confusing aspects** of the C++ programming 
language (C++14) as a quick review for intermediate-level programmers. So, I assume the reader is already capable of 
intensive programming with C, Python or Java and understand the basic concepts of programming languages.  

--------------------
# Overview

## Types

* Multi-byte char types
   - **wchar_t**: guaranteed to be large enough to hold any charactorer in the machine's largest extended character set.
     Typically 32 bit.
   - **char16_t**(C++ 11): 16 bit Unicode character
   - **char32_t**(C++ 11): 32 bit Unicode character

```cpp
L'a'; // type of this character literal is wchar_t
```

* Constructing new types using **declarator operators**
  - pointer types(C/C++): `int*`
  - array types(C/C++): `char[]`
  - **reference types**(C++ Only): `double&`

* Limits of predefined types

```cpp
// machine-dependent limits
std::numeric_limits<int>::max();
std::numeric_limits<int>::min();
```

* Implicit type conversion (C/C++)

```cpp
signed int a = -1;
unsigned int b = 1;
std::cout << a * b << std::endl; // will print 4294967295 (2^32-1)
```

* `const` qualifier
   * Top-level `const` is ignored when we copy an object because copying an object doesn't change the copied object.
   * Low-level `const` is never ignored. When we copy an object, both objects must have the same low-level `const` 
     qualification or there must be a conversion between the types of the two objects
      * we can convert non-`const` to `const`
      * the inverse conversion is invalid
      
```cpp
int i = 0;
const int j = i;        // top-level const is ignored
int k = j;              // top-level const is ignored

const int *p = &j;      // low-level const must not be ignored
const int *const q = p; /* left-most const is low-level, 
                           right-most const is top-level */
const int &r = j;       // const in reference types is always low-level
```

* Order of evaluating two operands of a bianry operator is **undefined**. (C/C++)

```cpp
f() + g(); // order of evaluating f and g is undefined
```

## Declarations vs Definitions

* `extern` keyword declares a variable without defining it except when it is initialized.

```cpp
extern int i;     // declaration
extern int i = 1; // declaration and definition
int j;            // declaration and definition
```

* Definitions vs Declarations
   * Every definition is also a declaration
   * An entity can be declared for multiple times
   * An entity can only be defined once (ODR: One-Definitino-Rule)
   
* Header files
   * should generally not include definitions
   * except class definitions, class templates, const objects and inline functions
   * should always be enclosed by header guards (#ifndef ...) 

## Pointers

* Pointer initialization
   * To minimise bugs, alwasy initialise pointers when they are defined. If the intended address is not available, then 
     set to `nullptr`
   * `*` modifies a variable rather than the type

```cpp
int* p, q; // same as int *p and int q, but no as int *q and int *q
```

* Complex pointers

```cpp
int * (*fp)(int*) // pointer to a function taking an int* and returning an int*
int X::*pm        // pointer to a member of class X of type int
```

* `const` and pointers

```cpp
int i = 5;
const int *p = &i; /* *p = 5 doesn't compile (read only dereference), 
                      but i can be either a const or non-const object */
int const *q = &i; // same as p
```

## References (C++ Only)

* References are a way of **aliasing** objects
   * A reference is alwasy **const** since it must be initialised when defined and cannot be modified later
   * A reference is not itself an object unlike a pointer which is an object
   * References are safer than pointers because they **can never be null**.
* `const` and references
   * A non-const reference must refer to an object of the same type
   * A const-reference can refer to an object of a different (but related) type
   * A const-reference can refer to a literal
* Notes
   * Use references instead of pointers wherever possible
   * We can think a reference as a dereferenced pointer
   * References are almost always implemented as pointers

```cpp
int i = 5;
long &r = i;         // compile error
const long &s = i;   // correct
const long *t = &i;  // compile error
const int &r2 = 100; // correct
```

## The `auto` type specifier (C++11)

Let the compiler infer the type for us

* If the initializer is a reference, the referred object will be used as the initializer
* The top-level `const` in the type of the initializer will be ignored
* Use `const auto` if we want the deducted type has a top-level `const`
* Use `auto &` if we want a reference to the deducted type. In this case, the top-level `const` in the initializer is 
  not top-level any more because we bind a reference to an initializer. So, that `const` will not be ignored.

```cpp
auto i = 0, *p = &i;      // ok, i is int and p is int*
auto sz = 0, pi = 3.14;   // error: inconsistent types

int i;
const int *const p = i;
auto r = p;               // const int * const -> const int*
const auto s = p;         // const int* const

const int &j = 1;
auto u = j;               // const int & -> const int -> int
const auto v = j;         // const int
auto &w = j;              // const int & (low-level const kept)
```


## Functions

* A function must have a return type
   * Returning `void` means no return object
   * Functions may not return arrays or other functions
   * Functions may return pointers or references 
* A function may have an empty parameter list

```cpp
int foo();      // OK: implicit empty parameter list
void bar(void); // OK: explicit empty parameter list
```

* Lvalue vs Rvalue
   * Lvalue: address of the object
   * Rvalue: content of the object
   
```cpp
int i = 5;
      i     =     i     +   1;
// (Lvalue)    (Rvalue)
```

* Parameter passing
   * pass by value: **Rvalue** of an actual argument is passed (C/C++/Java/...)
   * pass by reference: **Lvalue** of an actual argument is passed (C++ Only[?])

```cpp
void swap(int i, int j);   /* wrong, copy values of actual arguments
                              (pass by value) */
// Two ways to fix it
void swap(int *i, int *j); // C style
void swap(int &i, int &j); /* C++ style (pass by reference)
                              Use C++ style wherever possible */
```

* Function overloading
   * overloading resolution is a three-step process
      * identify **candidate** functions: same name visible at the point of call
      * select **viable** functions: same number of parameters as arguments (and the default parameters) and the type of
        each argument is convertible to its corresponding parameters
      * find a **best-match**: the type match **no worse in each argument** but better in at least on argument
   * top-level `const` is ignored for function overloading, low-level `const` is significant
   
```cpp
Record lookup(Phone p) {...};
Record lookup(const Phone p) {...};  /* error: redefinition, 
                                        because top-level const is ignored */

// The following overloading is correct: low-level const is not ignored
Record lookup(Phone &p) {...};       // (1)
Record lookup(const Phone &p) {...}; // (2)

Phone p1;
const Phone p2;
lookup(p1);     // call (1)
lookup(p2);     // call (2)
```
      
* Inline Functions
   * Use case: we want to define **a small utility function** for a simple operation but we wish to **avoid the overhead
     of a function call** for such a simple function
   * An inline function is **expanded in line** at each point in the program where it is invoked.

```cpp
inline int min(int n, int m) {
  return (n < m) ? n : m;
}
std::cout << min(i, j) << std::endl; 
/* It will be expanded into something like the line below during compilation.
   So we need to put the definitions of inline functions in the header file   */
std::cout << ((i < j) ? i : j) << std::endl;
```

## Scope

* A local name can be **hidden**

```c++
int i = 3;
for (int i = 0 ; i < 10; ++i){
    std::cout << i << std::endl; // this 'i' hides the upper scope 'i'
}
std::cout << i << std::endl;     // the upper scope 'i' is unchanged
```

* namespaces 
    * can be nested or aggregated (like Java packages)
    * two special cases
        * **Global scope**: the outermost namespace scope of a file
        * **File scope**: the unnamed namespace scope declared in a file
            * it has the same effect of `static` modifier in both C and C++ (static variables are restricted in the file)
            * variables in this scope are accessible like global variables

```cpp
namespace A{
    int a = 1;
    namespace B{
        int a = 2;
    }
    namespace C{
        int a = 3;
    }
}
// all these 'a's are different variables
std::cout << A::a << std::endl;
std::cout << A::B::a << std::endl;
std::cout << A::C::a << std::endl;

int i = 1;
namespace { // unnamed namespace creates a file scope
    int i = 2; // error, re-declare 'i'
    int j = 3;
}
std::cout << j << std::endl;   // correct
std::cout << ::j << std::endl; // also correct
```

* `using` directive
    * `using namespace X;` make names in `X` accessible as in the current scope
    * `using X::a;` only make `a` in the `X` scope accessible in the current scope
    * may cause namespace clashes or namespace pollution
    * do not use `using` on namespace `std` 

```cpp
namespace X {
    int i, j, k;
}
int k;

int foo(){
    int i = 0;
    using namespace X;
    i=1;        // local i
    j=2;        // X::j
    k=3;        // error, ambiguous k
    ::k=3;      // correct, explicitly use the global k
    X::k=3;     // correct, explicitly use k in namespace X
}

int bar(){
    int i = 0;
    using X::j;
    j=4;        // X::j
    using X::k; // hides the global k
    k=4;        // correct, X::k
}
```
## Input/Output Streams

* formatting
   * set flags of `ios_base`: `.setf(flag, mask)`
      * `flag`: a 
   * pointer to functions that change the flags of `ios_base`:
      * `std::hex`
      * `std::dec`
      * `std::`

```cpp
std::cout << 1331 << std::endl;                                // 1331
std::cout << std::hex << 1331 << std::endl;                    // 533
std::cout << 1331.123456 << std::endl;                         // 1331.12
std::cout.setf(std::ios::scientific, std::ios::floatfield);    
std::cout << 1331.123456 << std::endl;                         // 1.331123e+03
std::cout << std::setprecision(3) << 1331.123456 << std::endl; // 1.331e+03
std::cout << std::dec << 1331 << std::endl;                    // 1331
std::cout.fill('X');
std::cout.width(8);
std::cout << 1331 << std::endl;                                // XXXX1331
std::cout.setf(std::ios::left, std::ios::adjustfield);
std::cout.width(8);
std::cout << 1331 << std::endl;                                // 1331XXXX
```

## Strings

* `std::string`
    * constructors for empty, string, C-string and sub-string
        * given empty parameter, the default initialiser makes an empty string
    * use iterators and `[]` for speed
    * use `at()` when you need range checking
    * use `find()` (and its variants) to locate values in a string
    * use `+` , `+=`, `insert` and `append` for concatenating strings
    * `\0` is a valid character in C++, but treated as the terminator in C
    * `isalpha`, `isdigit`, ... from C are provided in `<ctype.h>`

## Initialization

```cpp
int i1 {1};     // C++11, list prepered
int i2 = {1};
int i3 = 1;
int i4(1);

int j1{};       // the default value used
int j2 = int{}; // a temporaty default value used
```

## Type Conversions

* C-style cast: dangerous
* `static_cast`: basic type checks at compile time
* `reinterpret_cast`: low level reinterpretation of the bits, e.g. a pointer to a long
* `const_cast`: cast away the const, mostly for portability only
* `dynamic_cast`: capability check at runtime

```cpp
double myDouble = 3.14;
int cast1 = (int)myDouble;              // c-style
int cast2 = int(myDouble);
int cast3 = static_cast<int>(myDouble); // recommended

unsigned short hash(void *p){
    unsigned long val = reinterpret_cast<unsigned long>(p);
    return (unsigned short) (val ^ (val >> 16)); /* XOR higher bits with lower bits
                                                    'short' is always 16-bits       */
}

```
