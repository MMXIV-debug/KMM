if (state != "boom")
{
    var pulse = sin(current_time / 80) * 3;
    draw_set_color(make_color_rgb(255, 140, 0));
    draw_circle(x, y, 10 + pulse, false);
    draw_set_color(make_color_rgb(255, 220, 150));
    draw_circle(x, y, 5 + pulse * 0.5, false);
}
else
{
    draw_set_alpha(0.5);
    draw_set_color(c_red);
    draw_circle(x, y, explode_radius, false);
    draw_set_alpha(1);
}
draw_set_color(c_white);