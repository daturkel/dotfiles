import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
import deploy  # noqa: E402


def test_render_substitutes_known_vars_both_syntaxes():
    # `$name` and `${name}` are both replaced
    out, n = deploy.render("a=$foo b=${foo}", {"foo": "1"})
    assert (out, n) == ("a=1 b=1", 2)


def test_render_leaves_shell_vars_and_longer_names_alone():
    # unknown vars and prefix-matches like $foo_bar must survive untouched
    out, n = deploy.render("$PATH $foo_bar ${HOME}", {"foo": "1"})
    assert (out, n) == ("$PATH $foo_bar ${HOME}", 0)


def test_resolve_profile_merges_defaults():
    # scalar keys under [profile] are defaults overridden by the named profile
    cfg = {"profile": {"a": "default", "b": "default", "p": {"b": "over"}}}
    assert deploy.resolve_profile(cfg, "p") == {"a": "default", "b": "over"}


def test_resolve_profile_unknown_exits():
    # a typo'd profile name is a hard error, not an empty profile
    with pytest.raises(SystemExit):
        deploy.resolve_profile({"profile": {"p": {}}}, "nope")


def test_deploy_package_renders_templates_and_symlinks_rest(tmp_path):
    # templated files are rendered copies; everything else links back to source
    (tmp_path / "pkg" / "sub").mkdir(parents=True)
    (tmp_path / "pkg" / "t.sh").write_text("x=$foo")
    (tmp_path / "pkg" / "sub" / "static").write_text("keep")
    dest = deploy.deploy_package("pkg", "p", {"foo": "bar"}, {"t.sh"}, root=tmp_path)
    assert (dest / "t.sh").read_text() == "x=bar" and not (dest / "t.sh").is_symlink()
    assert (dest / "sub" / "static").is_symlink()
    assert (dest / "sub" / "static").read_text() == "keep"


def test_deploy_package_missing_template_exits(tmp_path):
    # listing a nonexistent template must fail instead of silently skipping
    (tmp_path / "pkg").mkdir()
    with pytest.raises(SystemExit):
        deploy.deploy_package("pkg", "p", {}, {"gone"}, root=tmp_path)


def test_deploy_package_top_level_files_only(tmp_path):
    # output root must be created even when the package has no subdirectories
    (tmp_path / "pkg").mkdir()
    (tmp_path / "pkg" / ".rc").write_text("$foo")
    dest = deploy.deploy_package("pkg", "p", {"foo": "bar"}, {".rc"}, root=tmp_path)
    assert (dest / ".rc").read_text() == "bar"
