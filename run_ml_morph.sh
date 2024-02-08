#!/bin/bash

# variables - update these with your specific paths
image_dir="./bee-image-data/Images/MasterFolder_PhenotypicDivergence2023"
# tps_file="./bee-image-data/Images/TPS files/all rubicundus TPS (to append)/set19_30sep2020.tps"
tps_file="./bee-image-data/Images/TPS files/all tripartitus TPS files (to append)/set14_29sep2020.tps"

# step 1: preprocessing
# splitting images into train and test sets, generating xml files
echo "running preprocessing..."
python3 preprocessing.py -i "$image_dir" -t "$tps_file"

# step 2: training object detectors
# training the object detector model
echo "training object detector..."
python3 detector_trainer.py -d train.xml -t test.xml

# step 3: training shape predictors
# training the shape predictor model
echo "training shape predictor..."
python3 shape_trainer.py -d train.xml -t test.xml

# step 4: predicting landmarks
# predicting landmarks on new images
echo "predicting landmarks..."
python3 prediction.py -i test -d detector.svm -p predictor.dat

# overlaying landmarks on images
echo "overlaying landmarks on images..."
python3 overlay_landmarks.py

echo "ml-morph pipeline execution completed."
