cmake_minimum_required(VERSION 3.10)

set(CMAKE_GENERATOR "MinGW Makefiles")
set(TARGET "rpm_meter")
set(PROJECT_NAME "${TARGET} project")
set(PROJECT_DESCRIPTION "Application estimating revolutions per minute of an object based on its video footage")

set(CMAKE_CXX_COMPILER g++)
set(CMAKE_C_COMPILER gcc)
set(CMAKE_LINKER ld)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

project(${PROJECT_NAME} LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)

set(INCLUDE_PATH "${PROJECT_SOURCE_DIR}/include")
set(SRC_PATH "${PROJECT_SOURCE_DIR}/src")
set(BUILD_DIR "${PROJECT_SOURCE_DIR}/build")

include_directories("${INCLUDE_PATH}")


set(OpenCV_DIR "C:/DEVKITS/opencv/build/x64/vc16/lib")
find_package(OpenCV REQUIRED)
include_directories(${OpenCV_INCLUDE_DIRS})

# Add your own project's source files
file(GLOB_RECURSE USER_SRCS "${SRC_PATH}/*.c" "${SRC_PATH}/*.cpp")
add_executable(${TARGET} ${USER_SRCS})

# Link OpenCV libraries to your project
target_link_libraries(${TARGET} ${OpenCV_LIBS})

set_target_properties(${TARGET} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${BUILD_DIR})