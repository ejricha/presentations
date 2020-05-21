## Working with files

Easy to get parts of a file path
```cmake
set(FullFilePath /tmp/cmake_test/f.x.y.z)
get_filename_component(FileDir ${FullFilePath} DIRECTORY)
get_filename_component(FileName ${FullFilePath} NAME)
get_filename_component(FileWithoutLongestExtension ${FullFilePath} NAME_WE)
get_filename_component(FileExtension ${FullFilePath} EXT)
get_filename_component(FileWithoutLastExtension ${FullFilePath} NAME_WLE)
get_filename_component(FileLastExtension ${FullFilePath} LAST_EXT)
```
```shell
-- [/tmp/cmake_test/f.x.y.z]
--   DIRECTORY : /tmp/cmake_test
--   NAME      : f.x.y.z
--   NAME_WE   : f
--   EXT       : .x.y.z
--   NAME_WLE  : f.x.y
--   LAST_EXT  : .z
```


## Using the [`file`](https://cmake.org/cmake/help/latest/command/file.html) command
```cmake
# Reading
  file(READ <filename> <out-var> [...])
  file(STRINGS <filename> <out-var> [...])
  file(<HASH> <filename> <out-var>)
  file(TIMESTAMP <filename> <out-var> [...])
  file(GET_RUNTIME_DEPENDENCIES [...])

# Writing
  file({WRITE | APPEND} <filename> <content>...)
  file({TOUCH | TOUCH_NOCREATE} [<file>...])
  file(GENERATE OUTPUT <output-file> [...])
```


More `file` options:
```cmake
# Filesystem
  file({GLOB | GLOB_RECURSE} <out-var> [...] [<globbing-expr>...])
  file(RENAME <oldname> <newname>)
  file({REMOVE | REMOVE_RECURSE } [<files>...])
  file(MAKE_DIRECTORY [<dir>...])
  file({COPY | INSTALL} <file>... DESTINATION <dir> [...])
  file(SIZE <filename> <out-var>)
  file(READ_SYMLINK <linkname> <out-var>)
  file(CREATE_LINK <original> <linkname> [...])
```


Even more `file` options:
```cmake
# Path Conversion
  file(RELATIVE_PATH <out-var> <directory> <file>)
  file({TO_CMAKE_PATH | TO_NATIVE_PATH} <path> <out-var>)

# Transfer
  file(DOWNLOAD <url> <file> [...])
  file(UPLOAD <file> <url> [...])

# Locking
  file(LOCK <path> [...])
```


### Globbing target dependencies
This is not a good idea, but it is possible to use the `file(GLOB ...)` command to set target dependencies
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
```shell
$ touch CMakeCache.txt 
$ make
...
Scanning dependencies of target targetFromGlob
[ 25%] Building CXX object CMakeFiles/targetFromGlob.dir/c.cpp.o
[ 50%] Linking CXX executable targetFromGlob
[100%] Built target targetFromGlob
```
As a general rule, you don't usually want to have to force CMake to run when it's something you build system (`make`/`ninja`) really *ought* to be able to do
