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
