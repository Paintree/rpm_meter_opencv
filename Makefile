TARGET = rpm_meter.exe

define shell_out
$(shell $(1))
endef

PROJECT_DIR = $(call shell_out, cd)
BUILD_DIR = build

.PHONY: build cmake all

all: clean build

cmake:
	cmake -G "MinGW Makefiles" . -B ${PROJECT_DIR}/${BUILD_DIR}

build: cmake
	${MAKE} -C ${BUILD_DIR}
	@echo "${GREEN}Built successfully!"

clean:
	rmdir /s /q ${PROJECT_DIR}\${BUILD_DIR}

run:
	${PROJECT_DIR}\${BUILD_DIR}\${TARGET}