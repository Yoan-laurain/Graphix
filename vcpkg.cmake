# Set the vcpkg root directory
set(VCPKG_ROOT "${CMAKE_BINARY_DIR}/vcpkg")

# Check if vcpkg is already cloned and bootstrapped
if(NOT EXISTS "${VCPKG_ROOT}/vcpkg" AND NOT EXISTS "${VCPKG_ROOT}/bootstrap-vcpkg.bat" AND NOT EXISTS "${VCPKG_ROOT}/bootstrap-vcpkg.sh")
    # Clone vcpkg if it's not already present
    execute_process(COMMAND git clone https://github.com/microsoft/vcpkg.git ${VCPKG_ROOT})
else()
    message(STATUS "Vcpkg is already cloned")
endif()

# Bootstrap vcpkg (Windows vs. UNIX-like)
if(WIN32)
    # Only bootstrap if it's not already bootstrapped
    if(NOT EXISTS "${VCPKG_ROOT}/vcpkg.exe")
        execute_process(COMMAND cmd.exe /C "${VCPKG_ROOT}/bootstrap-vcpkg.bat")
    endif()
else()
    # Only bootstrap if it's not already bootstrapped
    if(NOT EXISTS "${VCPKG_ROOT}/vcpkg")
        execute_process(COMMAND ${CMAKE_COMMAND} -E chdir ${VCPKG_ROOT} ./bootstrap-vcpkg.sh)
    endif()
endif()

# Set the vcpkg toolchain file
set(CMAKE_TOOLCHAIN_FILE "${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake")

# set cmake prefix path
set(CMAKE_PREFIX_PATH "${VCPKG_ROOT}/installed/x64-windows/share")

# Function to install a package using vcpkg if it's not found
function(install_vcpkg_package package)
    find_package(${package} CONFIG QUIET)
    if(NOT TARGET ${package}::${package})
        message(STATUS "Installing ${package} via vcpkg...")
        execute_process(COMMAND ${CMAKE_COMMAND} -E chdir ${VCPKG_ROOT} ./vcpkg install ${package})
    else()
        message(STATUS "${package} is already installed.")
    endif()
endfunction()

# Install dependencies if not already found
install_vcpkg_package(glew)
install_vcpkg_package(glfw3)
install_vcpkg_package(opengl)

# Add glew and glfw3, opengl
find_package(GLEW REQUIRED)
find_package(glfw3 CONFIG REQUIRED)
find_package(OpenGL REQUIRED)
