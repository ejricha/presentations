# Control flow

There aren't too many of these commands, but they all have a similar form. For a command `<x>`:
* Start the command with `x()`
* End the command with `end<x>()`

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


Command can be joined with the normal boolean operators:
* `AND`
* `OR`
* `NOT`
* Parentheses

Example:
```cmake
# Perfectly legal
set(A1 FALSE)
if(((X EQUAL 3) OR (X EQUAL 7) OR (X EQUAL 14)) AND
	NOT ((Y EQUAL 4) OR (Y EQUAL 12) OR (Y EQUAL 18)))
	set(A1 TRUE)
endif()

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

# Ensure that the variables match
if(NOT A1 STREQUAL A2)
	message(FATAL_ERROR "A1 (${A1}) != A2 (${A2}) [X=${X}, Y=${Y}]")
else()
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

### Output
```shell
$ cmake ..
-- RANGE 5 : 0 1 2 3 4 5
-- RANGE 11 15 : 11 12 13 14 15
-- RANGE 21 25 2 : 21 23 25
-- IN ITEMS ... : 91 92 93 94 95
```

Note:
The single-argument `RANGE` command starts at 0.
