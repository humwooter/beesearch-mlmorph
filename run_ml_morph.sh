#!/bin/bash

# variables - update these with your specific paths
IMAGE_DIR="../tpsdig/Wing Images/Agapostemon texanus"
TPS_FILE="../tpsdig/Wing TPS/Agapostemon texanus.tps"

# IMAGE_DIR="./image-examples"
# TPS_FILE="./landmark-examples/tps-example.tps"

# IMAGE_DIR="../bee-image-data/Images/MasterFolder_PhenotypicDivergence2023"
# TPS_FILE="../bee-image-data/Images/TPS files/all rubicundus TPS (to append)/set19_30sep2020.tps"
# TPS_FILE="../bee-image-data/Images/TPS files/all tripartitus TPS files (to append)/set14_29sep2020.tps"


# step 1: preprocessing
# splitting images into train and test sets, generating xml files
echo "running preprocessing..."
python3 preprocessing.py -i "$IMAGE_DIR" -t "$TPS_FILE"

# # Visualize TPS coordinates on images before training
# echo "Visualizing TPS coordinates on images..."
# python3 visualize_tps_on_images.py -i "$IMAGE_DIR" -t "$TPS_FILE" -o "./training_landmarked_images"

# Calculate ideal window size
echo "Calculating ideal window size..."
WINDOW_SIZE=$(python3 calculate_window_size.py "$TPS_FILE")
echo "Ideal window size calculated: $WINDOW_SIZE"



# step 2: training object detectors
# training the object detector model
echo "training object detector..."
python3 detector_trainer.py -d train.xml -t test.xml -n 8 -w $WINDOW_SIZE -e 0.001 -c 15

# step 3: training shape predictors
# training the shape predictor model
echo "training shape predictor..."
# runs shape training with 8 threads, tree depth 5, cascade depth 20, nu 0.08, oversampling 200, 25 test splits, feature pool size 700, and 400 trees
python3 shape_trainer.py -d train.xml -t test.xml -th 8 -dp 5 -c 20  -nu 0.08 -os 200 -s 25 -f 700 -n 400

# step 4: predicting landmarks
# predicting landmarks on new images
echo "predicting landmarks..."
python3 prediction.py -i test -d detector.svm -p predictor.dat

# overlaying landmarks on images
echo "overlaying landmarks on images..."
python3 overlay_landmarks.py

echo "ml-morph pipeline execution completed."

