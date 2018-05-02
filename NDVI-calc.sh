# gets read from a database, hardwired here
NDVI_COLORMAP="006600 008800 00BB00 00FF00 CCFF00 FFFF00 FFCC00 FF8800 FF0000 EE0000 DD0000 CC0000 BB0000 AA0000 990000 880000 770000"


python write_colormap_file.py "$NDVI_COLORMAP" custom.txt


echo "Creating NIR part of the NDVI color image for red filtered image..."
python gdal_calc.py --calc="A" --A_band=2 --type=Float32 -A ndvi_input.tif --outfile nir_CIR.tif --NoDataValue=1.001 --overwrite


echo "Creating VIS part of the NDVI color image for red filtered image..."
python gdal_calc.py --calc="A" --A_band=1 --type=Float32 -A ndvi_input.tif --outfile red_CIR.tif --NoDataValue=1.001 --overwrite


echo "Doing the image math to create the NDVI image."
python gdal_calc.py --calc="((A-B)/(A+B))" --type=Float32 -A nir_CIR.tif -B red_CIR.tif --outfile new_ndvi.tif --overwrite --NoDataValue=1.001


echo "Color mapping the NDVI image."
# this one creates the version with the alpha channel.  It gets up uploaded.
gdaldem color-relief new_ndvi.tif custom.txt output_ndvi.tif -alpha
