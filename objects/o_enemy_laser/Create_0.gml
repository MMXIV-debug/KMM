hp = 25;

// Entrada / salida
spawn_side = "left";   // el spawner lo va a sobreescribir
origin_x = x;
origin_y = y;
target_x = x;
target_y = y;
enter_speed = 6;
leave_speed = 8;
margin_offscreen = 80;

state = "enter";

idle_timer = 40;
laser_duration = 120;
tick_interval = 15;
tick_timer = 0;
dmg_per_tick = 5;
beam_length = 3000;
fire_direction = 0;
aim_time   = 45;
aim_timer  = 0;
aim_length = 1600;

shots_fired = 0;
max_shots = 2;   // veces que apunta+dispara antes de irse

image_xscale = 2;
image_yscale = 2;