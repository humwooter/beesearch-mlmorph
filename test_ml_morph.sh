#!/bin/bash

# Variables – Update these with your specific paths
IMAGE_DIR="./bee-image-data/Images/Halictus_farinosus/H_far_fore_images/"
DETECTOR_MODEL_PATH="detector.svm"
PREDICTOR_MODEL_PATH="predictor.dat"

# Step 1: Predicting Landmarks
# Predicting landmarks on new images using pre-trained models
echo "Running prediction using pre-trained models..."
python3 prediction.py -i "$IMAGE_DIR" -d "$DETECTOR_MODEL_PATH" -p "$PREDICTOR_MODEL_PATH"

echo "Prediction using pre-trained models completed."
