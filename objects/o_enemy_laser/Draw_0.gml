draw_self();

if (state == "firing")
{
    draw_set_color(c_red);
    draw_line_width(x, y, x + lengthdir_x(beam_length, fire_direction), y + lengthdir_y(beam_length, fire_direction), 6);
    draw_set_color(c_white);
}