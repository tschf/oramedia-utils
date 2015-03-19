create or replace package body image_api
as

    procedure fetch_properties(
        p_image in BLOB
      , p_attributes out CLOB
      , p_mimeType out varchar2
      , p_width out NUMBER
      , p_height out NUMBER
      , p_fileFormat out varchar2
      , p_contentFormat out varchar2
      , p_compressionFormat out varchar2
      , p_contentLength out varchar2
    )
    as
    begin

        ORDSys.ORDImage.getProperties(
            imageBlob => p_image
          , attributes => p_attributes
          , mimeType => p_mimeType
          , width => p_width
          , height => p_height
          , fileFormat => p_fileFormat
          , contentFormat => p_contentFormat
          , compressionFormat => p_compressionFormat
          , contentLength => p_contentLength
        );

    end fetch_properties;
    
    function get_dimensions(
        p_image in BLOB
    )
    return image_dimensions
    as
        l_img_dimensions image_dimensions;
        
        l_attributes CLOB;
        l_mimeType varchar2(4000);
        l_width INTEGER;
        l_height INTEGER;
        l_fileFormat varchar2(4000);
        l_contentFormat varchar2(4000);
        l_compressionFormat varchar2(4000);
        l_contentLength INTEGER;
    begin
        fetch_properties(
            p_image,
            l_attributes,
            l_mimeType,
            l_width,
            l_height,
            l_fileFormat,
            l_contentFormat,
            l_compressionFormat,
            l_contentLength
        );
        
        l_img_dimensions.width := l_width;
        l_img_dimensions.height := l_height;        
        
        return l_img_dimensions;
    
    end get_dimensions;    
    
    
end image_api;
