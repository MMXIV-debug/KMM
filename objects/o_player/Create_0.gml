// Stats ----------------------

speed_x = 0;
speed_y = 0;

move_speed = 9;

// Estado ---------------
State = 0;
hp = 100;

// Dash -----------------------

dash_speed = 20;
dash_duration = 12;
dash_timer = 0;

dash_cooldown = 30;
dash_cooldown_timer = 0;

dash_dir_x = 0;
dash_dir_y = 0;

// Ataque ----------------------

attack_cooldown = 20;
attack_timer = 0;
 
canShoot = 1;
reloadSpeed = 15;
powlvl = 1;
powMax = 3;

// Extras ----------------------

gpu_set_texfilter(false);
weapon = "Standard";
if (variable_global_exists("weapon_override"))
{
    weapon = global.weapon_override;
}
show_debug_message("Player creado con weapon: " + weapon);

powerup_duration = 600; // 600 pasos = 10 segundos a 60 FPS
facing = 1; //Lugar a donde esta viendo 1 = derecha, -1 = izquierda