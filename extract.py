import os
import shutil
import subprocess
from concurrent.futures import ThreadPoolExecutor

LIST_FILE = "a.txt"
MAX_WORKERS = 5

ARCHIVE_EXTS = (
    ".7z", ".zip", ".rar", ".tar",
    ".gz", ".bz2", ".xz", ".tgz"
)

files = [
    f for f in os.listdir(".")
    if os.path.isfile(f) and f.lower().endswith(ARCHIVE_EXTS)
]

with open(LIST_FILE, "w", encoding="utf-8") as f:
    for name in files:
        f.write(name + "\n")

print(f"Đã lưu {len(files)} file vào {LIST_FILE}")


def get_folder_name(filename):
    name = filename
    while True:
        base, ext = os.path.splitext(name)
        if not ext:
            return name
        name = base


def extract_file(filename):
    try:
        if not os.path.exists(filename):
            print(f"[!] Không tìm thấy: {filename}")
            return

        folder_name = get_folder_name(filename)
        os.makedirs(folder_name, exist_ok=True)

        print(f"[+] Extracting: {filename} -> {folder_name}/")

        result = subprocess.run(
            ["7z", "x", filename, f"-o{folder_name}", "-y"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.PIPE,
            text=True
        )

        if result.returncode == 0:
            print(f"[OK] {filename}")
            
            moved_file = os.path.join(folder_name, filename)
            if not os.path.exists(moved_file):
                shutil.move(filename, moved_file)
        else:
            print(f"[FAIL] {filename} - Error: {result.stderr}")

    except Exception as e:
        print(f"[ERR] {filename}: {e}")


if os.path.exists(LIST_FILE):
    with open(LIST_FILE, "r", encoding="utf-8") as f:
        targets = [line.strip() for line in f if line.strip()]

    with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
        list(executor.map(extract_file, targets))

print("Hoàn tất.")
