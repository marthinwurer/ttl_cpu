#!python
import glob
import os
import shutil

SUB_DIR = "./all_tbs/"
DEF_TB_PATH = "../tests/"
DEF_SIM = "iverilog"

def main():
    # make a new dir for each test file
    # make the top level dir
    os.makedirs(SUB_DIR, exist_ok=True)

    # find all test folders
    print("finding folders")
    folders = next(os.walk(DEF_TB_PATH))[1]
    for folder in folders:
        print("Found folder: %s" % (folder,))
        # make the new dir
        new_dir = SUB_DIR + folder
        new_file = new_dir + "/Manifest.py"
        os.makedirs(new_dir, exist_ok=True)
        # make the manifiest file

        # shutil.copy("./" + DEF_SIM + "/base_Manifest.py", new_file)

        with open(new_file, "w") as f:
            f.write("""sim_top = "tb_%s" """ % (folder,))
            f.write("""
action = "simulation"
sim_tool = "iverilog"

iverilog_opt = "-g2012"

sim_post_cmd = "vvp %s.vvp" % (sim_top,)
""")

            f.write("""

modules = {
  "local": ["../../../tests/%s"],
}
"""
                    % (folder,))



    # run hdlmake, make clean and make.
    pass

if __name__ == '__main__':
    main()
