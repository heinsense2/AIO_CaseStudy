#
"""
Split data into train, val and test

    80% train
    10% val
    10% test

Usage:
	$ python split_data_training.py path/to/data

NOTE: Some assumptions are made about the data locations
      Each downloaded images and labels directory is under the 
	split/species directory
      The images and labels for training will be created under
      the split directory

      For example:
      downloaded images and labels are found in 
	/home/user/data/fathomnet/pre_2012/species/<images,labels>
      The images and labels directories for training will be created in
	/home/user/data/fathomnet/pre_2012/yolov5/images/<train,val,test>
	/home/user/data/fathomnet/pre_2012/yolov5/labels/<train,val,test>
"""

import os
import sys
import numpy as np
import shutil

from sklearn.model_selection import train_test_split

def split_data_train_val_test(data_dir=None):

    # Find all YOLOv5 annotations in data_dir
    label_dirs = []
    for root, dirs, files in os.walk(data_dir):
        if "label" in root and not ("yolov5" in root):
            label_dirs.append(root)

    # For each directory (species)
    for lbl_dir in label_dirs:
        lbl_list  = [f for f in os.listdir(lbl_dir) if f.endswith(".txt")]
        lbl_array = np.array(lbl_list)
    
        img_dir   = lbl_dir.replace("labels", "images")
        dst_dir   = os.path.join(os.path.dirname(os.path.dirname(lbl_dir)), "yolov5")
    
        # Initially divide the data into 80% and 20%. 
        # 80% for training and remaining 20% for test and validation.
        train_data, rest_data = train_test_split(lbl_array, train_size=0.8, test_size=0.2)
    
        # Now you can split the remaining data into 50% each to have 
        # 10% validation and 10% test.
        val_data, test_data = train_test_split(rest_data, test_size=0.5)
    
        # Create train directory and sybolic link to training data images
        # Symbolic links are created to save space and preserve all the original data 
        # in species directory.
        #
        # If you wish to copy the data or move it instead of creating symbolic links
        # replace all instances of os.symlink(src, dest) with 
        # shutil.copy(src, dest) or shutil.move(src, dest)
        #
        for f in train_data:
            # labels
            src = lbl_dir + "/" + f
            dest = dst_dir + "/labels/train/" + f
            try:
                os.symlink(src, dest)
            except:
                pass
    
            # images
            img = f.replace("txt","png")
            src = img_dir + "/" + img
            dest = dst_dir + "/images/train/" + img
            try:
                os.symlink(src, dest)
            except:
                pass
    
        # Move validation data to val directory
        for f in val_data:
            # labels
            src = lbl_dir + "/" + f
            dest = dst_dir + "/labels/val/" + f
            try:
                os.symlink(src, dest)
            except:
                pass
        
            # images
            img = f.replace("txt","png")
            src = img_dir + "/" + img
            dest = dst_dir + "/images/val/" + img
            try:
                os.symlink(src, dest)
            except:
                pass
        
        # Move validation data to test directory
        for f in test_data:
            # labels
            src = lbl_dir + "/" + f
            dest = dst_dir + "/labels/test/" + f
            try:
                os.symlink(src, dest)
            except:
                pass
        
            # images
            img = f.replace("txt","png")
            src = img_dir + "/" + img
            dest = dst_dir + "/images/test/" + img
            try:
                os.symlink(src, dest)
            except:
                pass
    

if __name__ == '__main__':

    if len(sys.argv) <= 1:
        print("Usage: python3 split_data_for_training.py\n /full/path/to/coco/annotation/top/directory")
        exit()
    else:
        data_dir = sys.argv[1]

    print('data directory ', data_dir)
    split_data_train_val_test(data_dir)  # directory with *.json
