#version 330

uniform sampler2D MainSampler;
uniform sampler2D DataSampler;
uniform sampler2D BlurSampler;

uniform vec2 OutSize;

#moj_import <shader_selector:marker_settings.glsl>
#moj_import <shader_selector:utils.glsl>
#moj_import <shader_selector:data_reader.glsl>

in vec2 texCoord;

out vec4 fragColor;

void main() {
    vec4 texColor = texture(MainSampler, texCoord); // Fetch base texture color
    fragColor = texColor; // Initialize fragColor

    // Apply Tritanopia colorblind effect using the provided matrix
        vec3 color = fragColor.rgb;
        // New Protanopia transformation matrix
mat3 protanopiaMatrix = mat3(
    0.567, 0.433, 0.0,    // Red transformation
    0.558, 0.442, 0.0,    // Green transformation
    0.0,   0.242, 0.758   // Blue transformation
);
        color = protanopiaMatrix * color; // Apply the Protanopia transformation
        fragColor.rgb = mix(fragColor.rgb, color, 1);
 
#ifdef DEBUG
    // Show data sampler on screen
    if (texCoord.x < .25 && texCoord.y < .25) {
        vec2 debugUV = texCoord * 4.0;
        vec4 col = texture(DataSampler, debugUV);
        if (debugUV.x > 1. / 5.0)
            col = vec4(vec3(fract(decodeColor(col))), 1.0);
        fragColor = col;
    }
#endif
}
