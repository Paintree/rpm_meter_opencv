cmake_minimum_required(VERSION 3.10)

if (WIN32)
    add_compile_definitions("WIN32")
endif (WIN32)
if (UNIX)
    add_compile_definitions("UNIX")
endif(UNIX)

set(TARGET "rpm_meter")
set(PROJECT_NAME "${TARGET} project")
set(PROJECT_DESCRIPTION "Application estimating revolutions per minute of an object based on its video footage")

set(CMAKE_CXX_COMPILER g++)
set(CMAKE_C_COMPILER gcc)
set(CMAKE_LINKER ld)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

project(${PROJECT_NAME} LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 20)
set(INCLUDE_PATH "${PROJECT_SOURCE_DIR}/inc")
set(SRC_PATH "${PROJECT_SOURCE_DIR}/src")
set(BUILD_DIR "${PROJECT_SOURCE_DIR}/build")
set(OpenCV_DIR "${BUILD_DIR}/opencv")
include_directories("${INCLUDE_PATH}")




find_package(OpenCV REQUIRED)

if (UNIX)
find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK REQUIRED gtk+-3.0)
include_directories(${GTK_INCLUDE_DIRS})
link_directories(${GTK_LIBRARY_DIRS})
add_definitions(${GTK_CFLAGS_OTHER})
endif (UNIX)

option(BUILD_WITH_STATIC_CRT "help string" OFF)

include_directories(${OpenCV_INCLUDE_DIRS})

file(GLOB_RECURSE USER_SRCS "${SRC_PATH}/*.c" "${SRC_PATH}/*.cpp")
add_executable(${TARGET} ${USER_SRCS})

if (WIN32)
    target_link_libraries(${TARGET} PRIVATE ${OpenCV_LIBS} -static)
endif (WIN32)
if (UNIX)
    target_link_libraries(${TARGET} PRIVATE ${OpenCV_LIBS} ${GTK_LIBRARIES})
    # target_compile_definitions(${TARGET} PRIVATE ${GTKMM_CFLAGS_OTHER})
    # target_link_directories(${TARGET} PRIVATE ${GTKMM_LIBRARY_DIRS})
endif(UNIX)

