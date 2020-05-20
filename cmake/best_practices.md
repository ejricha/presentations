## Best practices


### Do not define or call a function or macro with a name that starts with a single underscore
If a function is redefined, it will prefix an underscore to the name


### Do not have variables and cache variables with the same name
As discussed before, it is too easy to mask one or the other


### Define properties as locally as possible
Instead of setting global variables that will affect every target, use the `target_*(...)` commands:
```cmake
target_compile_definitions(...)
target_compile_features(...)
target_compile_options(...)
target_include_directories(...)
target_link_libraries(...)
target_sources(...)
```


### Explicitly call out all target dependencies
Even though you could set target dependencies using the `file(GLOB ...)` command, you should prefer to list them explicitly:
```cmake
file(GLOB CppFiles "*.cpp")
add_executable(targetFromGlob "${CppFiles}")
```


Here's an example of why that is a bad idea:
```shell
$ ls -1vF *.cpp
a.cpp
b.cpp
$ mkdir build && cd build/
$ cmake ..
$ make
Scanning dependencies of target targetFromGlob
[ 33%] Building CXX object CMakeFiles/targetFromGlob.dir/a.cpp.o
[ 66%] Building CXX object CMakeFiles/targetFromGlob.dir/b.cpp.o
[100%] Linking CXX executable targetFromGlob
[100%] Built target targetFromGlob
```
This is fine: it picks up both `a.cpp` and `b.cpp` from the top-level directory


Now, let's add a new file:
```shell
$ touch ../c.cpp
$ make
[100%] Built target targetFromGlob
```
Notice that `make` doesn't know that it should care about *all* new `.cpp` files


Only CMake knows which files it should depend on:
```cmake
$ touch CMakeCache.txt 
$ make
...
Scanning dependencies of target targetFromGlob
[ 25%] Building CXX object CMakeFiles/targetFromGlob.dir/c.cpp.o
[ 50%] Linking CXX executable targetFromGlob
[100%] Built target targetFromGlob
```
As a general rule, you don't usually want to have to force CMake to run when it's something you build system (`make`/`ninja`) really *ought* to be able to do
