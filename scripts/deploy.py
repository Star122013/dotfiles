from dataclasses import dataclass
from pathlib import Path
import subprocess

REPO_ROOT = Path(__file__).parent.parent.resolve()
DOT_FILE = REPO_ROOT / "dotfiles"
HOME = Path.home()


@dataclass
class DotfileMap:
    source_name: str
    target_name: Path
    sudo: bool = False

    def sync(self):
        src_dir = DOT_FILE / self.source_name
        # print(f"{src_dir}")
        if not src_dir.exists():
            print(f"{src_dir} not found")
            return
        # print(f"symlink: {self.source_name} -> {self.target_name}")

        for src_path in src_dir.rglob("*"):
            rel_path = src_path.relative_to(src_dir)

            dest_path = self.target_name / rel_path

            if src_path.is_dir():
                self.ensure_directory(dest_path)
                continue

            if src_path.is_file():
                self.create_symlink(src_path, dest_path)

    def ensure_directory(self, path: Path):
        if path.is_dir():
            return
        print(f"mkdir {path}")
        if self.sudo:
            subprocess.run(["sudo", "mkdir", "-p", str(path)], check=True)  # pyright: ignore[reportUnusedCallResult]
        else:
            path.mkdir(parents=True, exist_ok=True)

    def create_symlink(self, source: Path, target: Path):
        if target.is_symlink() and target.readlink() == source:
            return

        if target.is_symlink() or target.exists():
            backup_path = target.with_name(f"{target.name}.bak")
            print(f"backup: {target} -> {backup_path.name}")

            if self.sudo:
                subprocess.run(
                    ["sudo", "mv", str(target), str(backup_path)], check=True
                )  # pyright: ignore[reportUnusedCallResult]
            else:
                target.rename(backup_path)  # pyright: ignore[reportUnusedCallResult]

        self.ensure_directory(target.parent)

        try:
            if self.sudo:
                subprocess.run(
                    ["sudo", "ln", "-sf", str(source), str(target)], check=True
                )  # pyright: ignore[reportUnusedCallResult]
            else:
                target.symlink_to(source)
            print(f"Created symlink: {source} -> {target}")
        except Exception as e:
            print(f"failed: {e}")


def main():
    mappings = [
        # 规则 1: 仓库里的 config 文件夹 -> 链接到 ~/.config 内部
        DotfileMap(source_name="config", target_name=HOME / ".config"),
        # 规则 2: 仓库里的 local 文件夹 -> 链接到 ~/.local 内部
        DotfileMap(source_name="local", target_name=HOME / ".local"),
        DotfileMap(source_name="portage", target_name=Path("/etc/portage"), sudo=True),
        DotfileMap(
            source_name="cyrene-overlay",
            target_name=Path("/var/db/repos/cyrene-overlay"),
            sudo=True,
        ),
    ]
    print("🚀 开始链接 Dotfiles...")
    for m in mappings:
        m.sync()
    print("\n🎉 全部完成!")


if __name__ == "__main__":
    main()
