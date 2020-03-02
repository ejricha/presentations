# Tricks

Lists and strings:
```cmake
set(_stringName "strings can have spaces")
list(JOIN _listAsAString " " _listName)
```

Custom commands and targets:
```cmake
separate_arguments(_command NATIVE_COMMAND "ls -al ${dir} && df -hT")
```
