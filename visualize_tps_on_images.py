import cv2
import numpy as np
import os
import argparse
from utils import read_tps  # This function needs to parse SCALE values along with coordinates

def visualize_tps_coordinates(image_dir, tps_file, output_dir):
    """
    Visualizes TPS coordinates on top of the corresponding images in the image directory and saves the modified images.

    This function reads a TPS file containing landmark coordinates and scale, overlays these coordinates on the corresponding
    images after applying the scale factor, and saves the modified images to a specified directory. Each landmark is visualized with a red circle.

    Parameters:
    - image_dir (str): Directory containing the original images referenced in the TPS file.
    - tps_file (str): Path to the TPS file containing landmark coordinates and scale for the images.
    - output_dir (str): Directory where the modified images with overlaid TPS coordinates will be saved.
    """
    # Function to read TPS data
    tps_data = read_tps(tps_file)

    # Ensure output directory exists
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Process each image and its associated landmarks
    for i, image_name in enumerate(tps_data['im']):
        full_image_path = os.path.join(image_dir, image_name)
        print(f"Processing image: {full_image_path}")

        # Attempt to read the image
        img = cv2.imread(full_image_path)
        if img is None:
            print(f"Warning: could not read image {full_image_path}. Skipping.")
            continue

        # Correctly get scale for current image, default to 1 if not present
        scale = float(tps_data['scl'][i]) if 'scl' in tps_data and len(tps_data['scl']) > i else 1
        print("SCALE: ", scale)

        # Get image dimensions for scaling coordinates
        img_height = img.shape[0]
        img_width = img.shape[1]
        
        # Overlay landmarks on the image
        for coord in tps_data['coords'][i]:
            # Scale and adjust coordinates
            x = int(coord[0] * scale)
            y = int(coord[1] * scale)

            # Draw a red circle at each landmark with a black border for better visibility
            cv2.circle(img, (x, y), radius=5, color=(0, 0, 0), thickness=-1)  # Black border
            cv2.circle(img, (x, y), radius=3, color=(0, 0, 255), thickness=-1)  # Red circle

        # Construct the output path and save the modified image
        output_image_path = os.path.join(output_dir, image_name)
        # Ensure subdirectories exist
        os.makedirs(os.path.dirname(output_image_path), exist_ok=True)
        
        print(f"Saving modified image to {output_image_path}")
        if not cv2.imwrite(output_image_path, img):
            print(f"Failed to write image {output_image_path}")
        else:
            print(f"Image saved successfully: {output_image_path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Visualize TPS coordinates on images.")
    parser.add_argument("-i", "--image_dir", required=True, help="Directory containing the original images.")
    parser.add_argument("-t", "--tps_file", required=True, help="Path to the TPS file containing landmark coordinates and scale.")
    parser.add_argument("-o", "--output_dir", required=True, help="Directory where the modified images will be saved.")
    
    args = parser.parse_args()

    visualize_tps_coordinates(args.image_dir, args.tps_file, args.output_dir)