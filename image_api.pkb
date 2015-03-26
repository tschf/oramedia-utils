create or replace package body image_api
as

    subtype command is varchar2(50);

    function runCommand(
        p_image in BLOB
      , p_command in command)
    return BLOB
    as
        l_returnBlob BLOB;
    begin
    
        dbms_lob.createtemporary(l_returnBlob, true);
        
        ORDSYS.ORDImage.processCopy(
            p_image
          , p_command
          , l_returnBlob
        );
        
        return l_returnBlob;
    
    end runCommand;

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
    
    function crop(
        p_image in BLOB
      , p_x_start in NUMBER
      , p_y_start in NUMBER
      , p_width in NUMBER default NULL
      , p_height in NUMBER default NULL) 
    return BLOB
    as  
        l_crop_command command;
        
        l_dimensions image_dimensions;
    begin
        l_crop_command := 'cut #X# #Y# #WIDTH# #HEIGHT#';
        
        l_crop_command := replace(l_crop_command, '#X#', p_x_start);
        l_crop_command := replace(l_crop_command, '#Y#', p_y_start);
        l_crop_command := replace(l_crop_command, '#WIDTH#', p_width);
        l_crop_command := replace(l_crop_command, '#HEIGHT#', p_height);
        
        l_dimensions := get_dimensions(p_image);
        
        if p_width + p_x_Start > l_dimensions.width
            or p_height + p_y_start > l_dimensions.height
        then
            raise dimension_too_large;
        end if;
        
        return runCommand(p_image, l_crop_command);
    end crop;
    
    function vertical_flip(
        p_image in BLOB)
    return BLOB
    as
        l_flip_command command;
    begin
        l_flip_command := 'flip';
        
        return runCommand(p_image, l_flip_command);
    
    end vertical_flip;
    
    function horizontal_flip(
        p_image in BLOB)
    return BLOB
    as
        l_flip_command command;
    begin
        l_flip_command := 'mirror';
        
        return runCommand(p_image, l_flip_command);
    
    end horizontal_flip;    
    
    
end image_api;
