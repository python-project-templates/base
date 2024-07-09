#pragma once
#include <pybind11/pybind11.h>
#include <cpp-template/cpp-template.hpp>

namespace py = pybind11;

PYBIND11_MODULE(extension, m) {
  m.doc() = "pybind11 example plugin";

  m.def("add", &add, "A function that adds two numbers");
}
