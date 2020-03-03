## Replacing bash/python scripts with `CMake`

The `cmake -E` command can be used in place of bash scripts

Even better, use `${CMAKE_COMMAND} -E`, so that whatever version of CMake is currently running will continue to be used.

```cmake
execute_process(
    COMMAND ${CMAKE_COMMAND} -E touch ${FileName}
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${LinkName}
    )
```

Note:
For example, if your default `cmake` is version 3.8, but you manually ran `cmake` version 3.16 from some other location, this prevents the `cmake -E` commands from running with the old version.


Useful commands:
* `touch` and `make_directory`
* `copy` and `copy_directory`
* `remove` and `remove_directory`
* `rename`
* `echo`
* `time`
* `copy_if_different`
* `compare_files`
* `md5sum`
* `tar`


For more information, see https://cmake.org/cmake/help/latest/manual/cmake.1.html#run-a-command-line-tool, or run `cmake -E`:
```shell
$ cmake -E
Usage: cmake -E <command> [arguments...]
Available commands:
  capabilities              - Report capabilities built into cmake in JSON format
  chdir dir cmd [args...]   - run command in a given directory
  compare_files [--ignore-eol] file1 file2
                              - check if file1 is same as file2
  copy <file>... destination  - copy files to destination (either file or directory)
  copy_directory <dir>... destination   - copy content of <dir>... directories to 'destination' directory
  copy_if_different <file>... destination  - copy files if it has changed
  echo [<string>...]        - displays arguments as text
  echo_append [<string>...] - displays arguments as text but no new line
  env [--unset=NAME]... [NAME=VALUE]... COMMAND [ARG]...
                            - run command in a modified environment
  environment               - display the current environment
  make_directory <dir>...   - create parent and <dir> directories
  ...
  create_symlink old new    - create a symbolic link new -> old
  true                      - do nothing with an exit code of 0
  false                     - do nothing with an exit code of 1
```
