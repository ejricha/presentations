# Messages

One important way to debug `CMakeLists.txt` files is by using the [message](https://cmake.org/cmake/help/latest/command/message.html) command:
```cmake
message([<mode>] "message text" ...)
```


Available modes:
* `TRACE`
* `DEBUG`
* `VERBOSE`
* `STATUS`
* `NOTICE`
* `DEPRECATION`
* `AUTHOR_WARNING`
* `WARNING`
* `SEND_ERROR`
* `FATAL_ERROR`


### Example:
```cmake
message(STATUS      A)
message(NOTICE      B)
message(FATAL_ERROR C)
message(STATUS      D)
```

Produces output:
```shell
$ cmake -GNinja ..
...
-- A
B
CMake Error at CMakeLists.txt:5 (message):
  C
-- Configuring incomplete, errors occurred!
```

Note:
Only FATAL_ERROR actually stops processing the CMakeLists.txt. This is useful when you really want to show exactly why you cannot proceed with generating.


To make absolutely every message from CMake visible:
```shell
cmake --log-level=TRACE ...
```

At least on my Linux system:
* `STATUS` messages and below get sent to `stdout`
* `NOTICE` messages and above get sent to `stderr`
