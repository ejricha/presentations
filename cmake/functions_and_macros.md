# Functions and macros

The `function` and `macro` commands

The difference is this:
* Functions run in their own scope
* Macros run in the caller's scope

Calling a macro is equivalent to copying its contents directly (much like C/C++ macros).


Example:
```cmake
function(F arg)
    if(DEFINED arg)
        message(STATUS "F : ${arg} is defined")
    else()
        message(STATUS "F : ${arg} is NOT defined")
    endif()
endfunction()
macro(M arg)
    if(DEFINED arg)
        message(STATUS "M : ${arg} is defined")
    else()
        message(STATUS "M : ${arg} is NOT defined")
    endif()
endmacro()
F("one")
M("two")
```
```shell
-- F : one is defined
-- M : two is NOT defined
```


Functions and macros *can* be overloaded, but it's not really recommended.

When a function is overloaded, the original version of the function is still available, with a `_` prefix. This means that a function can only be overloaded once, because the second time that it is overloaded the original version disappears.


```cmake
function(F)
    message(STATUS 1)
endfunction()
F()

function(F)
    message(STATUS 2)
endfunction()
_F()
F()

function(F)
    message(STATUS 3)
endfunction()
_F()
F()
```

```shell
-- 1
-- 1
-- 2
-- 2
-- 3
```
