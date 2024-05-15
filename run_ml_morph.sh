# #!/bin/bash

# # IMAGE_DIR="../tpsdig/Wing Images/Agapostemon texanus"
# # TPS_FILE="../tpsdig/Wing TPS/Agapostemon texanus.tps"

# IMAGE_DIR="../tpsdig/Wing Images/Agapostemon texanus"
# TPS_FILE="../tpsdig/Wing TPS/Agapostemon texanus.tps"

# # IMAGE_DIR="../tpsdig/Wing Images/Bombus californicus"
# # TPS_FILE="../tpsdig/Wing TPS/Bombus californicus.tps"

# # IMAGE_DIR="../tpsdig/Wing Images/Bombus vosnesenskii"
# # TPS_FILE="../tpsdig/Wing TPS/Bombus vosnesenskii.tps"

# # IMAGE_DIR="../tpsdig/Wing Images/Xylocopa tabaniformis orpifex"
# # TPS_FILE="../tpsdig/Wing TPS/Xylocopa tabaniformis orpifex.tps"

# # IMAGE_DIR="./image-examples"
# # TPS_FILE="./landmark-examples/tps-example.tps"

# # IMAGE_DIR="../bee-image-data/Images/MasterFolder_PhenotypicDivergence2023"
# # TPS_FILE="../bee-image-data/Images/TPS files/all rubicundus TPS (to append)/set19_30sep2020.tps"
# # TPS_FILE="../bee-image-data/Images/TPS files/all tripartitus TPS files (to append)/set14_29sep2020.tps"


# # # Visualize TPS coordinates on images before training
# # echo "Visualizing TPS coordinates on images..."
# # python3 visualize_tps_on_images.py -i "$IMAGE_DIR" -t "$TPS_FILE" -o "./training_landmarked_images"


# # Hyperparameters
# THREADS=6
# # Defines the size of the sliding window that scans through the image to detect objects. The window size should be large enough to encompass the objects of interest but small enough to maintain computational efficiency.
# echo "Calculating ideal window size..."
# # WINDOW_SIZE=$(python3 calculate_window_size.py "$TPS_FILE")
# WINDOW_SIZE=800

# echo "Ideal window size calculated: $WINDOW_SIZE"

# # This is the insensitivity parameter for the SVM training in object detection. A smaller epsilon can make the classifier more sensitive to training errors, potentially leading to a more accurate but less general model.
# EPSILON=0.2

# # The soft margin parameter C for the SVM. A higher value of C tries to classify all training examples correctly (higher penalty for misclassification), while a lower value allows more misclassifications but can generalize better.
# C_PARAM=5

# # In shape prediction, this defines the depth of the trees in the regression model. Deeper trees can model more complex patterns but may overfit on smaller or less diverse datasets.
# TREE_DEPTH=5

# # Specifies the depth of the cascade in the shape predictor. Each level of the cascade refines the predictions from the previous level, allowing for more precise landmarking.
# CASCADE_DEPTH=50

# # The regularization parameter in the shape predictor. It controls the trade-off between the model's complexity and the amount it learns from the training data. Lower values lead to more regularization (simpler models).
# NU=0.01

# # Determines how much the training data is augmented by sampling more examples around the landmarks. Higher oversampling can help the model learn more robust features but may increase training time.
# OVERSAMPLING=50

# # The number of random splits used for testing during training of the shape predictor. More splits can provide a better estimate of model performance but increase computational cost.
# TEST_SPLITS=100

# # Defines the size of the pool of pixel intensity differences features used to train the shape predictor. A larger pool provides a richer set of features but increases the complexity and potentially the overfitting risk.
# FEATURE_POOL_SIZE=500

# # Specifies the number of regression trees used in each cascade level of the shape predictor. More trees can improve the accuracy but also increase the model size and inference time.
# NUM_TREES=400


# # Filename for saving results
# # FILENAME="detector_Threads-${THREADS}_WindowSize-${WINDOW_SIZE}_Epsilon-${EPSILON}_CParam-${C_PARAM}_predictor_TreeDepth-${TREE_DEPTH}_CascadeDepth-${CASCADE_DEPTH}_Nu-${NU}_Oversampling-${OVERSAMPLING}_TestSplits-${TEST_SPLITS}_FeaturePoolSize-${FEATURE_POOL_SIZE}_NumTrees-${NUM_TREES}"
# FILENAME="WindowSize=${WINDOW_SIZE}"

# # step 1: preprocessing
# # splitting images into train and test sets, generating xml files
# echo "running preprocessing..."
# python3 preprocessing.py -i "$IMAGE_DIR" -t "$TPS_FILE"


# # step 2: training object detectors
# # training the object detector model
# echo "training object detector..."
# # runs object detector training with 8 threads, window size as calculated, epsilon 0.001, and C parameter 15
# python3 detector_trainer.py -d train.xml -t test.xml -n $THREADS -w $WINDOW_SIZE -e $EPSILON -c $C_PARAM

# # step 3: training shape predictors
# # training the shape predictor model
# echo "training shape predictor..."
# # runs shape training with 8 threads, tree depth 5, cascade depth 20, nu 0.08, oversampling 200, 20 test splits, feature pool size 700, and 400 trees
# python3 shape_trainer.py -d train.xml -t test.xml -th $THREADS -dp $TREE_DEPTH -c $CASCADE_DEPTH -nu $NU -os $OVERSAMPLING -s $TEST_SPLITS -f $FEATURE_POOL_SIZE -n $NUM_TREES

# # step 4: predicting landmarks
# # predicting landmarks on new images
# echo "predicting landmarks..."
# python3 prediction.py -i test -d detector.svm -p predictor.dat


# echo "overlaying landmarks on images..."
# python3 overlay_landmarks.py -x "output.xml" -o "./landmarked_images" -f "$FILENAME"
# echo "ml-morph pipeline execution completed."

# echo "ml-morph pipeline execution completed."


#!/bin/bash

IMAGE_DIR="../tpsdig/Wing Images/Agapostemon texanus"
TPS_FILE="../tpsdig/Wing TPS/Agapostemon texanus.tps"

THREADS=6

# Define ranges for each parameter
window_sizes=(200 400 600 800)
epsilons=(0.1 0.2 0.3)
c_params=(1 5 10)
tree_depths=(3 5 7)
cascade_depths=(30 50 70)
nus=(0.01 0.05 0.1)
oversamplings=(20 50 100)
test_splits=(50 100 150)
feature_pool_sizes=(300 500 700)
num_trees=(200 400 600)

# Loop over each parameter
for WINDOW_SIZE in "${window_sizes[@]}"
do
  for EPSILON in "${epsilons[@]}"
  do
    for C_PARAM in "${c_params[@]}"
    do
      for TREE_DEPTH in "${tree_depths[@]}"
      do
        for CASCADE_DEPTH in "${cascade_depths[@]}"
        do
          for NU in "${nus[@]}"
          do
            for OVERSAMPLING in "${oversamplings[@]}"
            do
              for TEST_SPLIT in "${test_splits[@]}"
              do
                for FEATURE_POOL_SIZE in "${feature_pool_sizes[@]}"
                do
                  for NUM_TREE in "${num_trees[@]}"
                  do
                    FILENAME="WindowSize-${WINDOW_SIZE}_Eps-${EPSILON}_C-${C_PARAM}_Tree-${TREE_DEPTH}_Cascade-${CASCADE_DEPTH}_Nu-${NU}_Over-${OVERSAMPLING}_Split-${TEST_SPLIT}_Feature-${FEATURE_POOL_SIZE}_Trees-${NUM_TREE}"
                    echo "Running configuration: $FILENAME"

                    # Preprocessing
                    echo "running preprocessing..."
                    python3 preprocessing.py -i "$IMAGE_DIR" -t "$TPS_FILE"

                    # Training object detectors
                    echo "training object detector..."
                    python3 detector_trainer.py -d train.xml -t test.xml -n $THREADS -w $WINDOW_SIZE -e $EPSILON -c $C_PARAM

                    # Training shape predictors
                    echo "training shape predictor..."
                    python3 shape_trainer.py -d train.xml -t test.xml -th $THREADS -dp $TREE_DEPTH -c $CASCADE_DEPTH -nu $NU -os $OVERSAMPLING -s $TEST_SPLIT -f $FEATURE_POOL_SIZE -n $NUM_TREE

                    # Predicting landmarks
                    echo "predicting landmarks..."
                    python3 prediction.py -i test -d detector.svm -p predictor.dat

                    echo "overlaying landmarks on images..."
                    python3 overlay_landmarks.py -x "output.xml" -o "./landmarked_images" -f "$FILENAME"
                    echo "Configuration $FILENAME completed."
                  done
                done
              done
            done
          done
        done
      done
    done
  done
done

echo "All configurations have been processed."