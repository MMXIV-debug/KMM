// Inherit the parent event
event_inherited();

var _trail = instance_create_layer(x, y, "att", o_enemyS_path_trail);
_trail.origin_x = origin_x;
_trail.origin_y = origin_y;
_trail.end_x    = x;
_trail.end_y    = y;