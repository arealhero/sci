cmake_minimum_required(VERSION 3.20)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

project (sci)

set (CMAKE_INSTALL_PREFIX out)
set (CMAKE_INSTALL_INCLUDEDIR include)
set (CMAKE_INSTALL_LIBDIR lib)

include (utils)
include (use_latex)

add_subdirectory (papers)
add_subdirectory (reports)
