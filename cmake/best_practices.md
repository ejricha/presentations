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
As previously stated, prefer this:
```cmake
add_executable(targetExplicit main.cpp a.cpp b.cpp)
```
...to this:
```cmake
add_executable(targetFromGlob "${CppFiles}")
```
