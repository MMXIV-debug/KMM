// Stats ---------------------------
hpMax = 250;
hp = hpMax;
dmg = 20;

vSpeed = 1.5; // Velocidad horizontal de entrada
hSpeed = 4;   // Velocidad oscilacion vertical

image_xscale = 10;
image_yscale = 10;

target_x = room_width - 600;

// Movimiento
state = "enter";
moveUp = 1;

// Disparo
canShoot   = false; // false hasta que entre a "fight"
shoot_timer = 0;

// Fases de ataque (rotacion de armas)
// Se configura segun la sala al entrar a "fight"
shoot_phase = 0;

// Temporizador de invocacion de minions
summon_timer  = 0;
summon_cd     = 8 * room_speed; // cada 8 segundos

// Referencia al laser adherido (RoomL y RoomS)
laser_inst = noone;

// Extras
last_deaths = instance_exists(o_player) ? o_player.deaths : 0;
heal_on_kill = 100;