from pathlib import Path
import re

def loop_through_axvw(prod_dir, to_replace, replace_with):
    pass
    # for file_path in Path.cwd().glob('*.axvw'):
    #     print(file_path.name)
    #     with open(file_path, "r") as f:
    #         axvw_text = f.read()
    #         # print(axvw_text[0:20])
    #         prod_text = re.sub(to_replace, replace_with, axvw_text)
    #     with open(prod_dir / file_path.name, "w") as f:
    #         f.write(prod_text)


if __name__ == '__main__' :
    # prod_dir = Path(r"C:\\Users\\sa.james\Documents\\fmd_dashboard")
    # to_replace = re.escape(r"DateAdd(year, -2, getDate())")
    # replace_with = r"getDate()"
    # loop_through_axvw(prod_dir, to_replace, replace_with)