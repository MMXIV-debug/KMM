// Stats ---------------------------
hpMax = 250;

if (room == RoomL)
{
    hpMax = 2500;
    sprite_index = s_final_boss_1;
}

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
shoot_phase = 0;

// Temporizador de invocacion de minions
summon_timer  = 0;
summon_cd     = 8 * room_speed; // cada 8 segundos

// Referencia al laser adherido (RoomL y RoomS)
laser_active        = false;
laser_state         = "aiming";
laser_timer         = 0;
laser_direction     = 0;
laser_aim_time      = 45;    // 0.75s de aviso
laser_duration      = 120;   // 2s de rayo activo
laser_tick_interval = 15;    // daño cada 0.25s
laser_tick_timer    = 0;
laser_dmg_per_tick  = 5;
laser_beam_length   = 3000;
laser_aim_length    = 1600;

// Extras
last_deaths = instance_exists(o_player) ? o_player.deaths : 0;
heal_on_kill = 100;