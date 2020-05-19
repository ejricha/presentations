## Including files and directories

* Use the `add_subdirectory` command to delve into directories
* Use the `include` command to add additional CMake scripts

```cmake
add_subdirectory(dir1)
include(dir2/HelperScript.cmake)
```

Note:
The `add_subdirectory` command expects the file `dir1/CMakeLists.txt` to exist, and this is what will be processed.

The `include` command is typically used to add existing CMake helper scripts.


## Options for [`add_subdirectory`](https://cmake.org/cmake/help/latest/command/add_subdirectory.html)
```cmake
add_subdirectory(source_dir [binary_dir] [EXCLUDE_FROM_ALL])
```

Note:
The `binary_dir` is typically omitted, but it can be used to specify an alternate relative or absolute location for binary files.

`EXCLUDE_FROM_ALL` is fairly self-explanatory: this directory will be omitted from a `make all` or similar build.


## Options for [`include`](https://cmake.org/cmake/help/latest/command/include.html)
```cmake
include(<file|module> [OPTIONAL] [RESULT_VARIABLE <var>] [NO_POLICY_SCOPE])
```
* If `OPTIONAL` is present, no error will be raised if the file or module is not found
* `RESULT_VARIABLE` will set `<var>` to the full filename, or `"NOTFOUND"`
* The `NO_POLICY_SCOPE` option is useful if you actually want to pull policies from an external file

Note:
A module is the name of a CMake script without the `.cmake` extension.
