## Working with files

Easy to get parts of a file path
```cmake
set(FullFilePath /tmp/cmake_test/f.x.y.z)
get_filename_component(FileDir ${FullFilePath} DIRECTORY)
get_filename_component(FileName ${FullFilePath} NAME)
get_filename_component(FileWithoutLongestExtension ${FullFilePath} NAME_WE)
get_filename_component(FileExtension ${FullFilePath} EXT)
get_filename_component(FileWithoutLastExtension ${FullFilePath} NAME_WLE)
get_filename_component(FileLastExtension ${FullFilePath} LAST_EXT)
```
```shell
-- [/tmp/cmake_test/f.x.y.z]
--   DIRECTORY : /tmp/cmake_test
--   NAME      : f.x.y.z
--   NAME_WE   : f
--   EXT       : .x.y.z
--   NAME_WLE  : f.x.y
--   LAST_EXT  : .z
```
