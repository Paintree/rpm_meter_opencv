TARGET = rpm_meter.exe

define shell_out
$(shell $(1))
endef

PROJECT_DIR = $(call shell_out, cd)
BUILD_DIR = build
EXTERNAL_DIR = external
OPENCV_DIR = opencv
OPENCV_BUILD_DIR = build_opencv

.PHONY: build cmake all

all: opencv_build build

cmake:
	cmake -G "MinGW Makefiles" . -B ${PROJECT_DIR}/${BUILD_DIR}

cmake_opencv:
	cmake -G "MinGW Makefiles" -DWITH_MSMF=OFF  -DWITH_OBSENSOR=OFF ${PROJECT_DIR}/${EXTERNAL_DIR}/${OPENCV_DIR} -B ${PROJECT_DIR}/${OPENCV_BUILD_DIR}

build: cmake
	${MAKE} -C ${BUILD_DIR}
	@echo "Built successfully!"

opencv_build: cmake_opencv
	${MAKE} -C ${PROJECT_DIR}/${OPENCV_BUILD_DIR}

opencv_clean:
	rmdir /s /q ${PROJECT_DIR}\${OPENCV_BUILD_DIR}
clean:
	rmdir /s /q ${PROJECT_DIR}\${BUILD_DIR}

clean_all: opencv_clean clean

start:
	${PROJECT_DIR}\${BUILD_DIR}\${TARGET}