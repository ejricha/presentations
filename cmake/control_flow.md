# Control flow

There aren't too many of these commands, but they all have a similar form. For a command `<x>`:
* Start the command with `x(...)`
* End the command with `endx()`

For example:
```cmake
if(B)
# ...
endif()
```

Note:
The commands are case-insensitive for legacy reasons, but the de-facto standard is to use all lowercase.
Also for legacy reasons, you'll see some code that ends an `<x>(B)` block with `end<x>(B)`; don't do this.
Also, do not put a space after the command (this isn't C++).


## List of flow control commands
```cmake
if() ; else() ; elseif() ; endif()
while() ; endwhile()
foreach() ; endforeach()
function() ; endfunction()
macro() ; endmacro()
```
Also, there are normal loop control commands:
```cmake
break() ; continue()
```

Note:
Obviously, the most important one of these is the `if` statement.

---

## Using the [`if`](https://cmake.org/cmake/help/latest/command/if.html) statement

Full usage:
```cmake
if(<condition>)
  <commands>
elseif(<condition>) # optional block, can be repeated
  <commands>
else()              # optional block
  <commands>
endif()
```

Returns:

* **True** : `1`, `ON`, `YES`, `TRUE`, `Y`, or a non-zero number
* **False** : `0`, `OFF`, `NO`, `FALSE`, `N`, `IGNORE`, `NOTFOUND`, the empty string, or ends in the suffix `-NOTFOUND`


Commands can be joined with the normal boolean operators:
* `AND`
* `OR`
* `NOT`
* Parentheses

Example:
```cmake
set(A1 FALSE)
if(((X EQUAL 3) OR (X EQUAL 7) OR (X EQUAL 14)) AND
	NOT ((Y EQUAL 4) OR (Y EQUAL 12) OR (Y EQUAL 18)))
	set(A1 TRUE)
endif()
```


Here is a slightly more readable way:
```cmake
# More readable
set(A2 FALSE)
set(A2_X FALSE)
set(A2_Y FALSE)
if((X EQUAL 3) OR (X EQUAL 7) OR (X EQUAL 14))
	set(A2_X TRUE)
endif()
if(NOT ((Y EQUAL 4) OR (Y EQUAL 12) OR (Y EQUAL 18)))
	set(A2_Y TRUE)
endif()
if(A2_X AND A2_Y)
	set(A2 TRUE)
endif()
```

Note:
Although it is slightly more readable, it does involve two additional `if()` statements, and two temporary variables. So it's still not the most concise or efficient.


We can confirm that our last two examples produce the same result:
```cmake
# Ensure that the variables match
if(NOT A1 STREQUAL A2)
	message(FATAL_ERROR "A1 (${A1}) != A2 (${A2}) [X=${X}, Y=${Y}]")
else()
	message(STATUS "A1 (${A1}) == A2 (${A2}) [X=${X}, Y=${Y}]")
endif()
```

When this was run, it made it all the way to the end without a "CMake Error", though it printed out a lot of `STATUS` messages along the way


### Types of comparisons

Numbers | Strings | Versions
--- | --- | ---
`LESS` | `STRLESS` | `VERSION_LESS`
`LESS_EQUAL` | `STRLESS_EQUAL` | `VERSION_LESS_EQUAL`
`EQUAL` | `STREQUAL` | `VERSION_EQUAL`
`GREATER_EQUAL` | `STRGREATER_EQUAL` | `VERSION_GREATER_EQUAL`
`GREATER` | `STRGREATER` | `VERSION_GREATER`


Example of version comparisons
```cmake
set(versionA 1.2    1.2    1.2.3  2.0.1  1.8.2  1.7.3)
set(versionB 1.2.0  1.2.3  1.2    1.9.7  2      1.11.1)
list(LENGTH versionA listLength)
math(EXPR lastIndex "${listLength} - 1")
foreach(i RANGE 0 ${lastIndex})
    list(GET versionA ${i} a)
    list(GET versionB ${i} b)
    if(${a} VERSION_LESS ${b})
        message(NOTICE "  ${a} < ${b}")
	...
    endif()
endforeach()
```
```bash
  1.2 == 1.2.0
  1.2 < 1.2.3
  1.2.3 > 1.2
  2.0.1 > 1.9.7
  1.8.2 < 2
  1.7.3 < 1.11.1
```

---

## Using the [`while`](https://cmake.org/cmake/help/latest/command/while.html) statement

```cmake
while(<condition>)
  <commands>
endwhile()
```

* Takes the same arguments as `if`
* The loop can be interrupted by:
 * `break()` : breaks out of loop
 * `continue()` : jumps back to start of loop

---

## Using the [`foreach`](https://cmake.org/cmake/help/latest/command/foreach.html) statement
```cmake
set(Out "RANGE 5 :")
foreach(Var RANGE 5)
	set(Out "${Out} ${Var}")
endforeach()
message(STATUS ${Out})

# Repeat for a few different signatures:
foreach(Var RANGE 11 15)
foreach(Var RANGE 21 25 2)
foreach(Var IN ITEMS 91 92 93 94 95)
```

Note:
The same `break()` and `continue()` commands that were valid for `if` statements are also valid here.


### Output
```shell
$ cmake ..
-- RANGE 5 : 0 1 2 3 4 5
-- RANGE 11 15 : 11 12 13 14 15
-- RANGE 21 25 2 : 21 23 25
-- IN ITEMS ... : 91 92 93 94 95
```

Note:
The single-argument `RANGE` command starts at 0. Which would be fine, except that it is *inclusive*, so spans the range [0, 5], which is 6 values.
