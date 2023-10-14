TARGET = rpm_meter
TARGET_TESTS = rpm_meter_tests

define shell_out
$(shell $(1))
endef


BUILD_DIR = build
TESTS_DIR = tests
EXTERNAL_DIR = external
OPENCV_DIR = opencv


.PHONY: build cmake all

all: clean_all build_opencv build

ifeq ($(OS),Windows_NT)

PROJECT_DIR = $(call shell_out, cd)
    
cmake:
	cmake -G "MinGW Makefiles" . -B ${PROJECT_DIR}/${BUILD_DIR}/${TARGET}

cmake_opencv:
	cmake -G "MinGW Makefiles" -DWITH_MSMF=OFF -DWITH_OBSENSOR=OFF -DBUILD_SHARED_LIBS=OFF ${PROJECT_DIR}\${EXTERNAL_DIR}\${OPENCV_DIR} -B ${PROJECT_DIR}\${BUILD_DIR}\${OPENCV_DIR}

build: cmake
	${MAKE} -C ${PROJECT_DIR}/${BUILD_DIR}/${TARGET}
	@echo "Built successfully!"

build_opencv: cmake_opencv
	${MAKE} -C ${PROJECT_DIR}/${BUILD_DIR}/${OPENCV_DIR}

clean_opencv:
	if exist ${PROJECT_DIR}\${BUILD_DIR}\${OPENCV_DIR} rmdir /s /q ${PROJECT_DIR}\${BUILD_DIR}\${OPENCV_DIR}

clean:
	if exist ${PROJECT_DIR}\${BUILD_DIR}\${TARGET} rmdir /s /q ${PROJECT_DIR}\${BUILD_DIR}\${TARGET}

clean_all:
	if exist ${PROJECT_DIR}\${BUILD_DIR} rmdir /s /q ${PROJECT_DIR}\${BUILD_DIR}

run:
	${PROJECT_DIR}\${BUILD_DIR}\${TARGET}\${TARGET}.exe

run_tests:
	${PROJECT_DIR}/${BUILD_DIR}/${TARGET}/${TESTS_DIR}/${TARGET_TESTS}.exe


else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)

PROJECT_DIR = ${shell pwd}
        
cmake:
	cmake . -B ${PROJECT_DIR}/${BUILD_DIR}/${TARGET}

cmake_opencv:
	cmake -DBUILD_SHARED_LIBS=OFF ${PROJECT_DIR}/${EXTERNAL_DIR}/${OPENCV_DIR} -B ${PROJECT_DIR}/${BUILD_DIR}/${OPENCV_DIR}

build: cmake
	${MAKE} -C ${PROJECT_DIR}/${BUILD_DIR}/${TARGET}
	@echo "Built successfully!"

build_opencv: cmake_opencv
	${MAKE} -C ${PROJECT_DIR}/${BUILD_DIR}/${OPENCV_DIR}

clean_opencv:
	rm -r ${PROJECT_DIR}/${BUILD_DIR}/${OPENCV_DIR}

clean:
	rm -r ${PROJECT_DIR}/${BUILD_DIR}/${TARGET}

clean_all:
	rm -r ${PROJECT_DIR}/${BUILD_DIR}

run:
	${PROJECT_DIR}/${BUILD_DIR}/${TARGET}/${TARGET}

run_tests:
	${PROJECT_DIR}/${BUILD_DIR}/${TARGET}/${TESTS_DIR}/${TARGET_TESTS}

deps:
	sudo apt-get install libgtk-3-dev libgtk2.0-dev pkg-config


    endif
endif



