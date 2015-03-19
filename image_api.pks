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

end image_api;
