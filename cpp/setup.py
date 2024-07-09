import os
import multiprocessing
import sys
from skbuild import setup

python_version = f"{sys.version_info.major}.{sys.version_info.minor}"
cmake_args = [f"-DPYTHON_VERSION={python_version}"]


if "CMAKE_ARGS" in os.environ:
    cmake_args.extend(os.environ["CMAKE_ARGS"].split(" "))

if "STATIC_PYTHON" in os.environ:
    cmake_args.append("-DSTATIC_PYTHON=On")

if "CMAKE_BUILD_PARALLEL_LEVEL" not in os.environ:
    os.environ["CMAKE_BUILD_PARALLEL_LEVEL"] = str(multiprocessing.cpu_count())

setup(
    name="cpp_template",
    version="0.1.0",
    packages=["cpp_template"],
    cmake_install_dir="cpp_template",
    cmake_args=cmake_args,
)
