cmake_minimum_required(VERSION 3.10)

if (WIN32)
    add_compile_definitions("WIN32")
endif (WIN32)
if (UNIX)
    add_compile_definitions("UNIX")
endif(UNIX)

# set(PROJECT_NAME _tests)

enable_testing()

# set(CMAKE_CXX_COMPILER g++)
# set(CMAKE_C_COMPILER gcc)
# set(CMAKE_LINKER ld)
# set(CMAKE_SYSTEM_PROCESSOR x86_64)

project(rpm_meter_tests LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 20)
set(TEST_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src")
set(TEST_INC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/inc")
set(PROJ_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../src")
set(PROJ_INC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../inc")
set(BUILD_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../build")
set(OpenCV_DIR "${BUILD_DIR}/opencv")
set(GOOGLETEST_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../external/googletest")
include_directories("${PROJ_INC_DIR}")
include_directories("${TEST_INC_DIR}")


# Include OpenCV

find_package(OpenCV REQUIRED)
option(BUILD_WITH_STATIC_CRT "help string" OFF)
include_directories(${OpenCV_INCLUDE_DIRS})

# Include GTK

if (UNIX)
find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK REQUIRED gtk+-3.0)
include_directories(${GTK_INCLUDE_DIRS})
link_directories(${GTK_LIBRARY_DIRS})
add_definitions(${GTK_CFLAGS_OTHER})
endif (UNIX)

# Include GOOGLE TESTS

set(GTestSrc ${GOOGLETEST_DIR}/googletest)
set(GMockSrc ${GOOGLETEST_DIR}/googlemock)

set(GTestFiles ${GTestSrc}/src/gtest-all.cc)
set(GTestIncludes ${GTestSrc} ${GTestSrc}/include)

if (NOT ${GMockSrc} STREQUAL "")
    list(APPEND GTestFiles ${GMockSrc}/src/gmock-all.cc)
    list(APPEND GTestIncludes ${GMockSrc} ${GMockSrc}/include)
endif ()

include_directories(${GTestIncludes})

# Add SRCs to Target

file(GLOB_RECURSE USER_SRCS "${PROJ_SRC_DIR}/*.c" "${PROJ_SRC_DIR}/*.cpp")
list(REMOVE_ITEM USER_SRCS "${PROJ_SRC_DIR}/main.cpp")
file(GLOB_RECURSE TEST_SRCS "${TEST_SRC_DIR}/*.c" "${TEST_SRC_DIR}/*.cpp")
add_executable(${PROJECT_NAME} ${TEST_SRCS} ${USER_SRCS} ${GTestFiles})

add_test(NAME ${PROJECT_NAME} COMMAND ${PROJECT_NAME})

if (WIN32)
    target_link_libraries(${PROJECT_NAME} PRIVATE ${OpenCV_LIBS} -static)
endif (WIN32)
if (UNIX)
    target_link_libraries(${PROJECT_NAME} PRIVATE ${OpenCV_LIBS} ${GTK_LIBRARIES})
endif(UNIX)