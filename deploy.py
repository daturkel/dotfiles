#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# ///
"""Render profile-specific variants of dotfile packages, ready for `stow`.

For each package, creates `<package>_<profile>/` mirroring the source tree:
files listed in config.toml `[settings].files` are rendered with the profile's
variables, and every other file is a relative symlink back to the source so
edits to it take effect without re-deploying.

Usage:
    ./deploy.py home            # all packages in config.toml
    ./deploy.py home zsh p10k   # selected packages
Then: stow zsh_home
"""

import argparse
import logging
import os
import re
import shutil
import tomllib
from pathlib import Path

ROOT = Path(__file__).resolve().parent
IGNORED_NAMES = {".DS_Store"}

log = logging.getLogger("deploy")


def resolve_profile(config: dict, name: str) -> dict[str, str]:
    """Returns a profile's variables, falling back to `[profile]` scalar defaults.

    Args:
        config: Parsed config.toml.
        name: Profile name, i.e. a `[profile.<name>]` table.

    Returns:
        Mapping of variable name to value.

    Raises:
        SystemExit: If the profile does not exist.
    """
    profiles = config["profile"]
    available = sorted(k for k, v in profiles.items() if isinstance(v, dict))
    if name not in available:
        raise SystemExit(f"Unknown profile {name!r}. Available: {', '.join(available)}")
    defaults = {k: v for k, v in profiles.items() if not isinstance(v, dict)}
    return {**defaults, **profiles[name]}


def render(text: str, variables: dict[str, str]) -> tuple[str, int]:
    """Substitutes `$name` / `${name}` for known variables only.

    Unlike string.Template, unknown `$names` are left alone, so shell variables
    such as `$PATH` survive intact.

    Args:
        text: Template text.
        variables: Variable values to substitute.

    Returns:
        The rendered text and the number of substitutions made.
    """
    if not variables:
        return text, 0
    names = "|".join(re.escape(k) for k in sorted(variables, key=len, reverse=True))
    pattern = re.compile(rf"\$(?:\{{({names})\}}|({names})\b)")
    return pattern.subn(lambda m: str(variables[m.group(1) or m.group(2)]), text)


def deploy_package(
    package: str, profile: str, variables: dict[str, str], templated: set[str], root: Path = ROOT
) -> Path:
    """Builds `<package>_<profile>/` from `<package>/`.

    Args:
        package: Package directory name, e.g. "zsh".
        profile: Profile name, used in the output directory name.
        variables: Variables to render into templated files.
        templated: Paths (relative to the package) that are rendered, not symlinked.
        root: Repo root containing the package.

    Returns:
        The output directory.

    Raises:
        SystemExit: If the package or a listed template file is missing.
    """
    src = root / package
    if not src.is_dir():
        raise SystemExit(f"Package {package!r} not found at {src}")
    missing = [t for t in templated if not (src / t).is_file()]
    if missing:
        raise SystemExit(f"Templated files not found in {package}: {', '.join(missing)}")

    dest = root / f"{package}_{profile}"
    if dest.exists():
        shutil.rmtree(dest)
    dest.mkdir(parents=True)

    for path in sorted(src.rglob("*")):
        if path.name in IGNORED_NAMES:
            continue
        rel = path.relative_to(src)
        target = dest / rel
        if path.is_dir():
            target.mkdir(parents=True, exist_ok=True)
        elif rel.as_posix() in templated:
            rendered, count = render(path.read_text(), variables)
            if count == 0:
                log.warning("%s/%s is listed as a template but has no placeholders", package, rel)
            target.write_text(rendered)
            log.info("rendered %s (%d substitutions)", target.relative_to(root), count)
        else:
            target.symlink_to(os.path.relpath(path, target.parent))
    return dest


def main() -> None:
    logging.basicConfig(level=logging.INFO, format="%(message)s")
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("profile", help="profile name from config.toml")
    parser.add_argument("packages", nargs="*", help="packages to deploy (default: all in config.toml)")
    args = parser.parse_args()

    with open(ROOT / "config.toml", "rb") as f:
        config = tomllib.load(f)
    variables = resolve_profile(config, args.profile)
    known = config["settings"]["projects"]
    packages = args.packages or known
    unknown = [p for p in packages if p not in known]
    if unknown:
        raise SystemExit(f"Not in config.toml projects: {', '.join(unknown)}")

    for package in packages:
        templated = set(config["settings"]["files"].get(package, []))
        dest = deploy_package(package, args.profile, variables, templated)
        log.info("-> stow %s", dest.name)


if __name__ == "__main__":
    main()
