var dash = 14, gap = 10, total = dash + gap;
var _dist = point_distance(origin_x, origin_y, end_x, end_y);
var _dir  = point_direction(origin_x, origin_y, end_x, end_y);
var segs  = _dist / total;

var _alpha = clamp(life_timer / life_time, 0, 1) * 0.6;

draw_set_color(c_red);
draw_set_alpha(_alpha);

for (var i = 0; i < segs; i++)
{
    var d0 = i * total;
    var d1 = min(d0 + dash, _dist);
    draw_line_width(
        origin_x + lengthdir_x(d0, _dir), origin_y + lengthdir_y(d0, _dir),
        origin_x + lengthdir_x(d1, _dir), origin_y + lengthdir_y(d1, _dir), 3);
}

draw_set_alpha(1);
draw_set_color(c_white);