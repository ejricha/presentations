# Useful CMake variables

Read-only variables:
* Use `${CMAKE_COMMAND} -E ` instead of `cmake -E`

	Settable variables:
* `CMAKE_BUILD_TYPE` : `Debug`, `Release`, `RelWithDebInfo`, `MinSizeRel`
* `CMAKE_EXECUTABLE_SUFFIX` : set to add or change e.g. `.exe`

Symbol visibility:
* `CMAKE_CXX_VISIBILITY_PRESET` : `hidden` to make `gcc`/`clang` act like MSVC
* `CMAKE_VISIBILITY_INLINES_HIDDEN` : `YES`, in conjunction with the above
