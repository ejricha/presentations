<!-- Chapter 14 -->

## Properties
Note: The old style of CMake let you specify global properties.
With modern CMake, you can specify these properties per target (or directory).


There are a few per-target properties that you can set:

Target | Interface
--- | ---
`INCLUDE_DIRECTORIES` | `INTERFACE_INCLUDE_DIRECTORIES`
`COMPILE_DEFINITIONS` | `INTERFACE_COMPILE_DEFINITIONS`
`COMPILE_OPTIONS` | `INTERFACE_COMPILE_OPTIONS`

Note: The properties in the left column apply to the target itself.
Those in the right column apply to anything that links to the target.
