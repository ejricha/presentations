## Build types

There are by default 4 build types:

Name | Description
--- | ---
`Debug` | All debugging information, including assertions
`RelWithDebInfo` | Some debug information, but no assertions
`Release` | Release optimized for speed
`MinSizeRel` | Release optimized for size

Note:
When launching CMake, you may have seen the `-DCMAKE_BUILD_TYPE=Debug` parameter passed in


Here are the defaults on my Linux system using `g++` for `CMAKE_<LANG>_FLAGS_<TYPE>`:
```list
$ cmake .. -GNinja
-- CMAKE_CXX_FLAGS =
-- CMAKE_CXX_FLAGS_DEBUG = -g
-- CMAKE_CXX_FLAGS_RELEASE = -O3 -DNDEBUG
-- CMAKE_CXX_FLAGS_RELWITHDEBINFO = -O2 -g -DNDEBUG
-- CMAKE_CXX_FLAGS_MINSIZEREL = -Os -DNDEBUG
-- CMAKE_C_FLAGS =
-- CMAKE_C_FLAGS_DEBUG = -g
-- CMAKE_C_FLAGS_RELEASE = -O3 -DNDEBUG
-- CMAKE_C_FLAGS_RELWITHDEBINFO = -O2 -g -DNDEBUG
-- CMAKE_C_FLAGS_MINSIZEREL = -Os -DNDEBUG
```

Note:
I also ran with `-DCMAKE_CXX_COMPILER:STRING=/usr/bin/clang` and got the exact same results


And here is the `CMakeLists.txt` that produced that output:
```cmake
# Show the info for the different types
set(Types Debug Release RelWithDebInfo MinSizeRel)
foreach(LANG IN ITEMS CXX C)
	set(Flags CMAKE_${LANG}_FLAGS)
	message(STATUS "${Flags} = ${${Flags}}")
	foreach(Type IN LISTS Types)
		string(TOUPPER ${Type} TYPE)
		set(Flags CMAKE_${LANG}_FLAGS_${TYPE})
		message(STATUS "${Flags} = ${${Flags}}")
	endforeach()
endforeach()
```

Note:
Notice that you can actually nest variables within variables.
For example, `${Flags}` is set to a string like `"CMAKE_CXX_FLAGS_DEBUG"`, and `${${FLAGS}}` returns `${CMAKE_CXX_FLAGS_DEBUG}`.
This is a good way to print both the name and the value of a variable.

---

# Generators

There are two types of generators that CMake can use:
* Single-config (e.g. Ninja, GNU Makefiles)
* Multi-config (e.g. MSVC, Xcode)

The generator can be specified on the command-line by using the `-G` flag:
```shell
cmake -GNinja
# (or)
cmake -G"Unix Makefiles"
# (or)
cmake -G "Visual Studio 16 2019"
```

Note:
Notice that quotes are required if the generator contains a space.


To see what generators are available on your system:
```shell
$ cmake --help
...
Options
  -G <generator-name>          = Specify a build system generator.
...
The following generators are available on this platform (* marks default):
* Unix Makefiles               = Generates standard UNIX makefiles.
  Ninja                        = Generates build.ninja files.
  Ninja Multi-Config           = Generates build-<Config>.ninja files.
  CodeBlocks - Ninja           = Generates CodeBlocks project files.
  CodeLite - Unix Makefiles    = Generates CodeLite project files.
  Kate - Ninja                 = Generates Kate project files.
  Eclipse CDT4 - Ninja         = Generates Eclipse CDT 4.0 project files.
...
```


## Single-configuration

This type of generator usually has a build directory for each build type:
```shell
$ ls -1F
build_make_Debug/
build_make_Release/
build_ninja_RelWithDebInfo/
build_ninja_Release/
src/
CMakeLists.txt
```
Note:
Remember the concept of build types, e.g. `Release`, `Debug`, etc.? Here is where that comes into play.


## Multi-configuration

* These generators do *not* require a different build directory for each build type.
* It doesn't really make sense to have a `build_MSVC_Debug` directory, because every build directory for MSVC is capable of switching build types.

*(The way it does this is to have a subdirectory for each build type that is used)*


### A brief word about build locations

* Back in the days of `make` and `autotools`, applications and binaries were often mixed in with source code.
* This is referred to as an "**in-source**" build.
* This required keeping a close eye on `.gitignore` files, and excluding things that were not really source code


CMake is a little different, as the most common method is using an "**out-of-source**" build directory.

The normal use case looks something like this:
```shell
mkdir -p build && cd build
cmake -GNinja ..
```

This ensures that your build targets don't end up cluttering the source directory.

Note:
You might notice that in my examples the build directories sit next to the top-level CMakeLists.txt.
Craig Scott says that this hybrid approach is acceptable, what you really want to ensure is that you are building in a directory that can be easily removed without affecting any source code.
