## Problem
I want to create a library with a cyclic dependency

---

First, here's an example of building with static libs, which works just fine:
```shell
$ mkdir -p build_with_static2libs     
$ cd build_with_static2libs
$ cmake -DBUILD_SHARED_LIBS:BOOL=OFF ..
...
-- Configuring done
-- Generating done
```

---

By running [a script from my GitHub repo](https://github.com/ejricha/scripts/blob/master/bash/graph_dependencies.sh), you can get a clickable dependencies graph:
```shell
$ ~/software/github/ejricha/scripts/bash/graph_dependencies.sh
```
![](cmake/TestCycle.svg)

---

But if I try the same thing with shared libraries:
```shell
CMake Error: The inter-target dependency graph contains the following
 strongly connected component (cycle):
  "A" of type SHARED_LIBRARY
    depends on "B" (weak)
    depends on "C" (weak)
  "B" of type SHARED_LIBRARY
    depends on "C" (weak)
    depends on "A" (weak)
  "C" of type SHARED_LIBRARY
    depends on "A" (weak)
    depends on "B" (weak)
At least one of these targets is not a STATIC_LIBRARY.  Cyclic dependencies
 are allowed only among static libraries.
CMake Generate step failed.  Build files cannot be regenerated correctly.
```

---

Top-level CMakeLists.txt
```cmake
cmake_minimum_required(VERSION 3.15)
project(TestCycle LANGUAGES CXX)

add_subdirectory(ExecutableApp)
add_subdirectory(LibraryA)
add_subdirectory(LibraryB)
add_subdirectory(LibraryC)
```

---

`ExecutableApp/CMakeLists.txt`
```cmake
cmake_minimum_required(VERSION 3.15)
project(TestCycleMain LANGUAGES CXX)

add_executable(TestCycle test_cycle.cpp)

# TestCycle depends on A
target_link_libraries(TestCycle A)
```

---

Create a circular dependency
```cmake
cmake_minimum_required(VERSION 3.15)
project(LibraryA LANGUAGES CXX)
add_library(A a.cpp)
target_link_libraries(A B)
```
```cmake
cmake_minimum_required(VERSION 3.15)
project(LibraryB LANGUAGES CXX)
add_library(B b.cpp)
target_link_libraries(B C)
```
```cmake
cmake_minimum_required(VERSION 3.15)
project(LibraryC LANGUAGES CXX)
add_library(C c.cpp)
target_link_libraries(C A)
```
