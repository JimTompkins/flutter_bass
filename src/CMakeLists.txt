cmake_minimum_required(VERSION 3.18)

add_library(bass-lib SHARED IMPORTED GLOBAL)

set_target_properties( bass-lib PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/../android/Libs/BASS/${ANDROID_ABI}/libbass.so )
