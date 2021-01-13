from pathlib import Path
import re
from datetime import datetime
from shutil import make_archive


def del_dir_contents(root):
    for p in root.iterdir():
        if p.is_dir():
            del_dir_contents(p)
        else:
            p.unlink()
    for p in root.iterdir():
        if p.is_dir():
            p.rmdir()
    return


def set_up_dir(zip_dir, view_dir):
    if zip_dir.exists():
        del_dir_contents(zip_dir)
    else:
        zip_dir.mkdir()
    view_dir.mkdir()
    return


def get_files(extensions):
    all_files = []
    for ext in extensions:
        all_files.extend(Path.cwd().glob(ext))
    return(all_files)


def loop_through_axvw_and_js(prod_dir, to_replace, replace_with):
    file_paths = get_files(['*.axvw', '*.js', '*.sql'])
    for file_path in file_paths:
        print(file_path.name)
        with open(file_path, "r") as f:
            axvw_text = f.read()
            prod_text = re.sub(to_replace, replace_with, axvw_text)
        with open(prod_dir / file_path.name, "w") as f:
            f.write(prod_text)
    return


def zip_up_dash(zip_dir, view_dir):
    date_string = datetime.now().strftime("%Y%m%d")
    zip_filename = f"fmd_dashboard_{date_string}"
    zip_path = zip_dir / zip_filename
    make_archive(zip_path, 'zip', view_dir)
    return


if __name__ == "__main__":
    zip_dir = Path(r"C:\\Users\\sa.james\Documents\\fmd_dashboard")
    view_dir = zip_dir / "views"
    set_up_dir(zip_dir, view_dir)

    to_replace = re.escape(r"DateAdd(year, -2, getDate())")
    replace_with = r"getDate()"
    loop_through_axvw_and_js(view_dir, to_replace, replace_with)
    zip_up_dash(zip_dir, view_dir)

    print("Work completed.")
