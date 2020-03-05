## Problem
I want to create a library with a cyclic dependency


Here is a graph of the project that I created, generated with `cmake --graphviz=...`:

![](cmake/TestCycle.svg)

Note:
By running [a script from my GitHub repo](https://github.com/ejricha/scripts/blob/master/bash/graph_dependencies.sh), you can get a clickable dependencies graph:
```shell
$ ~/software/github/ejricha/scripts/bash/graph_dependencies.sh

```


### Top-level `CMakeLists.txt`
```cmake
cmake_minimum_required(VERSION 3.15)
project(TestCycle LANGUAGES CXX)

add_subdirectory(ExecutableApp)
add_subdirectory(LibraryA)
add_subdirectory(LibraryB)
add_subdirectory(LibraryC)
```


### Add an application
```cmake
add_executable(TestCycle test_cycle.cpp)

# TestCycle depends on A
target_link_libraries(TestCycle PUBLIC A)
```

### Create a circular dependency
```cmake
# A depends on B
add_library(A a.cpp)
target_link_libraries(A PUBLIC B)

# B depends on C
add_library(B b.cpp)
target_link_libraries(B PUBLIC C)

# C depends on A
add_library(C c.cpp)
target_link_libraries(C PUBLIC A)
```
Note: These are the `CMakeLists.txt` files for LibraryA, LibraryB, and LibraryC, respectively.
I specified public linking, but I omitted the library types, because I want to control that via the `BUILD_SHARED_LIBS` variable.


First, here's an example of building with static libs, which works just fine:
```shell
$ mkdir -p build && cd build
$ cmake .. -GNinja -DBUILD_SHARED_LIBS:BOOL=OFF
...
-- Configuring done
-- Generating done
```


But if I try the same thing with shared libraries:
```shell
$ cmake .. -GNinja -DBUILD_SHARED_LIBS:BOOL=ON
...
CMake Error: The inter-target dependency graph contains the following strongly connected component (cycle):
  "A" of type SHARED_LIBRARY
    depends on "B" (weak)
    depends on "C" (weak)
  "B" of type SHARED_LIBRARY
    depends on "C" (weak)
    depends on "A" (weak)
  "C" of type SHARED_LIBRARY
    depends on "A" (weak)
    depends on "B" (weak)
At least one of these targets is not a STATIC_LIBRARY.  Cyclic dependencies are allowed only among static libraries.
CMake Generate step failed.  Build files cannot be regenerated correctly.
```
