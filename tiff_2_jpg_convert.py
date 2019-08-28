import argparse 
import pyexiv2 
import cv2 
import os.path
import numpy as np


ap = argparse.ArgumentParser() 
ap.add_argument("-i", "--input", required=True, help="input image name.") 
args = vars(ap.parse_args())

input_filename = args["input"]

file_basename = os.path.splitext(input_filename)[0] 
output_jpg = file_basename + '.jpg'

#print filename 
print("processing " + input_filename)

def copy_tags(raw_filename, undistorted_filename): 
    metadata_raw = pyexiv2.ImageMetadata(raw_filename) 
    metadata_raw.read() 
    metadata_undistorted = pyexiv2.ImageMetadata(undistorted_filename) 
    metadata_undistorted.read() 
    metadata_raw.copy(metadata_undistorted, comment=False) 
    metadata_undistorted.write()

# read image data 
image_read_from_tif = cv2.imread(input_filename, cv2.IMREAD_UNCHANGED)

height, width = image_read_from_tif.shape
print (height, width)

im_grayscale = (image_read_from_tif/256).astype('uint8')

# write image data 
cv2.imwrite(output_jpg, im_grayscale)

# copy over original metadata 
copy_tags(input_filename, output_jpg)