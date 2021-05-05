from pathlib import Path
import re


def get_files(extensions):
    all_files = []
    for ext in extensions:
        all_files.extend(Path.cwd().glob(ext))
    return(all_files)


def loop_through_axvw_and_js(prod_dir, to_replace, replace_with):
    file_paths = get_files(['*.axvw', '*.js'])
    for file_path in file_paths:
        print(file_path.name)
        with open(file_path, "r") as f:
            axvw_text = f.read()
            prod_text = re.sub(to_replace, replace_with, axvw_text)
        with open(prod_dir / file_path.name, "w") as f:
            f.write(prod_text)
    return


def loop_through_axvw(prod_dir, to_replace, replace_with):
    pass
    for file_path in Path.cwd().glob('*.axvw'):
        print(file_path.name)
        with open(file_path, "r") as f:
            axvw_text = f.read()
            # print(axvw_text[0:20])
            prod_text = re.sub(to_replace, replace_with, axvw_text)
        with open(prod_dir / file_path.name, "w") as f:
            f.write(prod_text)


if __name__ == '__main__':
    prod_dir = Path.cwd()
    to_replace = re.escape("getDate()")
    replace_with = r"DateAdd(year, -2, getDate())"
    to_replace = re.escape("DateAdd(year, -2, getDate())")
    loop_through_axvw(prod_dir, to_replace, replace_with)
