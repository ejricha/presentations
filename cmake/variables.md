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


## Several options for [`set`](https://cmake.org/cmake/help/latest/command/set.html)
```cmake
# Set a normal variable
set(<variable> <value>... [PARENT_SCOPE])

# Set a cache variable (cache entry)
set(<variable> <value>... CACHE <type> <docstring> [FORCE])
# (Where <type> is one of BOOL, FILEPATH, PATH, STRING, or INTERNAL)

# Set an environment variable directly
set(ENV{<variable>} [<value>])
```

Note:
I will speak more about the `PARENT_SCOPE` option later when we talk about `function`s.
I will speak no more of setting environment variables thus.


Running the previous `CMakeLists.txt`:
```shell
-- NormalVariable = A normal variable
-- CacheVariable = A cache variable
```
<br />

Only the **cache** variable is stored in `CMakeCache.txt`:
```shell
$ grep -IrE "Variable" -C1
CMakeCache.txt-//Some description
CMakeCache.txt:CacheVariable:STRING=A cache variable
CMakeCache.txt-
```


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


Note that once a cache variable is set, it never resets to what is in the `CMakeLists.txt`

The only way to get it back is to modify or delete `CMakeCache.txt`:
```bash
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

Modifying (or even `touch`ing) this file will result in every `CMakeLists.txt` file being processed again the next time a configure or generate step runs


## Setting variables
A variable can hold one of the following:
* A string
* A list
* A boolean

Note:
Underneath, they're all strings.
A list is just a string with semicolons separating values.
A boolean is just a string that is processed by special rules.


## Setting [`string`](https://cmake.org/cmake/help/latest/command/string.html) variables

```cmake
# Manipulation
  string(TOLOWER     <string> <out-var>)
  string(TOUPPER     <string> <out-var>)
  string(LENGTH      <string> <out-var>)
  string(STRIP       <string> <out-var>)
  string(GENEX_STRIP <string> <out-var>)
  string(APPEND      <string-var> [<input>...])
  string(PREPEND     <string-var> [<input>...])
  string(CONCAT      <out-var> [<input>...])
  string(JOIN        <glue> <out-var> [<input>...])
  string(SUBSTRING   <string> <begin> <length> <out-var>)
  string(REPEAT      <string> <count> <out-var>)
```


More `string` operations:
```cmake
# Search and Replace
  string(FIND    <string> <substring> <out-var> [...])
  string(REPLACE <match-string> <replace-string> <out-var> <input>...)

# Regular Expressions
  string(REGEX MATCH    <match-regex> <out-var> <input>...)
  string(REGEX MATCHALL <match-regex> <out-var> <input>...)
  string(REGEX REPLACE  <match-regex> <replace-expr> <out-var> <input>...)

# Comparison
  string(COMPARE <op> <string1> <string2> <out-var>)

# Hashing
  string(<HASH> <out-var> <input>)
```


Even more `string` operations:
```cmake
# Generation
  string(ASCII <number>... <out-var>)
  string(CONFIGURE <string> <out-var> [...])
  string(MAKE_C_IDENTIFIER <string> <out-var>)
  string(RANDOM [<option>...] <out-var>)
  string(TIMESTAMP <out-var> [<format string>] [UTC])
  string(UUID <out-var> ...)
```


## Setting [`list`](https://cmake.org/cmake/help/latest/command/list.html) variables

Lists are separated by semicolons, and there are a few useful commands that you can use to operate on them:

```cmake
Modification
  list(APPEND <list> [<element>...])
  list(PREPEND <list> [<element>...])
  list(POP_BACK <list> [<out-var>...])
  list(POP_FRONT <list> [<out-var>...])
  list(INSERT <list> <index> [<element>...])
  list(REMOVE_ITEM <list> <value>...)
  list(REMOVE_AT <list> <index>...)
  list(REMOVE_DUPLICATES <list>)
  list(TRANSFORM <list> <ACTION> [...])
  list(FILTER <list> {INCLUDE | EXCLUDE} REGEX <regex>)
```


More `list` operations:
```cmake
Reading
  list(LENGTH <list> <out-var>)
  list(GET <list> <element index> [<index> ...] <out-var>)
  list(JOIN <list> <glue> <out-var>)
  list(SUBLIST <list> <begin> <length> <out-var>)

Search
  list(FIND <list> <value> <out-var>)

Ordering
  list(REVERSE <list>)
  list(SORT <list> [...])
```


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
...but they really shouldn't
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
