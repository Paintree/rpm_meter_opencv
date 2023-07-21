TARGET = rpm_meter

define shell_out
$(shell $(1))
endef


BUILD_DIR = build
EXTERNAL_DIR = external
OPENCV_DIR = opencv


.PHONY: build cmake all

all: clean_all build_opencv build

ifeq ($(OS),Windows_NT)

PROJECT_DIR = $(call shell_out, cd)
    
cmake:
	cmake -G "MinGW Makefiles" . -B ${PROJECT_DIR}/${BUILD_DIR}/${TARGET}

cmake_opencv:
	cmake -G "MinGW Makefiles" -DWITH_MSMF=OFF -DWITH_OBSENSOR=OFF -DBUILD_SHARED_LIBS=OFF ${PROJECT_DIR}/${EXTERNAL_DIR}/${OPENCV_DIR} -B ${PROJECT_DIR}/${BUILD_DIR}/${OPENCV_DIR}

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

install:
	${MAKE} ${PROJECT_DIR}/${BUILD_DIR}/${TARGET} install

deps:
	sudo apt-get install libgtk-3-dev


    endif
endif



