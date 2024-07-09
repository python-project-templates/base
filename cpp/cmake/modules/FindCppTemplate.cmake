# Find the CppTemplate package
# CPP_TEMPLATE_INCLUDE_DIR
# CPP_TEMPLATE_FOUND
# will be set by this script

cmake_minimum_required(VERSION 3.7.2)

find_package( PythonInterp ${PYTHON_VERSION} EXACT REQUIRED )

# Find out the include path
execute_process(
  COMMAND "${Python_EXECUTABLE}" -c
          "from __future__ import print_function;import cpp_template;print(cpp_template.include_path(), end='')"
          OUTPUT_VARIABLE __cppt_path)
# And the version
execute_process(
  COMMAND "${Python_EXECUTABLE}" -c
          "from __future__ import print_function;import cpp_template;print(cpp_template.__version__, end='')"
  OUTPUT_VARIABLE __cppt_version)

find_path(CPP_TEMPLATE_INCLUDE_DIR cpp-template/cpp-template.hpp
  HINTS "${__cppt_path}" "${PYTHON_INCLUDE_PATH}" NO_DEFAULT_PATH)

if(CPP_TEMPLATE_INCLUDE_DIR)
  set(CPP_TEMPLATE_FOUND 1 CACHE INTERNAL "Python cpp_template found")
endif(CPP_TEMPLATE_INCLUDE_DIR)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(CppTemplate REQUIRED_VARS CPP_TEMPLATE_INCLUDE_DIR
                                        VERSION_VAR __cppt_version)
