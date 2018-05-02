# calculate the scaling percentage to make the full res output fit inside 65000

import argparse

if __name__ == '__main__':      
    
    p = argparse.ArgumentParser (description = 'Given a colormap string, this script will generate a file to use as the colormap for gdaldem.')
    p.add_argument("colormap", type = str, help = 'Colormap String')
    p.add_argument("file_location", type = str, help = 'Target location for the generated colormap file.')

    args = p.parse_args() 

    f = open(args.file_location, 'w+')
    
    vals = [-.941, -.824, -.706, -.588, -.471, -.353, -.235, -.118, 0, .118, .235, .353, .471, .588, .706, .824, .941]
    
    # parse colormap string into list of int color values
    
    colors = []
    hexs = args.colormap.split(" ")
    
    for h in reversed(hexs):  # hexes come in positive to negative
        red = int(h[0:2], 16)
        green = int(h[2:4], 16)
        blue = int(h[4:6], 16)
        
        colors.append(str(red) + ' ' + str(green) + ' ' + str(blue))
    
    f.write('-1 ' + colors[0] + ' 255\n')
    for i in range(len(colors)):
        f.write(str(vals[i]) + ' ' + colors[i] + ' 255\n')
        
    f.write('1 ' + colors[len(colors)-1] + ' 255\n')
    f.write('nv 0 0 0 0\n')
    
    f.close()
    
    f = open(args.file_location+"x", 'w+')
    
    vals = [-.941, -.824, -.706, -.588, -.471, -.353, -.235, -.118, 0, .118, .235, .353, .471, .588, .706, .824, .941]
    
    # parse colormap string into list of int color values
    
    colors = []
    hexs = args.colormap.split(" ")
    
    for h in reversed(hexs):  # hexes come in positive to negative
        red = int(h[0:2], 16)
        green = int(h[2:4], 16)
        blue = int(h[4:6], 16)
        
        colors.append(str(red) + ' ' + str(green) + ' ' + str(blue))
    
    f.write('-1 ' + colors[0] + ' 255\n')
    for i in range(len(colors)):
        f.write(str(vals[i]) + ' ' + colors[i] + ' 255\n')
        
    f.write('1 ' + colors[len(colors)-1] + ' 255\n')
    f.write('nv 22 33 44 0\n')
    
    f.close()    
    

    
