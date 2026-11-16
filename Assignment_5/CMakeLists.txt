cmake_minimum_required(VERSION 3.5)
project(assignment5)

if(NOT CMAKE_BUILD_TYPE)
	message(STATUS "No build type selected, default to Release")
	set(CMAKE_BUILD_TYPE "Release")
endif()

add_executable(${PROJECT_NAME}
	src/main.cpp
	src/raster.h
	src/raster.cpp
)

add_executable(examples
	examples/main.cpp
	examples/raster.h
	examples/raster.cpp
)

find_package(Eigen3 3.3 QUIET NO_MODULE HINTS "${CMAKE_CURRENT_SOURCE_DIR}/../ext/eigen")

foreach(target ${PROJECT_NAME} examples)
	target_compile_features(${target} PRIVATE cxx_std_11)
	set_target_properties(${target} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")
	target_include_directories(${target} SYSTEM PRIVATE
		"${CMAKE_CURRENT_SOURCE_DIR}/../ext/gif-h"
		"${CMAKE_CURRENT_SOURCE_DIR}/../ext/stb"
	)

	if(TARGET Eigen3::Eigen)
		target_link_libraries(${target} PRIVATE Eigen3::Eigen)
	else()
		target_include_directories(${target} SYSTEM PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../ext/eigen")
	endif()
endforeach()

set(DATA_DIR "${CMAKE_CURRENT_SOURCE_DIR}/data/")
target_compile_definitions(${PROJECT_NAME} PRIVATE DATA_DIR=\"${DATA_DIR}\")
