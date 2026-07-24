shader_type canvas_item;

void fragment() {
    // Grab the rendered black background & white text image from the viewport
    vec4 texture_color = texture(TEXTURE, UV);
    
    // Use the brightness of the white text to determine transparency.
    // If the pixel is white (text), alpha drops to 0.0 (fully cutout/see-through)
    float mask_alpha = 1.0 - texture_color.r;
    
    // Output the original button background color, clipped by the cutout shape
    COLOR = vec4(texture_color.rgb, mask_alpha);
}