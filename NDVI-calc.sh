# gets read from a database, hardwired here
NDVI_COLORMAP="006600 008800 00BB00 00FF00 CCFF00 FFFF00 FFCC00 FF8800 FF0000 EE0000 DD0000 CC0000 BB0000 AA0000 990000 880000 770000"

NIR_INPUT=IMG_171026_183605_0000_NIR.jpg
NIR_OUTPUT=nir_output.tif

RED_INPUT=IMG_171026_183605_0000_RED.jpg
RED_OUTPUT=red_output.tif

NDVI_IMAGE=new_ndvi.tif
NDVI_COLOR=ndvi_color.tif

python write_colormap_file.py "$NDVI_COLORMAP" custom.txt

echo "NIR input: $NIR_INPUT"
echo "Creating NIR part of the NDVI color image for red filtered image..."

gdal_calc.py --calc="A" --A_band=1 --type=Float32 -A $NIR_INPUT --outfile $NIR_OUTPUT --NoDataValue=1.001 --overwrite

echo "NIR output: $NIR_OUTPUT"


echo "Red input: $RED_INPUT"
echo "Creating VIS part of the NDVI color image for red filtered image..."

gdal_calc.py --calc="A" --A_band=1 --type=Float32 -A $RED_INPUT --outfile $RED_OUTPUT --NoDataValue=1.001 --overwrite

echo "Red output: $RED_OUTPUT"


echo "Doing the image math to create the NDVI image."

gdal_calc.py --calc="((A-B)/(A+B))" --type=Float32 -A $NIR_OUTPUT -B $RED_OUTPUT --outfile $NDVI_IMAGE --overwrite --NoDataValue=1.001


echo "Color mapping the NDVI image."
# this one creates the version with the alpha channel.  It gets up uploaded.

gdaldem color-relief $NDVI_IMAGE custom.txt $NDVI_COLOR -alpha

echo "Final output: $NDVI_COLOR"