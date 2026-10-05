"""build.py のテスト

使い方: python3 test_build.py

※ macOS 標準の python3 (3.9) で動くよう、標準モジュールのみを使用する
※ 実際の defaults コマンドは実行しない (生成されるコマンド文字列のみを検証する)
"""

import json
import os
import plistlib
import shlex
import subprocess
import sys
import unittest

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

import build  # noqa: E402


def parse_xml(fragment):
    """XML plist の断片を plistlib で読み戻す"""
    doc = '<?xml version="1.0" encoding="UTF-8"?><plist version="1.0">' + fragment + "</plist>"
    return plistlib.loads(doc.encode())


def args_of(domain, key, raw):
    """build_command の結果をシェルと同じ規則で引数リストに分解する"""
    return shlex.split(build.build_command(domain, key, build.normalize(raw)))


class TestStripComments(unittest.TestCase):
    def test_removes_line_comments(self):
        """行コメントと行末コメントが除去されること"""
        src = '{\n  // comment\n  "a": 1 // trailing\n}'
        self.assertEqual(json.loads(build.strip_comments(src)), {"a": 1})

    def test_keeps_slashes_in_strings(self):
        """文字列中の // はコメントとして扱われないこと"""
        src = '{"url": "https://example.com/a//b"} // comment'
        self.assertEqual(json.loads(build.strip_comments(src)), {"url": "https://example.com/a//b"})

    def test_keeps_escaped_quotes_in_strings(self):
        """エスケープされた引用符を含む文字列中の // はコメントとして扱われないこと"""
        src = r'{"a": "say \"// not comment\""} // comment'
        self.assertEqual(json.loads(build.strip_comments(src)), {"a": 'say "// not comment"'})


class TestToPlistXml(unittest.TestCase):
    def test_scalars(self):
        """スカラー値がそれぞれ対応する XML 要素に変換されること"""
        self.assertEqual(build.to_plist_xml(True), "<true/>")
        self.assertEqual(build.to_plist_xml(False), "<false/>")
        self.assertEqual(build.to_plist_xml(16), "<integer>16</integer>")
        self.assertEqual(build.to_plist_xml(2.0), "<real>2.0</real>")
        self.assertEqual(build.to_plist_xml("left"), "<string>left</string>")

    def test_escapes_special_characters(self):
        """文字列中の < > & がエスケープされること"""
        self.assertEqual(build.to_plist_xml("a<b>&c"), "<string>a&lt;b&gt;&amp;c</string>")

    def test_roundtrip_keeps_types(self):
        """変換結果を plistlib で読み戻したとき元の値と型が保たれていること"""
        value = {
            "enabled": True,
            "value": {"type": "standard", "parameters": [32, 49, 262144]},
            "ratio": 0.5,
            "text": "<&>",
            "empty": [],
        }
        result = parse_xml(build.to_plist_xml(value))
        self.assertEqual(result, value)
        self.assertIsInstance(result["ratio"], float)
        self.assertIsInstance(result["enabled"], bool)

    def test_non_string_keys_become_strings(self):
        """dict のキーが文字列でないとき文字列に変換されること"""
        self.assertEqual(parse_xml(build.to_plist_xml({27: False})), {"27": False})

    def test_unsupported_value(self):
        """対応していない値のとき ValueError になること"""
        with self.assertRaises(ValueError):
            build.to_plist_xml(None)


class TestNormalize(unittest.TestCase):
    def test_scalar_is_wrapped(self):
        """スカラー値のとき {"value": ...} に包まれること"""
        self.assertEqual(build.normalize(2), {"value": 2})
        self.assertEqual(build.normalize(False), {"value": False})

    def test_wrapper_is_kept(self):
        """包まれた値のときそのまま返されること"""
        raw = {"host": "currentHost", "value": 18}
        self.assertEqual(build.normalize(raw), raw)

    def test_dict_value_must_be_wrapped(self):
        """包まれた dict 値のときそのまま返されること"""
        raw = {"value": {"foo": 1}}
        self.assertEqual(build.normalize(raw), raw)

    def test_bare_array_is_error(self):
        """包まれていない array のときエラーになること"""
        with self.assertRaisesRegex(ValueError, "array must be wrapped"):
            build.normalize([1, 2])

    def test_missing_value_is_error(self):
        """包みに value がないときエラーになること"""
        with self.assertRaisesRegex(ValueError, "missing"):
            build.normalize({"host": "currentHost"})

    def test_bare_dict_is_error(self):
        """包まれていない dict のとき未知のフィールドとしてエラーになること"""
        with self.assertRaisesRegex(ValueError, "unknown fields"):
            build.normalize({"foo": 1})

    def test_unknown_host_is_error(self):
        """host が currentHost 以外のときエラーになること"""
        with self.assertRaisesRegex(ValueError, "unknown host"):
            build.normalize({"host": "anyHost", "value": 1})

    def test_unknown_type_is_error(self):
        """type が未知の値のときエラーになること"""
        with self.assertRaisesRegex(ValueError, "unknown type"):
            build.normalize({"type": "array-add", "value": [1]})


class TestBuildCommand(unittest.TestCase):
    def test_bool(self):
        """bool 値のとき -bool で書き込むコマンドになること"""
        self.assertEqual(
            args_of("com.apple.dock", "autohide", True),
            ["defaults", "write", "com.apple.dock", "autohide", "-bool", "true"],
        )

    def test_int(self):
        """整数値のとき -int で書き込むコマンドになること"""
        self.assertEqual(
            args_of("com.apple.dock", "tilesize", 16),
            ["defaults", "write", "com.apple.dock", "tilesize", "-int", "16"],
        )

    def test_float(self):
        """浮動小数点数のとき -float で書き込むコマンドになること"""
        self.assertEqual(
            args_of("NSGlobalDomain", "com.apple.trackpad.scaling", 2.0),
            ["defaults", "write", "NSGlobalDomain", "com.apple.trackpad.scaling", "-float", "2.0"],
        )

    def test_string_with_spaces_is_quoted(self):
        """空白や引用符を含むキーや文字列のときシェル上で 1 つの引数として扱われること"""
        self.assertEqual(
            args_of("com.example", "Name With Space", "it's a value"),
            ["defaults", "write", "com.example", "Name With Space", "-string", "it's a value"],
        )

    def test_array_is_passed_as_xml(self):
        """array 値のとき XML plist の 1 引数として渡されること"""
        args = args_of("com.apple.Spotlight", "DisabledUTTypes", {"value": ["public.image", "public.movie"]})
        self.assertEqual(args[:4], ["defaults", "write", "com.apple.Spotlight", "DisabledUTTypes"])
        self.assertEqual(len(args), 5)
        self.assertEqual(parse_xml(args[4]), ["public.image", "public.movie"])

    def test_dict_is_passed_as_xml(self):
        """dict 値のとき XML plist の 1 引数として渡されること"""
        args = args_of("com.example", "Dict", {"value": {"a": 1, "b": [True]}})
        self.assertEqual(len(args), 5)
        self.assertEqual(parse_xml(args[4]), {"a": 1, "b": [True]})

    def test_current_host(self):
        """host が currentHost のとき -currentHost が付くこと"""
        self.assertEqual(
            args_of("com.apple.controlcenter", "Sound", {"host": "currentHost", "value": 18}),
            ["defaults", "-currentHost", "write", "com.apple.controlcenter", "Sound", "-int", "18"],
        )

    def test_dict_add(self):
        """type が dict-add のときキーと XML 値の組が順に並ぶこと"""
        raw = {
            "type": "dict-add",
            "value": [
                {"key": 27, "value": {"enabled": False}},
                {"key": "64", "value": {"enabled": True, "value": {"parameters": [32, 49, 262144]}}},
            ],
        }
        args = args_of("com.apple.symbolichotkeys", "AppleSymbolicHotKeys", raw)
        self.assertEqual(
            args[:5],
            ["defaults", "write", "com.apple.symbolichotkeys", "AppleSymbolicHotKeys", "-dict-add"],
        )
        self.assertEqual(args[5], "27")
        self.assertEqual(parse_xml(args[6]), {"enabled": False})
        self.assertEqual(args[7], "64")
        self.assertEqual(parse_xml(args[8]), {"enabled": True, "value": {"parameters": [32, 49, 262144]}})
        self.assertEqual(len(args), 9)

    def test_dict_add_with_current_host(self):
        """dict-add と currentHost を併用したとき両方が反映されること"""
        raw = {"host": "currentHost", "type": "dict-add", "value": [{"key": "a", "value": 1}]}
        args = args_of("com.example", "Dict", raw)
        self.assertEqual(args[:6], ["defaults", "-currentHost", "write", "com.example", "Dict", "-dict-add"])

    def test_dict_add_requires_array(self):
        """dict-add の value が array でないときエラーになること"""
        with self.assertRaisesRegex(ValueError, "dict-add value must be an array"):
            args_of("com.example", "Dict", {"type": "dict-add", "value": {"a": 1}})

    def test_dict_add_item_requires_key_and_value(self):
        """dict-add の要素が key と value のちょうど 2 つを持たないときエラーになること"""
        for item in [{"key": "a"}, {"value": 1}, {"key": "a", "value": 1, "extra": 0}, "a"]:
            with self.subTest(item=item), self.assertRaisesRegex(ValueError, "invalid dict-add item"):
                args_of("com.example", "Dict", {"type": "dict-add", "value": [item]})


class TestBuild(unittest.TestCase):
    def test_output(self):
        """シバン行から始まり、設定の順にコマンドが並ぶこと"""
        config = {
            "com.apple.dock": {"autohide": True, "tilesize": 16},
            "NSGlobalDomain": {"KeyRepeat": 2},
        }
        lines = build.build(config).splitlines()
        self.assertEqual(lines[0], "#!/bin/bash -eu")
        commands = [line for line in lines if line.startswith("defaults ")]
        self.assertEqual(
            commands,
            [
                "defaults write com.apple.dock autohide -bool true",
                "defaults write com.apple.dock tilesize -int 16",
                "defaults write NSGlobalDomain KeyRepeat -int 2",
            ],
        )

    def test_ends_with_newline(self):
        """出力が改行で終わること"""
        self.assertTrue(build.build({}).endswith("\n"))

    def test_error_includes_domain_and_key(self):
        """設定が不正なときエラーメッセージにドメインとキーが含まれること"""
        with self.assertRaisesRegex(ValueError, r"^com\.example > Foo: array must be wrapped"):
            build.build({"com.example": {"Foo": [1]}})

    def test_top_level_must_be_object(self):
        """トップレベルがオブジェクトでないときエラーになること"""
        with self.assertRaisesRegex(ValueError, "top level"):
            build.build([])

    def test_domain_must_be_object(self):
        """ドメインの値がオブジェクトでないときエラーになること"""
        with self.assertRaisesRegex(ValueError, "com.example: must be an object"):
            build.build({"com.example": 1})


class TestMain(unittest.TestCase):
    def run_build(self, stdin):
        return subprocess.run(
            [sys.executable, os.path.join(HERE, "build.py")],
            input=stdin,
            capture_output=True,
            text=True,
        )

    def test_reads_stdin_and_writes_stdout(self):
        """標準入力の JSONC を読み込み、標準出力にスクリプトを書き出すこと"""
        result = self.run_build('{\n  // comment\n  "com.apple.dock": {"autohide": true}\n}')
        self.assertEqual(result.returncode, 0)
        self.assertIn("defaults write com.apple.dock autohide -bool true\n", result.stdout)
        self.assertEqual(result.stderr, "")

    def test_invalid_setting_exits_with_error(self):
        """設定が不正なとき標準エラー出力にメッセージを出して終了コード 1 で終わること"""
        result = self.run_build('{"com.example": {"Foo": [1]}}')
        self.assertEqual(result.returncode, 1)
        self.assertEqual(result.stdout, "")
        self.assertIn("error: com.example > Foo:", result.stderr)

    def test_invalid_json_exits_with_error(self):
        """JSON として不正なとき終了コード 1 で終わること"""
        result = self.run_build("{")
        self.assertEqual(result.returncode, 1)
        self.assertIn("error:", result.stderr)

    def test_generated_script_is_valid_bash(self):
        """defaults.jsonc から生成したスクリプトが bash の構文として正しいこと"""
        with open(os.path.join(HERE, "defaults.jsonc")) as f:
            result = self.run_build(f.read())
        self.assertEqual(result.returncode, 0, result.stderr)
        syntax = subprocess.run(["bash", "-n"], input=result.stdout, capture_output=True, text=True)
        self.assertEqual(syntax.returncode, 0, syntax.stderr)


if __name__ == "__main__":
    unittest.main()
