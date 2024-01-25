#!/bin/bash

# Variables - Update these with your specific paths
IMAGE_DIR="image-examples"
TPS_FILE="landmark-examples/tps-example.tps"

# Step 1: Preprocessing
# Splitting images into train and test sets and generating XML files
echo "Running preprocessing..."
python3 preprocessing.py -i "$IMAGE_DIR" -t "$TPS_FILE"

# Step 2: Training Object Detectors
# Training the object detector model
echo "Training object detector..."
python3 detector_trainer.py -d train.xml -t test.xml

# Step 3: Training Shape Predictors
# Training the shape predictor model
echo "Training shape predictor..."
python3 shape_trainer.py -d train.xml -t test.xml

# Step 4: Predicting Landmarks
# Predicting landmarks on new images
echo "Predicting landmarks..."
python3 prediction.py -i test -d detector.svm -p predictor.dat

echo "ml-morph pipeline execution completed."
