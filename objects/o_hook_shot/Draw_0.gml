var tip_x = x + length * facing_dir;
draw_set_color(make_color_rgb(255, 180, 60));
draw_line_width(x, y, tip_x, y, 4);
draw_circle(tip_x, y, 5, false);
draw_set_color(c_white);