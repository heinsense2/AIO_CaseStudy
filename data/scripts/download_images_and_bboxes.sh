#!/bin/bash

#
# download_images_and_bboxes.sh
#
# Bash script for downloading bounding boxes (annotations) and images
# for FathomNet data used in "paper"
#
# Species:
#    SQUID and JELLIES
#	(1) Chiroteuthis calyx
#	(2) Dosidicus gigas
#	(3) Gonatus onyx
#	Nanomia bijuga
#
#    FISH
#	(4) Sebastes - these are rockfish, commercially important
#	(4) Sebastes diploproa - a Sebastes species
#	(4) Sebastes melanostomus - a Sebastes species
#	(5) Sebastolobus - the thornyheads
#
#    NOTE: For training and detection purposes, we have grouped Sebastes,
#	   Sebastes diploproa and Sebastes melanostomus into a single Sebastes
#	   class due to the small number of images for the two later species.

SPECIES_LIST=("Chiroteuthis calyx" "Dosidicus gigas" "Gonatus onyx"\
        "Sebastes" "Sebastes diploproa" "Sebastes melanostomus" "Sebastolobus")


# Data Splits
#    Data is split into regions to examine the effects of "distribution shifts"
#    Splits are made to have "semi equal" amount of species in each split
#
#    The first split is by regions, ie, by latitute, longitude and depth
#    For this split, different criteria is used for different species
# 	Chiroteuthis calyx
# 		region 1: < 450 meters
# 		region 2 > 450 mmeters
#	Dosidicus gigas:
# 		region 1: > 500 meters depth
# 		region 1: < 500 meters depth
# 	Gonatus onyx, why don't we make this split
# 		region 1: < 1000 meters depth
# 		region 2: > 1000 meters depth
# 	Sebastes
# 		region 1: <32 degrees latitude
# 		region 2: > 32 degrees latitude
# 	Sebastes_diploproa and Sebastes_melanostomus
# 		region 1: <36 degrees latitude
# 		region 2: > 36 degrees latitude
# 	Sebastolobus:
# 		region 1: < 38 degrees latitude
# 		region 2: > 38 degrees latitude
#
#    The second split is based on time, specifically years.
#    2012 is used as the cutting point, so we have images taken before 2012
#    and images taken between 2012 and the present.

# Data directories. Data will be downloaded here.
# (modify to indicate the directory to download data)

#	data
#	├── regions
#	│   ├── region_1
#	│   └── region_2
#	└── years
#	    ├── post_2012
#	    └── pre_2012

REGIONS_DIR="./data/regions"
YEARS_DIR="./data/years"
mkdir -p $REGIONS_DIR
mkdir -p $YEARS_DIR

# Get bboxes and images for Fish, Jellies and Squid species

# IMPORTANT:
#	Splits are made to have "semi equal" amount of species in each split.
#
#	fathomnet-generate does not allow for downloading multiple "concepts"
#	(species) with multiple	"constraints" (latitue, longitude, depth).
#	Therefore each species for the region splits were downloaded individually.
#
#	For these reasons we download the data one species at a time.
#
#	Downloading one species at a time creates an issue with the categories 
#	(species id), Each species will have a species id of 0 (zero). 
#	This will have to be changed accordingly in the	annotations.
#	NOTE: This a handled in the python script coco2yolo.py
#
#	fathomnet-generate does not generate YOLO annotations. COCO annotations
#	are generated and later converted to YOLO annotations.
#

# This is the general form of the command used to download the data
# fathomnet-generate 
#	('-c', '--concepts', dest='concepts', type=comma_list, help='Comma-separated list of concepts to include')
#	('--concepts-file', dest='concepts_file', type=str, help='File containing newline-delimited list of concepts to include')

# Download Regions 1 and 2 for each species

# Chiroteuthis calyx
# region 1: < 450 meters
# region 2: > 450 mmeters
fathomnet-generate -c "Chiroteuthis calyx" --max-depth 450 \
	 --format coco -o $REGIONS_DIR/region_1/Chiroteuthis_calyx
#	 --img-download $REGIONS_DIR/region_1/Chiroteuthis_calyx/images \

fathomnet-generate -c "Chiroteuthis calyx" --min-depth 451 \
	 --format coco -o $REGIONS_DIR/region_2/Chiroteuthis_calyx
#	 --img-download $REGIONS_DIR/region_2/Chiroteuthis_calyx/images \

# Dosidicus gigas:
# region 1: > 500 meters depth
# region 2: < 500 meters depth
fathomnet-generate -c "Dosidicus gigas" --min-depth 501 \
	--format coco -o $REGIONS_DIR/region_1/Dosidicus_gigas
#	--img-download $REGIONS_DIR/region_1/Dosidicus_gigas/images \

fathomnet-generate -c "Dosidicus gigas" --max-depth 500 \
	--format coco -o $REGIONS_DIR/region_2/Dosidicus_gigas
#	--img-download $REGIONS_DIR/region_2/Dosidicus_gigas/images \

# Gonatus onyx
# region 1: < 1000 meters depth
# region 2: > 1000 meters depth
fathomnet-generate -c "Gonatus onyx" --max-depth 1000 \
	--format coco -o $REGIONS_DIR/region_1/Gonatus_onyx
#	--img-download $REGIONS_DIR/region_1/Gonatus_onyx/images \

fathomnet-generate -c "Gonatus onyx" --min-depth 1001 \
	--format coco -o $REGIONS_DIR/region_2/Gonatus_onyx
#	--img-download $REGIONS_DIR/region_2/Gonatus_onyx/images \

# Sebastes
# region 1: < 32 degrees latitude
# region 2: > 32 degrees latitude
fathomnet-generate -c "Sebastes"  --max-latitude 32.0 \
	--format coco -o $REGIONS_DIR/region_1/Sebastes
#	--img-download $REGIONS_DIR/region_1/Sebastes/images \

fathomnet-generate -c "Sebastes"  --min-latitude 32.1 \
	--format coco -o $REGIONS_DIR/region_2/Sebastes
#	--img-download $REGIONS_DIR/region_2/Sebastes/images \

# Sebastes diploproa, Sebastes melanostomus
# region 1: < 36 degrees latitude
# region 2: > 36 degrees latitude
fathomnet-generate -c "Sebastes diploproa"  --min-latitude 36.0 \
	--format coco -o $REGIONS_DIR/region_1/Sebastes_diploproa
#	--img-download $REGIONS_DIR/region_1/Sebastes_diploproa/images \

fathomnet-generate -c "Sebastes diploproa"  --max-latitude 35.999 \
	--format coco -o $REGIONS_DIR/region_2/Sebastes_diploproa
#	--img-download $REGIONS_DIR/region_2/Sebastes_diploproa/images \

fathomnet-generate -c "Sebastes melanostomus"  --min-latitude 36.0 \
	--format coco -o $REGIONS_DIR/region_1/Sebastes_melanostomus
#	--img-download $REGIONS_DIR/region_1/Sebastes_melanostomus/images \

fathomnet-generate -c "Sebastes melanostomus"  --max-latitude 35.999 \
	--format coco -o $REGIONS_DIR/region_2/Sebastes_melanostomus
#	--img-download $REGIONS_DIR/region_2/Sebastes_melanostomus/images \

# Sebastolobus:
# region 1: < 38 degrees latitude
# region 2: > 38 degrees latitude
fathomnet-generate -c "Sebastolobus" --max-latitude 38.0 \
	--format coco -o $REGIONS_DIR/region_1/Sebastolobus
#	--img-download $REGIONS_DIR/region_1/Sebastolobus/images \

fathomnet-generate -c "Sebastolobus" --min-latitude 38.1 \
	--format coco -o $REGIONS_DIR/region_2/Sebastolobus
#	--img-download $REGIONS_DIR/region_2/Sebastolobus/images \


#
# Download Time Pre-2012 and Post-2012 for all species
TOPDIR="./fish_squid_years"
SPECIES_LIST=("Chiroteuthis calyx" "Dosidicus gigas" "Gonatus onyx"\
        "Sebastes" "Sebastes diploproa" "Sebastes melanostomus" "Sebastolobus")

# Create regions partition image and label directories for training needed for YOLOv5
mkdir -p $REGIONS_DIR/region_1/yolov5/images/{train,val,test}
mkdir -p $REGIONS_DIR/region_1/yolov5/labels/{train,val,test}
mkdir -p $REGIONS_DIR/region_2/yolov5/images/{train,val,test}
mkdir -p $REGIONS_DIR/region_2/yolov5/labels/{train,val,test}


# Year Splits

# Download each species images into their own directory 
# and annotations for each species in a different file
for species in "${SPECIES_LIST[@]}"
do
    # Pre 2012
#    fathomnet-generate -c "$species" --end '2011-12-31' --img-download  $YEARS_DIR/pre_2012/${species/ /_}/images --format coco -o pre_2012/${species/ /_}
    fathomnet-generate -c "$species" --end '2011-12-31' --format coco -o $YEARS_DIR/pre_2012/${species/ /_}

    # Post 2012
#    fathomnet-generate -c "$species" --start '2012-01-01' --img-download  $YEARS_DIR/post_2012/${species/ /_}/images --format coco -o post_2012/${species/ /_}
    fathomnet-generate -c "$species" --start '2012-01-01' --format coco -o $YEARS_DIR/post_2012/${species/ /_}

done

# Create image and label directories for each temporal domain for training
mkdir -p $YEARS_DIR/pre_2012/yolov5/images/{train,val,test}
mkdir -p $YEARS_DIR/pre_2012/yolov5/labels/{train,val,test}
mkdir -p $YEARS_DIR/post_2012/yolov5/images/{train,val test}
mkdir -p $YEARS_DIR/post_2012/yolov5/labels/{train,val,test}

