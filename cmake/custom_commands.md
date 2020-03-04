# Custom Commands

* To run a custom command at configuration time, use `execute_process`
* To run a custom command at build time, use `add_custom_command` and `add_custom_target`


## Options for [`execute_process`](https://cmake.org/cmake/help/latest/command/execute_process.html)
```cmake
execute_process(COMMAND <cmd1> [<arguments>]
                [COMMAND <cmd2> [<arguments>]]...
                [WORKING_DIRECTORY <directory>]
                [TIMEOUT <seconds>]
                [RESULT_VARIABLE <variable>]
				...
                [OUTPUT_QUIET]
                [ERROR_QUIET]
                [COMMAND_ECHO <where>]
                [OUTPUT_STRIP_TRAILING_WHITESPACE]
                [ERROR_STRIP_TRAILING_WHITESPACE]
                [ENCODING <name>])
```


*I won't spend too much time on this, because most of the time you want to run commands at build time, but here's a good use case that we'll see again shortly:*
```cmake
execute_process(
    COMMAND ${CMAKE_COMMAND} -E touch ${FileName}
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${FileName} ${LinkName}
    )
```
This command runs at configure time, and it creates a files with a symbolic link to it.


## Options for [`add_custom_command`](https://cmake.org/cmake/help/latest/command/add_custom_command.html)
```cmake
add_custom_command(OUTPUT output1 [output2 ...]
                   COMMAND command1 [ARGS] [args1...]
                   [COMMAND command2 [ARGS] [args2...] ...]
                   [MAIN_DEPENDENCY depend]
                   [DEPENDS [depends...]]
                   [BYPRODUCTS [files...]]
                   [IMPLICIT_DEPENDS <lang1> depend1
                                    [<lang2> depend2] ...]
                   [WORKING_DIRECTORY dir]
                   [COMMENT comment]
                   [DEPFILE depfile]
                   [JOB_POOL job_pool]
                   [VERBATIM] [APPEND] [USES_TERMINAL]
                   [COMMAND_EXPAND_LISTS])
```


## Options for [`add_custom_target`](https://cmake.org/cmake/help/latest/command/add_custom_target.html)
```cmake
add_custom_target(Name [ALL] [command1 [args1...]]
                  [COMMAND command2 [args2...] ...]
                  [DEPENDS depend depend depend ... ]
                  [BYPRODUCTS [files...]]
                  [WORKING_DIRECTORY dir]
                  [COMMENT comment]
                  [JOB_POOL job_pool]
                  [VERBATIM] [USES_TERMINAL]
                  [COMMAND_EXPAND_LISTS]
                  [SOURCES src1 [src2...]])
```


TODO: Show how `add_custom_command` and `add_custom_target` are used together.
