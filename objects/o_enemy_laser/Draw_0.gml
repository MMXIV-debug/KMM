draw_self();

if (state == "aiming")
{
    var dash = 14, gap = 10, total = dash + gap;
    var segs = aim_length / total;

    draw_set_color(c_red);
    draw_set_alpha((aim_timer mod 20) < 10 ? 0.35 : 0.85); // parpadeo

    for (var i = 0; i < segs; i++)
    {
        var d0 = i * total;
        var d1 = d0 + dash;
        draw_line_width(
            x + lengthdir_x(d0, fire_direction), y + lengthdir_y(d0, fire_direction),
            x + lengthdir_x(d1, fire_direction), y + lengthdir_y(d1, fire_direction), 2);
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
}

if (state == "firing")
{
    draw_set_color(c_blue);
    draw_line_width(x, y, x + lengthdir_x(beam_length, fire_direction), y + lengthdir_y(beam_length, fire_direction), 6);
    draw_set_color(c_white);
}