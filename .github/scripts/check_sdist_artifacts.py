"""Check native source distributions after compiled extensions exist."""

import shutil
import sys
import tarfile
import tempfile
import tomllib
from pathlib import Path

from hatchling.builders.sdist import SdistBuilder

source = Path(sys.argv[1]).resolve()
with tempfile.TemporaryDirectory() as temporary:
    project = Path(temporary) / "project"
    shutil.copytree(
        source,
        project,
        ignore=shutil.ignore_patterns(".git", ".venv", "__pycache__", "node_modules", "target", "dist", "vcpkg", "vcpkg_installed", "emsdk"),
    )
    config = tomllib.loads((project / "pyproject.toml").read_text())
    module = config["tool"]["hatch"]["build"]["targets"]["wheel"]["packages"][0]
    extensions = (".so", ".dll", ".dylib", ".pyd")
    for suffix in extensions:
        (project / module / f"_sdist_binary_check{suffix}").write_bytes(b"prebuilt binary")

    output = Path(temporary) / "dist"
    output.mkdir()
    filename = next(SdistBuilder(str(project)).build(directory=str(output)))
    with tarfile.open(output / filename) as archive:
        names = archive.getnames()

    binaries = [name for name in names if name.endswith(extensions)]
    assert not binaries, f"Source distribution contains compiled extensions: {binaries}"
    assert any(name.endswith((".cpp", ".rs")) for name in names), "Source distribution is missing native sources"
    print(f"{source.name}: source distribution excludes compiled extensions and retains native sources")
