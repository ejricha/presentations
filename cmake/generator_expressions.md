# Generator Expressions

There are two steps that CMake goes through:
1. **Configure** : all `CMakeLists.txt` files are processed
1. **Generate** : the appropriate `Makefile`s or other configuration files are generated

Note:
Also in the **Configure** step, the `CMakeCache.txt` file in the build directory is created or updated.
It is only in the **Generate** step that the build type (e.g. `Debug`) is taken into account.
This is why multi-config generators like MSVC don't have to be re-configured when switching build types.


## Examples

Here are few useful [`generator expressions`](https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html):
```
$<BOOL:string>
$<AND:conditions> # comma-separated
$<OR:conditions>  # comma-separated
$<NOT:condition>
$<STREQUAL:string1,string2>
$<EQUAL:value1,value2>
$<IN_LIST:string,list>
$<VERSION_LESS:v1,v2> # and _GREATER, etc.
$<TARGET_EXISTS:target>
$<CONFIG:cfg>
$<CXX_COMPILER_VERSION:version>

```

Note:
The `BOOL` generator expression uses the same logic as the `if` command to determine if a string is true/false.


You can string these together in a few ways:
```cmake
set(X1 "$<$<VERSION_LESS:$<CXX_COMPILER_VERSION>,4.2.0>:OLD_COMPILER>")
message(STATUS "X1 = ${X1}")

# OR

set(IsOldCompiler "$<VERSION_LESS:$<CXX_COMPILER_VERSION>,4.2.0>")
set(X2 "$<${IsOldCompiler}:OLD_COMPILER>")
message(STATUS "X2 = ${X1}")
```
<br />

Both of these produce the same output:
```shell
-- X1 = $<$<VERSION_LESS:$<CXX_COMPILER_VERSION>,4.2.0>:OLD_COMPILER>
-- X2 = $<$<VERSION_LESS:$<CXX_COMPILER_VERSION>,4.2.0>:OLD_COMPILER>
```

Note:
`X1` is more lines, but is also more readable, so that's my preference.
I wouldn't ever nest more than two levels of generator expressions.
These could potentially be strung together into some absolutely horrendous lines, so it is better to break them up into discrete blocks.
And this is coming from someone who used to script in perl.
