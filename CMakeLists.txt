# Set the minimum required version of CMake
cmake_minimum_required(VERSION 3.25.1)

# Project name
project(Docker_Conan_Test VERSION 1.0.0 DESCRIPTION "Testing A C++ Project using Docker, Conan and CMake" LANGUAGES CXX)

# Miscellaneous Settings
set(CMAKE_IGNORE_PATH "/usr/local/lib:/Library/Frameworks/")
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/install)

# Define the executable
set(EXE_NAME program.out)

# Collect all .cpp files in the src directory
file(GLOB SRC_FILES "src/*.cpp")

# Find necessary packages / conan dependencies
find_package(Threads REQUIRED)

# Group all libraries in a variable
set(LIBRARIES Threads::Threads)

# Add the executable
add_executable(${EXE_NAME} ${SRC_FILES})

# Link library dependencies
target_link_libraries(${EXE_NAME} PRIVATE ${LIBRARIES})

# Add the local "include" directory to the target's include directories
target_include_directories(${EXE_NAME} PRIVATE ${PROJECT_SOURCE_DIR}/include)
