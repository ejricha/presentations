## Functions and macros

The `function` and `macro` commands are very similar, but have one main difference:
* Functions run in their own scope
* Macros run in the caller's scope

Calling a macro is equivalent to copying its contents directly (much like C/C++ macros).

Note:
It is possible to set a variable in a function in the caller's scope, by using the optional `PARENT_SCOPE` argument, but don't do this.


Example of a [`function`](https://cmake.org/cmake/help/latest/command/function.html):
```cmake
function(F arg)
    if(DEFINED arg)
        message(STATUS "F : ${arg} is defined")
    else()
        message(STATUS "F : ${arg} is NOT defined")
    endif()
endfunction()
F("one")
```

Output:
```shell
-- F : one is defined
```

Note:
Because `${arg}` is defined in the function scope.


Example of a [`macro`](https://cmake.org/cmake/help/latest/command/macro.html):
```cmake
macro(M arg)
    if(DEFINED arg)
        message(STATUS "M : ${arg} is defined")
    else()
        message(STATUS "M : ${arg} is NOT defined")
    endif()
endmacro()
M("two")
```

Output:
```shell
-- M : two is NOT defined
```

Note:
Because `${arg}` is NOT defined in the caller's scope.


Functions and macros *can* be overloaded, but it's not really recommended.

When a function is overloaded, the original version of the function is still available, with a `_` prefix. This means that a function can only be overloaded once, because the second time that it is overloaded the original version disappears.

Note:
This is true whether the functions have the same signature or not.


```cmake
function(F arg1)
	message(STATUS "1 : ${arg1}")
endfunction()
F("A (1)" "arg2" "arg3")
function(F arg1 arg2)
	message(STATUS "2 : ${arg1}, ${arg2}")
endfunction()
_F("B (1)" "arg2" "arg3")
F("C (2)" "arg2" "arg3")
function(F arg1 arg2 arg3)
	message(STATUS "3 : ${arg1}, ${arg2}, ${arg3}")
endfunction()
_F("D (2)" "arg2" "arg3")
F("E (3)" "arg2" "arg3")
```

```shell
-- 1 : A (1)
-- 1 : B (1)
-- 2 : C (2), arg2
-- 2 : D (2), arg2
-- 3 : E (3), arg2, arg3
```

Note:
Functions can be *overspecified*, but *under*-specifying a function results in an error like this:
`Function invoked with incorrect arguments for function named: F`
