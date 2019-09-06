#!python
"""
Run each test, and show failures and successes.
"""
import glob
import os
import shutil

SUB_DIR = "./all_tbs/"
DEF_TB_PATH = "../tests/"
DEF_SIM = "iverilog"

def main():

    # find all test folders
    print("finding folders")
    folders = next(os.walk(DEF_TB_PATH))[1]
    for folder in folders:
        # TODO
        # enter each folder
        # run hdlmake, make clean, and make
        # dump output of that to a file, then parse that file for failures.
        # count failures
        pass





    # run hdlmake, make clean and make.
    pass

if __name__ == '__main__':
    main()
