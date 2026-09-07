"""Verify installed native wheels, including wheels rebuilt from each sdist."""

import json
import subprocess
import sys
import venv
from pathlib import Path
from tempfile import TemporaryDirectory
from zipfile import ZipFile

from packaging.tags import sys_tags
from packaging.utils import parse_wheel_filename


def test_wheel(wheel):
    with ZipFile(wheel) as archive:
        modules = []
        for name in archive.namelist():
            if name.endswith((".so", ".pyd")) and ".dist-info/" not in name:
                modules.append(name.split(".", 1)[0].replace("/", "."))
    if not modules:
        raise RuntimeError(f"No compiled extensions in {wheel.name}")
    with TemporaryDirectory() as directory:
        env = Path(directory) / "venv"
        venv.EnvBuilder(with_pip=True).create(env)
        python = env / ("Scripts/python.exe" if sys.platform == "win32" else "bin/python")
        subprocess.run([str(python), "-m", "pip", "install", str(wheel)], check=True, cwd=directory)
        subprocess.run(
            [
                str(python),
                "-I",
                "-c",
                (
                    "import importlib, importlib.machinery, json, sys; "
                    "modules = [importlib.import_module(name) for name in json.loads(sys.argv[1])]; "
                    "assert all(any(m.__file__.endswith(s) for s in importlib.machinery.EXTENSION_SUFFIXES) for m in modules)"
                ),
                json.dumps(modules),
            ],
            check=True,
            cwd=directory,
        )
    print(f"Verified compiled imports from {wheel.name}", flush=True)


def main():
    compatible_tags = set(sys_tags())
    wheels = [wheel for wheel in Path("dist").glob("*.whl") if parse_wheel_filename(wheel.name)[3] & compatible_tags]
    if not wheels:
        raise RuntimeError("No compatible wheels in dist/")
    for wheel in wheels:
        test_wheel(wheel.resolve())
    for sdist in Path("dist").glob("*.tar.gz"):
        with TemporaryDirectory() as directory:
            subprocess.run(
                [sys.executable, "-m", "uv", "build", "--wheel", "--out-dir", directory, str(sdist.resolve())],
                check=True,
                cwd=directory,
            )
            for wheel in Path(directory).glob("*.whl"):
                test_wheel(wheel)


if __name__ == "__main__":
    main()
