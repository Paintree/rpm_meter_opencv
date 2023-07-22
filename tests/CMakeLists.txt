cmake_minimum_required(VERSION 3.10)

enable_testing()

project(rpm_meter_tests LANGUAGES C CXX)

set(TEST_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src")
set(TEST_INC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/inc")
set(PROJ_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../src")
set(PROJ_INC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../inc")
set(BUILD_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../build")
set(OpenCV_DIR "${BUILD_DIR}/opencv")
set(GOOGLETEST_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../external/googletest")
include_directories("${PROJ_INC_DIR}")
include_directories("${TEST_INC_DIR}")

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