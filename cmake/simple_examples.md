# Simple Examples


## Add an executable
```cmake
cmake_minimum_required(VERSION 3.15)
project(HelloWorld)

add_executable(App main.cpp)
```
* The top-level `CMakeLists.txt` **must** start with the `cmake_minimum_required(VERSION <X>)`
* The `project` should also be set
* The first argument (`App`) is the **target** to build
* It is followed by the **source** file(s) to build from

Note:
Each `CMakeLists.txt` can define at most one unique project, though it may define many libraries, executables, or other targets.
It's possible to keep only a single project for the entire repository, though usually the source tree is broken up into at least a few discrete projects.


`main.cpp`:
```cpp
#include <iostream>

int main() {
    std::cout << "Hello, world!\n";
}
```

Generating and running:
```shell
$ ls -1
  CMakeLists.txt
  main.cpp
$ mkdir build && cd build/
$ cmake .. -GNinja
$ ninja
$ ./App
Hello, world!
```

Note:
We will talk more about the `-G` "generator" flag later, but for now I'll just say that I prefer Ninja to the default of Make.


Directory created:
```shell
+build
 CMakeLists.txt
 main.cpp
```


`cmake` run:
```shell
+build/build.ninja
+build/CMakeCache.txt
+build/CMakeFiles
+build/CMakeFiles/3.17.20200216-g333a050
+build/CMakeFiles/3.17.20200216-g333a050/CMakeCXXCompiler.cmake
 ...
+build/CMakeFiles/3.17.20200216-g333a050/CompilerIdCXX/tmp
+build/CMakeFiles/App.dir
+build/CMakeFiles/cmake.check_cache
+build/CMakeFiles/CMakeOutput.log
+build/CMakeFiles/CMakeTmp
+build/CMakeFiles/rules.ninja
+build/CMakeFiles/TargetDirectories.txt
+build/cmake_install.cmake
```

Note:
The most important of these is `CMakeCache.txt`, where all the cache variables are stored.


`ninja` run:
```shell
+build/CMakeFiles/App.dir/main.cpp.o
+build/.ninja_log
+build/App
+build/.ninja_deps
```

Note:
You can see that the object file was placed in a custom directory, and `App` was at the top-level of the build directory.

---

### All options to [`add_executable`](https://cmake.org/cmake/help/latest/command/add_executable.html)
```cmake
add_executable(<name> [WIN32] [MACOSX_BUNDLE]
               [EXCLUDE_FROM_ALL]
               [source1] [source2 ...])
```
* `<name>` : the name of the target to build into an executable
* `WIN32` and `MACOSX_BUNDLE` : OS-specific
* `EXCLUDE_FROM_ALL` : prevent a top-level `make all` (or similar) from building this target

*Header files can be found automatically, and are not usually listed*

Note:
The target name must be globally unique, so sometimes you will see targets with a prefix of `${PROJECT_NAME}` or some other project-specific variable

Exactly one of the source files must define a `main()` function


### The suffix of an executable is OS-specific:
* On Windows, target `App` will become `App.exe`
* On Linux, there is no suffix, so it's just `App`

This can be overridden with setting `CMAKE_EXECUTABLE_SUFFIX`:
```cmake
set(CMAKE_EXECUTABLE_SUFFIX .bin)
```
Now target `App` will produce executable `App.bin`


You do not have to run `cmake` again, even though you changed the `CMakeLists.txt`:
```shell
$ ninja
[0/1] Re-running CMake...
-- Configuring done
-- Generating done
-- Build files have been written to: </build/dir>
[1/1] Linking CXX executable App.bin
```

The new application was built:
```shell
$ ls -1
App
App.bin
build.ninja
CMakeCache.txt
CMakeFiles
cmake_install.cmake
```

Note:
Every target has an implied dependency on all the `CMakeLists.txt` files, as well as `CMakeCache.txt` in the build directory.
Also note that the original `App` is still there, and that not even a `ninja clean` will remove it.

---

## Add a library
The syntax to add a library is very similar to that used to add an executable:
```cmake
add_library(Cat cat.cpp)
```
* The first argument (`Cat`) is still the name of the **target**
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

If `App` depends on `Cat`:
```cmake
target_link_libraries(App PUBLIC Cat)
```
* `PUBLIC` : the symbols in `Cat`, **and** any of the symbols in libraries that `Cat` depends on, are visible to `App`
* `target_link_libraries` must come *after* the target is created
* Can be used for applications, libraries, or other custom targets

Note:
This is the next most common thing that you may want to do. If your application target `App` depends on your library target `Cat`, you need to add the following *after you have defined both targets*



TODO: Add examples of linking with all 3 link types


### All options to [`target_link_libraries`](https://cmake.org/cmake/help/latest/command/target_link_libraries.html)
```cmake
target_link_libraries(<target>
                      <PRIVATE|PUBLIC|INTERFACE> <item>...
                     [<PRIVATE|PUBLIC|INTERFACE> <item>...]...)
```


A complex structure such as this is allowed:
```cmake
target_link_libraries(Cat
    PUBLIC    A B
    PRIVATE   C D
    INTERFACE E
    PUBLIC    F G
    )
```
![](cmake/VariousLinkTypes.svg)
* `PUBLIC` produces solid lines
* `PRIVATE` produces dashed lines
* `INTERFACE` produces dotted lines

Note:
Clearly, CMake doesn't really care about whitespace. My recommendation is to put things on a single line, unless you are specifying more than one link type
