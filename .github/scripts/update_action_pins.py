"""Re-pin actions-ext references to the current main commit of each action repo.

Dependabot cannot maintain these pins: the template workflows are .jinja files
outside any .github/workflows directory, so it never sees them, and the pins
point at main commits rather than tags, which is all Dependabot can resolve.
"""

import json
import os
import re
import subprocess
import sys
import urllib.request

USES = re.compile(r"(?<=uses: )actions-ext/([\w.-]+)(/[\w./-]+)?@([0-9a-f]{40})")
API = "https://api.github.com/repos/actions-ext/{}/commits/main"


def tracked_files():
    out = subprocess.run(["git", "ls-files", "-z"], capture_output=True, check=True).stdout
    return [f.decode() for f in out.split(b"\0") if f]


def main_sha(repo):
    request = urllib.request.Request(API.format(repo), headers={"Accept": "application/vnd.github+json"})
    token = os.environ.get("GITHUB_TOKEN")
    if token:
        request.add_header("Authorization", f"Bearer {token}")
    with urllib.request.urlopen(request) as response:
        return json.load(response)["sha"]


def main():
    check_only = "--check" in sys.argv

    contents = {}
    repos = set()
    for path in tracked_files():
        try:
            text = open(path, encoding="utf-8").read()
        except (UnicodeDecodeError, OSError):
            continue
        found = USES.findall(text)
        if found:
            contents[path] = text
            repos.update(repo for repo, _, _ in found)

    latest = {repo: main_sha(repo) for repo in sorted(repos)}

    stale = []
    for path, text in contents.items():
        updated = USES.sub(lambda m: f"actions-ext/{m[1]}{m[2] or ''}@{latest[m[1]]}", text)
        if updated == text:
            continue
        stale += sorted({f"actions-ext/{repo}" for repo, _, sha in USES.findall(text) if sha != latest[repo]})
        print(f"{'stale' if check_only else 'updated'}: {path}")
        if not check_only:
            open(path, "w", encoding="utf-8").write(updated)

    if not stale:
        print(f"all pins current ({', '.join(f'{r}@{s[:8]}' for r, s in latest.items())})")
        return 0
    if check_only:
        print(f"\nout of date: {', '.join(sorted(set(stale)))}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
