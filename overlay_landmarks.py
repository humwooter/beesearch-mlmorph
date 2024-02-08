import cv2
import xml.etree.ElementTree as ET
import os

def overlay_landmarks(image_dir, xml_file, output_dir):
    """
    Overlays landmarks on images as specified in an XML file and saves the modified images to a specified directory.

    This function reads an XML file containing landmark annotations for images, draws circles at the landmark positions
    on each image, and saves the modified images to a new directory. Each landmark is visualized with a cyan circle
    having a black border for better visibility.

    Parameters:
    - image_dir (str): Directory containing the original images referenced in the XML file.
    - xml_file (str): Path to the XML file containing landmark annotations for the images.
    - output_dir (str): Directory where the modified images with overlaid landmarks will be saved.
    """
    # parse the xml file
    tree = ET.parse(xml_file)
    root = tree.getroot()

    # ensure output directory exists
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    for image in root.findall('images/image'):
        image_path = image.get('file')
        full_image_path = os.path.join(image_dir, image_path)
        print(f"processing image: {full_image_path}")

        # attempt to read the image
        img = cv2.imread(full_image_path)
        if img is None:
            print(f"warning: could not read image {full_image_path}. skipping.")
            continue

        for box in image.findall('box'):
            for part in box.findall('part'):
                x = int(part.get('x'))
                y = int(part.get('y'))
                # draw a black circle (border) larger than the cyan circle
                cv2.circle(img, (x, y), radius=5, color=(0, 0, 0), thickness=-1)
                # draw a smaller bright cyan circle at each landmark
                cv2.circle(img, (x, y), radius=3, color=(255, 255, 0), thickness=-1)  # cyan in bgr is (255, 255, 0)
                print("added landmark with border")

        # construct the output path and save the modified image
        output_image_path = os.path.join(output_dir, image_path)
        # ensure subdirectories exist
        os.makedirs(os.path.dirname(output_image_path), exist_ok=True)
        
        print(f"saving modified image to {output_image_path}")
        if not cv2.imwrite(output_image_path, img):
            print(f"failed to write image {output_image_path}")
        else:
            print(f"image saved successfully: {output_image_path}")

overlay_landmarks('.', 'output.xml', './landmarked_images')
