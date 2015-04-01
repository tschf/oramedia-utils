create or replace package image_api
as

    /*

        Supported image operations can be found here: - http://docs.oracle.com/cd/E11882_01/appdev.112/e10776/ap_imgproc.htm#CHDGACDH 

    */

    dimension_too_large exception;

    type image_dimensions is record (
        width INTEGER,
        height INTEGER
    );

    function get_dimensions(
        p_image in BLOB
    )
    return image_dimensions;

    function crop(
        p_image in BLOB
      , p_x_start in NUMBER
      , p_y_start in NUMBER
      , p_width in NUMBER default NULL
      , p_height in NUMBER default NULL)
    return BLOB;

    function vertical_flip(
        p_image in BLOB)
    return BLOB;

    function horizontal_flip(
        p_image in BLOB)
    return BLOB;

    /*

        Scale an image to the specified dimensions.
        Refer to the following documentation:

        - http://docs.oracle.com/cd/E11882_01/appdev.112/e10776/ap_imgproc.htm#CHDGACDH
        - http://docs.oracle.com/cd/E11882_01/appdev.112/e10776/ap_imgproc.htm#CHDGEEHD (maintain aspect ratio)

    */
    function scale(
        p_image in BLOB
      , p_width in NUMBER
      , p_height in NUMBER
      , p_maintain_aspect_ratio in BOOLEAN default TRUE)
    return BLOB;

end image_api;
