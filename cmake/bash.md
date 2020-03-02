## Replacing bash/python scripts with `CMake`

The `cmake -E` command can be used in place of bash scripts

Even better, use `${CMAKE_CURRENT_BIN} -E`, so that whatever version of CMake is currently running will continue to be used.

Note:
For example, if your default `cmake` is version 3.8, but you manually ran `cmake` version 3.16 from some other location, this prevents the `cmake -E` commands from running with the old version.


Available commands:
* `compare_files`
* `copy`
* `copy_directory`
* `copy_if_different`
* `echo`
* `env`
* `make_directory`
* `md5sum`
* `remove`
* `remove_directory`
* `rename`
* `tar`
* `time`
* `touch`
