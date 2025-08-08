shader_type canvas_item;

// Drive with time OR progress (use one or both)
uniform float time;                 // animate per-frame (seconds)
uniform float progress : hint_range(0.0, 1.0) = 0.0; // tween this if you prefer

// Viewport size (set from GDScript at _ready and on resize)
uniform vec2 screen_size;

// Pattern params
uniform float pixel_size = 4.0;
uniform int offset = 3;
uniform int circle_size = 10;

void fragment() {
    // Sample the sprite's texture first
    vec4 base = texture(TEXTURE, UV);
    if (base.a == 0.0) {
        // Skip work for fully transparent texels
        COLOR = base;
        //return;
    }

    // Convert to pixel space for the pattern
    vec2 fragCoord = UV * screen_size;

    vec2 n = floor(fragCoord / pixel_size);
    vec2 p = n * pixel_size;

    int ym = int(n.x) / circle_size;
    int x = int(n.x) % circle_size;
    int y = (int(n.y) + (ym * offset)) % circle_size;

    vec2 centered = vec2(float(x), float(y)) - vec2(float(circle_size) / 2.0);
    float d = distance(centered, vec2(0.0));

    // Threshold can be driven by time (wavy) and/or linear progress
    float time_term = 1.0 + cos(time); // optional: remove if only using progress
    float sweep_term = 1.0 - (p.x / screen_size.x);

    // Combine terms: larger threshold = more pixels get removed
    float threshold = (time_term - sweep_term);

    // Allow progress to force the fade regardless of time:
    // progress 0 -> no removal; 1 -> full removal (scaled to circle_size)
    threshold += progress * 2.0; // tweak if you want faster/slower progress

    threshold *= float(circle_size);

    // mask = 1.0 where we want to remove the sprite (make transparent)
    float mask = d > threshold ? 1.0 : 0.0;

    // Punch holes by reducing alpha (don’t darken RGB)
    base.a *= (1.0 - mask);

    COLOR = base;
}
