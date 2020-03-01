## Symbol visiblity

Without going into too much detail:
* Symbols are **visible** by default in `gcc` and `clang`
* Symbols are **hidden** by default in `MSVC`

A symbol can be:
* A class
* A function outside of a class
* A global variable


To set the visibilty to the same defaults across all platforms:
```cmake
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)
...
generate_export_header(TargetName)
```

For more information, see Craig Scott's ["Deep CMake for Library Authors"](https://www.youtube.com/watch?v=m0DwB4OvDXk) talk from CppCon 2019
