// Stats
hp = 30;

vSpeed = 5;
accel = 0.1;
speedMax = 9;

dmg = 10;
pSpeed = 3.9;


// Comportamiento
canShoot = true;

reloadSpeed = 90;

state = "enter";

spawner_id = noone;

// Posición objetivo
target_x = room_width - 520;


// Tiempo de combate
fight_t = 6 * room_speed;


// Alarmas
alarm[0] = irandom(120);
alarm[1] = -1;


// Extras
gpu_set_texfilter(false);
drop_chance = 5; // % de probabilidad de soltar el power-up