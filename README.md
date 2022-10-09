# AIO CaseStudy

## A Case Study for Object Detection of Selected Marine Life Species from FathomNet Data

This guide provides code and explains how to obtain the results presented in the paper:

*Demystifying image-based machine learning: a practical guide to automated analysis of imagery using modern machine learning tools*

The code includes bash shell and Python scripts and makes use of `fathomnet-py and YOLOv5`. These scripts are known to run on and have been tested on Ubuntu 18.04 LTS and 20.04 LTS.  
Python >= 3.7 is required.

## Train on FathomNet Dataset ##

### Create Dataset ###

YOLOv5 requires labeled data to learn the object classes. Data for this case study is prepared manually by downloading the different species from the FathomNet data.

`download_images_and_bboxes.sh` is a bash script to download images and bounding boxes for the species selected. It requires `fathomnet.py`, which can be installed via

```bash
python -m pip install fathomnet
```

Details about fathomnet.py and its requirements can be found [here](https://github.com/fathomnet/fathomnet-py)

The species selected are:
* Chiroteuthis calyx
* Dosidicus gigas
* Gonatus onyx
* Sebastes
* Sebastes diploproa
* Sebastes melanostomus
* Sebastolobus

For training and detection purposes, Sebastes, Sebastes diploproa and Sebastes melanostomus are grouped as a single Sebastes class due to the small number of images for the two latter species.

`download_images_and_bboxes.sh` will download the data into different spatial/depth regions and
different temporal regions.

```bash
source download_images_and_bboxes.sh
```

The data will be downloaded to directory `data` where the script was run and the directory structure for the data will be 

- [ ] add link to directory structures

Data annotations are provided in COCO format. To convert COCO json files to YOLO format, use `coco2yolo.py`.

```bash
python3 coco2yolo.py path/to/coco/json/files
```

where `path/to/coco/json/files` is a directory that is searched to find all COCO `*.json` files from which the corresponding YOLO annotations files are generated.

To convert all the COCO json files in `data`:
```bash
python3 coco2yolo.py .../user/data
```

`split_data_for_training.py` is a Python script that will split data for each species into
train, val, and test directories and store in the appropriate domain directories.

For example:
downloaded images and labels are found in
       …/user/data/pre_2012/species/<images,labels>
The images and labels directories for training will be created in
       …/user/data/pre_2012/images/<train,val,test>
    …/user/data/pre_2012/labels/<train,val,test>

- [ ] add or describe script for producing yaml file

### Train ###
For this case study, we use YOLOv5. For information, requirements, installation and examples,
see  [YOLOv5](https://github.com/ultralytics/yolov5)

To train a YOLOv5 model with our datasets, run the command 
```bash
python3 train.py --img 640 --batch 16 --epochs 300 --data <data.yaml> --weights yolov5s.pt --cache
```

Training results are saved to `runs/train` with incrementing directories, i.e. `runs/train/exp2`, `runs/train/exp3`, etc.
Adding `--name <some_name>` to train.py will save training results in `runs/train/some_name`, `runs/train/some_name2`, etc.

### Next Steps ###
Once the model is trained, use the best.pt weights to
* validate accuracy on train, val and test splits
* detect objects in test or out of doamin splits

A YOLOv5 Notebook is provided as an example on how to run the train, validation and detection pipeline.
- [ ] add link to Colab Notebook 
