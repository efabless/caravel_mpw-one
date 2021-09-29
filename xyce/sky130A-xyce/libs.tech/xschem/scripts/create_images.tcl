## xschem script to generate symbol images
proc create_images {src dest format_list width height viewport} {
    # loop over image format list {svg png ps pdf}
    foreach type $format_list {
        # loop over all symbol files
        foreach i [glob $src/*.sym] {
            xschem clear_drawing
            # place symbol at 0,0
            xschem instance $i 0 0 0 0 {}
            # build image file name
            set imagefile $dest/[file rootname [file tail $i]].$type
            # generate image and save to disk
            eval xschem print $type $imagefile $width $height $viewport
            puts "creating: $imagefile"
        }
    }
    xschem clear_drawing
    xschem redraw
}

xschem toggle_colorscheme
#               src dir        dst dir          formats    w    h      viewport
create_images  sky130_fd_pr  sky130_fd_pr/doc  {  svg  }  300  150  {-50 -50 150 50}
xschem toggle_colorscheme

## to add transparent background:
#
# sed -i '/^\.l0/ a \  fill-opacity:0;' *.svg


