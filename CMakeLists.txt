# If no preset is specified, use the default preset
if (NOT CMAKE_GENERATOR)
    message(STATUS "Using default CMake preset: dev_vs22")
    execute_process(COMMAND "${CMAKE_COMMAND}" --preset dev_vs22
                    WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}")
    return()  # Stops further execution since the preset runs instead
endif()

#cmake minimum version
cmake_minimum_required(VERSION 3.31.4)

# Set the name of the project
project(Graphix)

# Enable the use of folders in supported IDEs (e.g., Visual Studio, Xcode)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Include the vcpkg
include(${CMAKE_SOURCE_DIR}/vcpkg.cmake)

# Include source files
file(GLOB_RECURSE SOURCES "${CMAKE_SOURCE_DIR}/*.cpp")
add_executable(${PROJECT_NAME} ${SOURCES})

# Define a custom target for installing pre-commit hooks
add_custom_target(
    install-pre-commit-hooks
    COMMAND ${CMAKE_COMMAND} -E echo "Installing pre-commit hooks..."
    COMMAND pre-commit install
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

# Link libraries
target_link_libraries(${PROJECT_NAME} PRIVATE GLEW::GLEW glfw OpenGL::GL)

# include directories
target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_SOURCE_DIR}/include)
