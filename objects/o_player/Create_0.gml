// Stats ----------------------

speed_x = 0;
speed_y = 0;

move_speed = 9;
respawnTime = 1 * room_speed; 

// Estado ---------------
State = 0;
max_hp = 100;
hp = max_hp;

total_hearts = 6;

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
overdrive_shots_left = 0;

gpu_set_texfilter(false);

weapon = "Standard";
if (variable_global_exists("weapon_override"))
{
    weapon = global.weapon_override;
}
show_debug_message("Player creado con weapon: " + weapon);

powerup_duration = 600; // 600 pasos = 10 segundos a 60 FPS
facing = 1; //Lugar a donde esta viendo 1 = derecha, -1 = izquierda

// Control
is_dead = false;
deaths = 0;
invuln_duration = 60;
invuln_timer = 0;
is_attacking = false;
dash_iframe_extra = 15; // frames extra de i-frames al terminar el dash (~0.1s a 60fps)

pending_weapon = "";

// Gamepad (Xbox One) --------------------------
pad_num = -1;
pad_dead_zone = 0.25; // Dead zone para el stick analogico

// Buscar el primer gamepad conectado
for (var _i = 0; _i < 4; _i++)
{
    if (gamepad_is_connected(_i))
    {
        pad_num = _i;
        gamepad_set_axis_deadzone(pad_num, pad_dead_zone);
        show_debug_message("Gamepad detectado en slot: " + string(pad_num));
        break;
    }
}

// Constantes de botones Xbox One (GameMaker):
//   gp_face1 = A,  gp_face2 = B,  gp_face3 = X,  gp_face4 = Y
//   gp_shoulderl  = LB,  gp_shoulderr  = RB
//   gp_shoulderlb = LT,  gp_shoulderrb = RT  (ejes, rango 0..1)
//   gp_padr / gp_padl / gp_padu / gp_padd = D-Pad
//   gp_axislh / gp_axislv = Left Stick eje horizontal / vertical
//   gp_axisrh / gp_axisrv = Right Stick eje horizontal / vertical

// Extras de la Sala L

if (room == RoomL)
{
    global.roomL_kills = 0; // Contador global de kills para desbloqueo de armas en la RoomL
}

weapon_slots = ["Slash"];
current_weapon_index = 0;
weapon_RoomL = "Slash";
total_weapons = array_length(weapon_slots);

