# docker_python3_opencv_exiv2

## Docker image with ubuntu:16.04, python 3.5, opencv 3.4.1, and py3exiv2

Usage:

    ```bash
    docker run -it -v /$(pwd)/:/data garretw/docker_python3_opencv_exiv2:1.0 /bin/bash
    $ python3
    >>> import cv2
    >>> import pyexiv2
    ```

#### -v connects you to your current directory on your host computer. 

#### The working directory is set as ```/data``` on the container.

