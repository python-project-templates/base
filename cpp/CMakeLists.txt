###############################################################################################################
# Project Configuration #
#########################
cmake_minimum_required(VERSION 3.20.0)
project(cpp-template VERSION "0.1.0")
set(CMAKE_CXX_STANDARD 20)

###############################################################################################################
# CMake Dependencies #
######################
include(CheckCCompilerFlag)

###############################################################################################################
# CMake Policies #
##################
# option() should use new make behavior wrt variable clobbering
cmake_policy (SET CMP0077 NEW)

# Allow dep roots from env vars
cmake_policy (SET CMP0074 NEW)

# Set CMP0094 to NEW - find the first version that matches constraints,
# instead of the latest version installed
cmake_policy(SET CMP0094 NEW)

###############################################################################################################
# Environment #
###############
if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    set(WIN32 ON)
    set(MACOS OFF)
    set(LINUX OFF)
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    set(WIN32 OFF)
    set(MACOS ON)
    set(LINUX OFF)
else()
    set(WIN32 OFF)
    set(MACOS OFF)
    set(LINUX ON)
endif()


###############################################################################################################
# Paths #
#########
# Custom CMake modules
list(APPEND CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMAKE_SOURCE_DIR}/cmake/modules")

# Base includes
include_directories ("${CMAKE_SOURCE_DIR}/src")

###############################################################################################################
# Build Configuration #
#######################
find_package (Color)

if (NOT DEFINED CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Release/Debug build")
endif()
if (NOT DEFINED PYTHON_VERSION)
  set(PYTHON_VERSION "3.9" CACHE STRING "Python version to build against")
endif()
option(BUILD_PYTHON "Build Python bindings" ON)
option(USE_CCACHE "Use CCache for build" OFF)
option(STATIC_PYTHON "Build against static python (no libraries)" OFF)
option(PYODIDE "Build against pyodide" OFF)

# CCache setup
if(USE_CCACHE)
    set(CMAKE_C_COMPILE_LAUNCHER ccache)
    set(CMAKE_CXX_COMPILER_LAUNCHER ccache)
endif()

if(MACOS)
    # fix for threads on osx
    # assume built-in pthreads on MacOS
    set(CMAKE_THREAD_LIBS_INIT "-lpthread")
    set(CMAKE_HAVE_THREADS_LIBRARY 1)
    set(CMAKE_USE_WIN32_THREADS_INIT 0)
    set(CMAKE_USE_PTHREADS_INIT 1)
    set(THREADS_PREFER_PTHREAD_FLAG ON)

    # don't link against build python
    # https://blog.tim-smith.us/2015/09/python-extension-modules-os-x/
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -undefined dynamic_lookup")

    # Support cross build
    check_c_compiler_flag("-arch x86_64" x86_64Supported)
    check_c_compiler_flag("-arch arm64" arm64Supported)

    if(x86_64Supported AND arm64Supported)
        set(CMAKE_OSX_ARCHITECTURES "x86_64;arm64" CACHE STRING "Build universal architecture for OSX" FORCE)
    elseif(x86_64Supported)
        set(CMAKE_REQUIRED_LINK_OPTIONS "-arch;x86_64")
        set(CMAKE_OSX_ARCHITECTURES "x86_64" CACHE STRING "Build universal architecture for OSX" FORCE)
    elseif(arm64Supported)
        set(CMAKE_REQUIRED_LINK_OPTIONS "-arch;arm64")
        set(CMAKE_OSX_ARCHITECTURES "arm64" CACHE STRING "Build universal architecture for OSX" FORCE)
    endif()
endif()

if(WIN32)
    set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
endif()

###############################################################################################################
# Version #
###########
# Set version from cmake and extract latest hash if available
set(CPP_TEMPLATE_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
set(CPP_TEMPLATE_VERSION_MINOR ${PROJECT_VERSION_MINOR})
set(CPP_TEMPLATE_VERSION_PATCH ${PROJECT_VERSION_PATCH})
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/.git")
  # Get latest commit
  execute_process(COMMAND git rev-parse HEAD
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    OUTPUT_VARIABLE CPP_TEMPLATE_VERSION_COMMIT_SHA)
  # strip newline
  string(REGEX REPLACE "\n$" "" CPP_TEMPLATE_VERSION_COMMIT_SHA "${CPP_TEMPLATE_VERSION_COMMIT_SHA}")
else()
  set(CPP_TEMPLATE_VERSION_COMMIT_SHA "release")
endif()

###############################################################################################################
# RPath #
#########
if(NOT WIN32)
    set(CMAKE_SHARED_LIBRARY_SUFFIX .so)

    # Look for the binary using @loader_path (relative to binary location)
    set(CMAKE_MACOSX_RPATH TRUE)
    set(CMAKE_SKIP_BUILD_RPATH FALSE)
    set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
    set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

    # module_origin_path is the location of the binary
    if(MACOS)
        set(module_origin_path "@loader_path")
    else()
        set(module_origin_path "\$ORIGIN")
    endif()
else()
    set(CMAKE_SHARED_LIBRARY_PREFIX "lib")
    set(CMAKE_STATIC_LIBRARY_PREFIX "lib")
endif()

###############################################################################################################
# Flags #
#########
# Compiler version flags
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++2a")
endif()

# Optimization Flags
if(WIN32)
    if(CMAKE_BUILD_TYPE_LOWER STREQUAL debug)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /DEBUG /Z7 /Zi /Zc:preprocessor")
    else()
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /O2 /Zc:preprocessor ")
    endif()
else()
    if(CMAKE_BUILD_TYPE_LOWER STREQUAL debug)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O0 -g3")
    else()
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3 -g0")
    endif()
endif()

# Other Flags
if(WIN32)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /EHsc /MP /bigobj")
    foreach(warning 4244 4251 4267 4275 4290 4786 4305 4996)
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd${warning}")
    endforeach(warning)
    add_compile_definitions(WIN32 _WIN32)
	  if (MSVC_VERSION GREATER_EQUAL 1920)
		    add_compile_options(/d2FH4-) # Because we don't want to link against VCRUNTIME140_1.dll (see https://cibuildwheel.readthedocs.io/en/stable/faq/#importerror-dll-load-failed-the-specific-module-could-not-be-found-error-on-windows)
	  endif()
else()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wno-macro-redefined")
endif()

###############################################################################################################
# Python #
##########
if(BUILD_PYTHON AND STATIC_PYTHON AND LINUX)
    message("${Red}Manylinux build has no python shared libraries${ColorReset}")
    find_package(Python ${PYTHON_VERSION} EXACT REQUIRED COMPONENTS Interpreter OPTIONAL_COMPONENTS Development.Module)
elseif(BUILD_PYTHON)
    message("${Cyan}Use python shared libraries${ColorReset}")
    if(PYODIDE)
        find_package(Python ${PYTHON_VERSION} EXACT REQUIRED COMPONENTS Interpreter OPTIONAL_COMPONENTS Development.Module)
    else()
        find_package(Python ${PYTHON_VERSION} EXACT REQUIRED COMPONENTS Interpreter Development.Module)
    endif()
    link_directories(${Python_LIBRARY_DIRS})
endif()

if(BUILD_PYTHON)
  message("${Cyan}Using Python ${Python_VERSION}, \nPython_INCLUDE_DIRS: ${Python_INCLUDE_DIRS}, \nPython_LIBRARIES: ${Python_LIBRARIES}, \nPython_EXECUTABLE: ${Python_EXECUTABLE} ${ColorReset}")
  include_directories(${Python_INCLUDE_DIRS})
  add_definitions(-DBUILD_PYTHON)
endif()

###############################################################################################################
# Messages #
############
message("Building CPP Template version v${CPP_TEMPLATE_VERSION_MAJOR}.${CPP_TEMPLATE_VERSION_MINOR}.${CPP_TEMPLATE_VERSION_PATCH} [${CPP_TEMPLATE_VERSION_COMMIT_SHA}]")
string(TOLOWER "${CMAKE_BUILD_TYPE}" CMAKE_BUILD_TYPE_LOWER)

if(CMAKE_BUILD_TYPE_LOWER STREQUAL debug)
    message("${Red}Building DEBUG${ColorReset}")
else()
    message("${Cyan}Building RELEASE${ColorReset}")
endif()

###############################################################################################################
# Configure asset output directories #
######################################
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

###############################################################################################################
# Standalone C++ Binary #
#########################
set(
    PROJECT_HDRS
    "${PROJECT_SOURCE_DIR}/src/cpp-template/cpp-template.hpp"
    "${PROJECT_SOURCE_DIR}/src/cpp-template/exports.hpp"
)
set(
    PROJECT_SRCS
    "${PROJECT_SOURCE_DIR}/src/cpp-template/cpp-template.cpp"
)

add_library(cpp-template SHARED ${PROJECT_SRCS})
add_library(cpp-template-static STATIC ${PROJECT_SRCS})
set_target_properties(cpp-template PROPERTIES PUBLIC_HEADER "${PROJECT_HDRS}")

# export symbols
if(WIN32)
    target_compile_definitions(cpp-template PRIVATE LIB_EXPORTS)
    target_compile_definitions(cpp-template-static PRIVATE LIB_EXPORTS)
endif()

# install standalone library inside package
install(TARGETS cpp-template EXPORT CppTemplate LIBRARY DESTINATION lib PUBLIC_HEADER DESTINATION include)
install(TARGETS cpp-template-static EXPORT CppTemplate LIBRARY DESTINATION lib PUBLIC_HEADER DESTINATION include)

###############################################################################################################
# Pybind Extension #
####################
if(BUILD_PYTHON)
  # Find Numpy
  find_package(NumPy REQUIRED)

  # Find PyBind11
  find_package(pybind11 REQUIRED)
  include_directories(${pybind11_INCLUDE_DIR})

  set(
    PYTHON_HDRS
    "${PROJECT_SOURCE_DIR}/src/cpp-template/python/extension.hpp"
  )
  set(
    PYTHON_SRCS
    "${PROJECT_SOURCE_DIR}/src/cpp-template/python/extension.cpp"
  )

  # Extension
  pybind11_add_module(extension MODULE "${PYTHON_SRCS}")
  set_target_properties(extension PROPERTIES PUBLIC_HEADER "${PYTHON_HDRS}")

  # Link to standalone library
  target_link_libraries(extension PUBLIC cpp-template)
  set_property(TARGET extension PROPERTY INSTALL_RPATH "${module_origin_path}/lib")

  # install in python module
  install(TARGETS extension EXPORT CppTemplate LIBRARY DESTINATION . PUBLIC_HEADER DESTINATION include/python)
endif()

###############################################################################################################
# C++ Discoverability #
#######################

# Generate cmake config files for reuse by downstream packages
include(CMakePackageConfigHelpers)

# generate the config file that is includes the exports
configure_package_config_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/config/CppTemplateConfig.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/CppTemplateConfig.cmake
  INSTALL_DESTINATION cmake
)
write_basic_package_version_file(
  ${CMAKE_CURRENT_BINARY_DIR}/CppTemplateConfigVersion.cmake
  VERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}"
  COMPATIBILITY SameMajorVersion
)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/config/CppTemplate.pc.in
  "${CMAKE_CURRENT_BINARY_DIR}/CppTemplate.pc"
  @ONLY)

# install the configuration file
install(EXPORT CppTemplate
    FILE CppTemplateTargets.cmake
    NAMESPACE CppTemplate::
    DESTINATION lib/cmake/CppTemplate
)
install(
  FILES ${CMAKE_CURRENT_BINARY_DIR}/CppTemplateConfig.cmake ${CMAKE_CURRENT_BINARY_DIR}/CppTemplateConfigVersion.cmake
  DESTINATION lib/cmake/CppTemplate
)

# install the configuration file
install(
  FILES ${CMAKE_CURRENT_BINARY_DIR}/CppTemplate.pc
  DESTINATION lib/pkgconfig)

