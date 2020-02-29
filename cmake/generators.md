## Build types

There are by default four build types:
* `Debug` : All debugging information, including assertions
* `RelWithDebInfo` : Some debug information, but no assertions
* `Release` : Optimized for speed
* `MinSizeRel` : Optimized for size rather than speed

Note:
When launching CMake, you may have seen the `-DCMAKE_BUILD_TYPE=Debug` parameter passed in

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
You might notice that in my example a few slides back my build directories sit next to the top-level CMakeLists.txt.
Craig Scott says that this hybrid approach is acceptable, what you really want to ensure is that you are building in a directory that can be easily removed without affecting any source code.
