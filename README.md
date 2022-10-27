# AIO CaseStudy

## A Case Study for Object Detection of Selected Marine Life Species from FathomNet Data

This guide provides code and presents a guideline on how the results presented in the paper:

*Demystifying image-based machine learning: a practical guide to automated analysis of imagery using modern machine learning tools*

were obtained.

The code includes bash shell and Python scripts and makes use of [`fathomnet-py`](https://github.com/fathomnet/fathomnet-py) and [`YOLOv5`](https://github.com/ultralytics/yolov5). These scripts are known to run on and have been tested on Ubuntu 18.04 LTS and 20.04 LTS.  
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
* Nanomia bijuga

For training and detection purposes, Sebastes, Sebastes diploproa and Sebastes melanostomus are grouped as a single Sebastes class due to the small number of images for the two latter species.
Nanomia bijuga is used only as a distractor class in a separate experiment.

[`download_images_and_bboxes.sh`](https://github.com/heinsense2/AIO_CaseStudy/blob/main/data/scripts/download_images_and_bboxes.sh)  will download the data into the different spatial/depth regions and temporal regions. Nanomia bijuga is downloaded separetely.

```bash
source download_images_and_bboxes.sh
```

The data will be downloaded to directory `data` in the directory where the script is run.
The directory structure for the data will be look like [this](https://github.com/heinsense2/AIO_CaseStudy/tree/main/data/html/data_directory_splits.html)

Data annotations are provided in COCO format. To convert COCO json files to YOLO format, use `coco2yolo.py`.

```bash
python3 coco2yolo.py path/to/coco/json/files
```

where `path/to/coco/json/files` is a directory that is searched to find all COCO `*.json` files from which the corresponding YOLO annotations files are generated.

To convert all the COCO json files in `data`:
```bash
python3 coco2yolo.py .../user/data
```

[`prepare_data_for_training.py`](https://github.com/heinsense2/AIO_CaseStudy/blob/main/data/scripts/prepare_data_for_training.py) is a Python script that prepares tha data for trainimg. The script will split data for each species into train, val, and test directories, create an out-of-domain dataset consisting of all the images, produce the yaml files required and store everything in the appropriate domain directories.

For example:

downloaded images and labels are found in
```
    …/user/data/pre_2012/species/<images,labels>
```
       
`prepare_data_for_training` will produce the [following](https://github.com/heinsense2/AIO_CaseStudy/tree/main/data/html/yolov5_dirs.html):

The images and labels directories for training will be created in
```
    …/user/data/pre_2012/yolov5/images/<train,val,test>
    …/user/data/pre_2012/yolov5/labels/<train,val,test>
 ```
 The out of domain dataset can be found in
 ```
       …/user/data/pre_2012/yolov5/all/<images,labels>
 ```
 and the yaml files will be:
 ```
       …/user/data/pre_2012/yolov5/<pre_2012.yaml,pre_2012_as_out_of_domain.yaml>
 ```


### Train ###
For this case study, we use YOLOv5. For information, requirements, installation and examples,
see  [YOLOv5](https://github.com/ultralytics/yolov5).

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

A [Google Colab Notebook](https://github.com/heinsense2/AIO_CaseStudy/blob/main/notebooks/Training_on_FathomNet_Custom_Data.ipynb) is provided as an example on how to run the train, validation and detection pipeline.
 
