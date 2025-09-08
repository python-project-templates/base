#pragma once
#include <pybind11/pybind11.h>

namespace py = pybind11;

int add(int i, int j);

PYBIND11_MODULE(extension, m) {
  m.doc() = "pybind11 example plugin";

  m.def("add", &add, "A function that adds two numbers");
}
