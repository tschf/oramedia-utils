create or replace package image_api
as

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

end image_api;
