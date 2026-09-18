draw_set_color(state == "stuck" ? c_red : c_orange);
draw_circle(x, y, 10, false);
draw_set_color(c_white);

if (state == "boom")
{
    // círculo naranja que se agranda y se desvanece
    var _t     = 1 - (boom_timer / boom_duration); // 0 -> 1
    var _r     = lerp(10, explode_radius, _t);
    var _alpha = lerp(0.7, 0, _t);

    draw_set_alpha(_alpha);
    draw_set_color(c_orange);
    draw_circle(x, y, _r, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}