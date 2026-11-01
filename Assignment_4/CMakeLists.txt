cmake_minimum_required(VERSION 3.5)
project(assignment4)

if(NOT CMAKE_BUILD_TYPE)
	message(STATUS "No build type selected, default to Release")
	set(CMAKE_BUILD_TYPE "Release")
endif()

# Project sources
add_executable(${PROJECT_NAME}
	src/main.cpp
	src/utils.h
)

# Include Eigen for linear algebra
find_package(Eigen3 3.3 QUIET NO_MODULE HINTS "${CMAKE_CURRENT_SOURCE_DIR}/../ext/eigen")

if(TARGET Eigen3::Eigen)
    target_link_libraries(${PROJECT_NAME} PUBLIC Eigen3::Eigen)
else()
    target_include_directories(${PROJECT_NAME} SYSTEM PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/../ext/eigen")
endif()

# stb and gif-h are header-only libraries with no CMake support, expose them as interface targets
add_library(stb INTERFACE)
target_include_directories(stb SYSTEM INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/../ext/stb")

add_library(gif-h INTERFACE)
target_include_directories(gif-h SYSTEM INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/../ext/gif-h")

target_link_libraries(${PROJECT_NAME} PUBLIC stb gif-h)

# Use C++11 version of the standard
set_target_properties(${PROJECT_NAME} PROPERTIES CXX_STANDARD 11 CXX_STANDARD_REQUIRED ON)

# Place the output binary at the root of the build folder
set_target_properties(${PROJECT_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")

# Folder where data files are stored (meshes etc)
set(DATA_DIR "${CMAKE_CURRENT_SOURCE_DIR}/data/")
target_compile_definitions(${PROJECT_NAME} PUBLIC -DDATA_DIR=\"${DATA_DIR}\")
