# Variables

There are two kinds of variables:
* **Normal** variables : internal use only
* **Cache** variables : can be set from outside the project

<br />

The way they are set and used is very similar:
```cmake
set(NormalVariable "A normal variable")
set(CacheVariable  "A cache variable" CACHE STRING "Some description")
```

Note:
If you have a variable that you want to be able to configure on the command-line, this is a cache variable.


Running the previous `CMakeLists.txt`:
```shell
-- NormalVariable = A normal variable
-- CacheVariable = A cache variable
```

Only the **cache** variable is stored in `CMakeCache.txt`:
```shell
$ grep -IrE "CacheVariable" -C1
CMakeCache.txt-//Some description
CMakeCache.txt:CacheVariable:STRING=A cache variable
CMakeCache.txt-
```

If you have a variable that you want to be able to configure on the command-line, this is a cache variable.
For example, the previous


Here is the output from a few different builds
```bash
$ cmake .. -DCacheVariable:STRING=ShortStringNoSpaces
-- CacheVariable = ShortStringNoSpaces
$ grep Variable CMakeCache.txt
CacheVariable:STRING=ShortStringNoSpaces

$ cmake .. -DCacheVariable:STRING="A string with spaces"
-- CacheVariable = A string with spaces
$ grep Variable CMakeCache.txt
CacheVariable:STRING=A string with spaces

$ cmake .. -DCacheVariable:STRING=String\ with\ escaped\ spaces
-- CacheVariable = String with escaped spaces
$ grep Variable CMakeCache.txt
CacheVariable:STRING=String with escaped spaces
```


Note that once a cache variable is set, it never resets to what is in the `CMakeLists.txt`:

The only way to get it back is to modify or delete `CMakeCache.txt`
```bash

# [eric@frances: ~/software/github/ejricha/presentations/cmake/TEST/build] on git:master x # 19:24:56
$ cmake .. -DCacheVariable:STRING="Permanent override"
-- CacheVariable = Permanent override

$ cmake ..
-- CacheVariable = Permanent override

$ rm CMakeCache.txt

$ cmake ..
-- CacheVariable = A cache variable
```


## More about `CMakeCache.txt`
Sits at the top-level of the build directory, and contains all of the information about the build

Modifying (or even `touch`ing) this file will result in every `CMakeLists.txt` file being processed again the next time a configure or generate step runs.


## Setting variables
A variable can hold one of the following:
* A string
* A list
* A boolean

For normal variables, the type is inferred from the parameter automatically, but for cache variables it can be explicitly stated:
```cmake
`CACHE`quite a few ways to set variables:


Normal and cache variables can share names...
```cmake
set(Variable "A normal variable")
set(Variable "A cache variable" CACHE STRING "Conflicts")
message(STATUS "CacheVariable = ${CacheVariable}")

if(Variable STREQUAL "A cache variable")
	message(STATUS "Variable (${Variable}) is Cache")
else()
	message(STATUS "Variable (${Variable}) is Normal")
endif()
```
...but they really shouldn't:
```shell
$ cmake ..
-- CacheVariable = A cache variable
-- Variable (A cache variable) is Cache

$ cmake ..
-- CacheVariable = A cache variable
-- Variable (A normal variable) is Normal
```
Note:
If you give your variables and cache variables the same name, expect weird things to happen.
This example, the first time it was run pulled in the cache variable, but once it was set it reverted to the normal variable.
Just don't do it.

---

# Generator Expressions


