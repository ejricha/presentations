# Simple Examples

---

## Add an executable
```cmake
add_executable(app main.cpp)
```

* The first argument (`app`) is the **target** to build
* It is followed by the **source** file(s) to build from

*Header files can be found automatically, and are not usually listed*


### All options to [`add_executable`](https://cmake.org/cmake/help/latest/command/add_executable.html)
```cmake
add_executable(<name> [WIN32] [MACOSX_BUNDLE]
               [EXCLUDE_FROM_ALL]
               [source1] [source2 ...])
```
* `<name>` : the name of the target to build into an executable
* `WIN32` and `MACOSX_BUNDLE` : OS-specific
* `EXCLUDE_FROM_ALL` : prevent a top-level `make all` (or similar) from building this target

Note:
The target name must be globally unique, so sometimes you will see targets with a prefix of `${PROJECT_NAME}` or some other project-specific variable

Exactly one of the source files must define a `main()` function


### The suffix of an executable is OS-specific:
* On Windows, target `app` will become `app.exe`
* On Linux, there is no suffix, so it's just `app`

You can override this by setting `CMAKE_EXECUTABLE_SUFFIX`:
```cmake
set(CMAKE_EXECUTABLE_SUFFIX .bin)
```
Now target `app` will produce executable `app.bin`

---

## Add a library
The syntax to add a library is very similar to that used to add an executable:
```cmake
add_library(cat cat.cpp)
```
* The first argument (`cat`) is still the name of the **target**
* The **source** file(s) follow

Note: "How does CMake determine what kind of library to build?", I don't hear you asking


### All options to [`add_library`](https://cmake.org/cmake/help/latest/command/add_library.html)
```cmake
add_library(<name> [STATIC | SHARED | MODULE | OBJECT]
            [EXCLUDE_FROM_ALL]
            [source1] [source2 ...])
```
* `<name>` : the name of the target
* The **Library Type** comes next:
 * `STATIC` : a static library
 * `SHARED` : a shared library
 * `MODULE` : a shared library
 * If the type is omitted, the `BUILD_SHARED_LIBS` variable will be used to decide between `STATIC` and `SHARED`
* `EXCLUDE_FROM_ALL` : same as for `add_executable(...)`

Note:
Before I go too far, does everyone understand the syntax of the documentation?
* Angle brackets < > define a **required** parameter
* Square brackets [ ] define *optional* parameters
* Pipes | mean only one of the parameters is valid
* An ellipsis ... means that more than one parameter can be defined

---

## Linking a library to an executable
This is the next most common thing that you may want to do. If your application target `app` depends on your library target `cat`, you need to add the following *after you have defined both targets*:
```cmake
target_link_libraries(app PUBLIC cat)
```
The second argument `PUBLIC` says that both the symbols in `cat` and any of the symbols in libraries that `cat` depends on are visible to `app`


TODO: Add examples of linking with all 3 link types


### All options to [`target_link_libraries`](https://cmake.org/cmake/help/latest/command/target_link_libraries.html)
```cmake
target_link_libraries(<target>
                      <PRIVATE|PUBLIC|INTERFACE> <item>...
                     [<PRIVATE|PUBLIC|INTERFACE> <item>...]...)
```


A complex structure such as this is allowed:
```cmake
target_link_libraries(cat
    PUBLIC    a b
    PRIVATE   c d
    INTERFACE e
    PUBLIC    f g
```
![](cmake/VariousLinkTypes.svg)
* `PUBLIC` produces solid lines
* `PRIVATE` produces dashed lines
* `INTERFACE` produces dotted lines

Note:
Clearly, CMake doesn't really care about whitespace. My recommendation is to put things on a single line, unless you are specifying more than one link type
