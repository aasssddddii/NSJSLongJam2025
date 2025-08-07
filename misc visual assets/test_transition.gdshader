shader_type canvas_item;

// simulate the ShaderToy uniforms
uniform float time:hint_range(0.0, 3.0);             // driven by GDScript
uniform vec2 screen_size;       // set to viewport size

// parameters you can tweak
uniform float pixel_size = 4.0;
uniform int offset = 3;
uniform int circle_size = 10;

void fragment() {
    // convert UV to pixel space
    vec2 fragCoord = UV * screen_size;
    vec4 col = vec4(0.0,0.0,0.0,1.0);

    // pixel coordinate
    vec2 n = floor(fragCoord / pixel_size);
    vec2 p = n * pixel_size;

    // y modifier group
    int ym = int(n.x) / circle_size;

    // calculate circle grid position
    int x = int(n.x) % circle_size;
    int y = (int(n.y) + (ym * offset)) % circle_size;

    vec2 centered = vec2(float(x), float(y)) - vec2(float(circle_size) / 2.0);

    // distance from center of the circle
    float d = distance(centered, vec2(0.0));

    // animated threshold
    float threshold = (1.0 + cos(time)) - p.x / screen_size.x;
    threshold *= float(circle_size);

    // draw white or black based on the threshold
    if (d > threshold) {
        col = vec4(0.0,0.0,0.0,1.0);
    } else {
        col = vec4(0.0);
    }

    COLOR = col;
}
