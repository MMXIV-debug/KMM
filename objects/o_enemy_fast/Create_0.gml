move_speed = 10;
dmg = 30;
hp = 10;

var paths = [path_kamikaze_1, path_kamikaze_2, path_kamikaze_3];
var chosen_path = paths[irandom(array_length(paths) - 1)];
path_start(chosen_path, move_speed, path_action_stop, false);

gpu_set_texfilter(false);