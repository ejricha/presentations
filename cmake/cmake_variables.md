# Useful CMake variables

Read-only variables:
* Use `${CMAKE_COMMAND} -E ` instead of `cmake -E`

Option:
`BUILD_SHARED_LIBS` : controls if libraries will be static or shared by default


Settable variables:
* `CMAKE_BUILD_TYPE` : set to `Debug`, `Release`, `RelWithDebInfo`, `MinSizeRel`
* `CMAKE_EXECUTABLE_SUFFIX` : set to add or change e.g. `.exe`


### Language-specific flags
For all of the below, `<LANG>` is the language (e.g. `CXX` or `C`), and `<TYPE>` is the build type (e.g. `DEBUG`)

* `CMAKE_<LANG>_COMPILER` : override the compiler
* `CMAKE_<LANG>_FLAGS_<TYPE>` : override the flags for the specific build type


### Control symbol visibility
* `CMAKE_CXX_VISIBILITY_PRESET` : `hidden` to make `gcc`/`clang` act like MSVC
* `CMAKE_VISIBILITY_INLINES_HIDDEN` : `YES`, in conjunction with the above
