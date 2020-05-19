# Messages

One important way to debug `CMakeLists.txt` files is by using the [`message`](https://cmake.org/cmake/help/latest/command/message.html) command:
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

Note:
These are the only available modes. Probably the ones you'll use most are `STATUS` and `FATAL_ERROR`.


### Example:
```cmake
message(STATUS      a)
message(ERROR       b)
message(FATAL_ERROR c)
message(STATUS      d)
```

Produces output:
```shell
$ cmake -GNinja ..
...
-- a
ERRORb
CMake Error at CMakeLists.txt:5 (message):
  c
-- Configuring incomplete, errors occurred!
```

Note:
Only `FATAL_ERROR` actually stops processing the CMakeLists.txt. This is useful when you really want to show exactly why you cannot proceed with generating.

Also not the `ERRORb` output line. If you try to send something like `message(ERROR something)`, you will get the `"ERRORsomething` as output.


### Setting the mode from a variable

It is also possible to use a variable to set the message level:
```cmake
set(MODE TRACE CACHE STRING "Message mode/level")
message(${MODE} "message(${MODE})")
```
Produces output:
```shell
$ cmake .. -GNinja -DMODE:STRING=STATUS
-- message(STATUS)
$ cmake .. -GNinja -DMODE:STRING=NOTICE
message(NOTICE)
```

Note:
More on variables and cache variables shortly.


To make absolutely every message from CMake visible:
```shell
cmake --log-level=TRACE ...
```
<br />

At least on my Linux system:
* `STATUS` messages and below get sent to `stdout`
	* They are also prefixed with `-- `
* `NOTICE` messages and above get sent to `stderr`
	* And show up in red in `cmake-gui`
