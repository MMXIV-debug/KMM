// Stats

dmg = 60;
explode_radius = 160;
throw_speed = 20;
max_range = 420; 
facing_dir = 1;

// Control

state = "flying";  // flying -> stuck -> idle
target = noone;
off_x = 0;
off_y = 0;
traveled = 0;

// Visual de explosión
boom_timer    = 0;
boom_duration = 20;   // cuadros que dura el círculo (0.33s)