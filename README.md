# docker_python3_opencv_exiv2 

## Latest version 1.1
    - added gdal for NDVI

## Docker image with ubuntu:16.04, python 3.5, opencv 3.4.1, and py3exiv2

Usage:

    #### clone this repo.
    * build with 
    ```
    docker build -t garretw/docker_python3_opencv_exiv2:1.1 .
    ```

    * Run with
    ```
    docker run -it --rm -v /$(pwd)/:/data garretw/docker_python3_opencv_exiv2:1.1
    $ python3
    >>> import cv2
    >>> import pyexiv2
    ```

 ``` -v``` connects you to your current directory on your host computer. 

- The working directory is set as ```/data``` on the container.

```--rm``` removes the container once you exit.


 ## Convert TIF to jpg
 ```
 for file in *.TIF; do python3 tiff_2_jpg_convert.py --input $file; done
 ```

 ## NDVI Calculation use NDVI-calc.sh


