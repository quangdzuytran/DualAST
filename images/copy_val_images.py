import os
import json

with open('eval_paths_700_val.json') as f:
    file_list = json.load(f)

for val_img in file_list:
    os.system("cp {} validation/".format(val_img))
