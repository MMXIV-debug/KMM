// 1. Deteccion de muerte y estado del player

if (!is_dead && hp <= 0)
{
    is_dead = true;
	deaths += 1;
	//instance_destroy(x,y, "Instances", o_death);
	y-=2000;
	alarm[1] = respawnTime;
    speed_x = 0;
    speed_y = 0;
}

if (is_dead)
{
    exit; // corta acá: no se mueve, no dashea, no ataca
}

if (invuln_timer > 0)
{
    invuln_timer--;
}

// ---------------------------------------------------------------
// HELPERS: lectura unificada teclado + gamepad Xbox One
// ---------------------------------------------------------------

var _pad = pad_num;
var _pad_connected = (_pad >= 0 && gamepad_is_connected(_pad));

// Left Stick ejes
var _stick_h = 0;
var _stick_v = 0;
if (_pad_connected)
{
    _stick_h = gamepad_axis_value(_pad, gp_axislh);
    _stick_v = gamepad_axis_value(_pad, gp_axislv);
}

// Funcion auxiliar: boton gamepad presionado (held)
// B          = gp_face2
// RB         = gp_shoulderr
// LT         = gp_shoulderlb  (eje, >0.15 = presionado)
// RT         = gp_shoulderrb  (eje, >0.15 = presionado)
// Right Arrow D-Pad = gp_padr
// Down  Arrow D-Pad = gp_padd

var _btn_attack_pad    = _pad_connected && gamepad_button_check_pressed(_pad, gp_face2);
var _btn_dash_pad      = _pad_connected && gamepad_button_check_pressed(_pad, gp_shoulderr);
var _btn_weapon_pad    = _pad_connected && gamepad_button_check_pressed(_pad, gp_padr);
var _btn_final_pad     = _pad_connected && (gamepad_axis_value(_pad, gp_shoulderlb) > 0.15);
var _btn_parry_pad     = _pad_connected && (gamepad_axis_value(_pad, gp_shoulderrb) > 0.15);
var _btn_extra_pad     = _pad_connected && gamepad_button_check_pressed(_pad, gp_padd);

// Para LT/RT guardamos estado anterior en variables persistentes para simular "pressed"
// (Los triggers son ejes continuos, no botones digitales)
if (!variable_instance_exists(id, "lt_prev")) lt_prev = false;
if (!variable_instance_exists(id, "rt_prev")) rt_prev = false;

var _lt_held = _pad_connected && (gamepad_axis_value(_pad, gp_shoulderlb) > 0.15);
var _rt_held = _pad_connected && (gamepad_axis_value(_pad, gp_shoulderrb) > 0.15);

var _btn_final_pressed = _lt_held && !lt_prev;   // LT  -> Poder Final (pressed)
var _btn_parry_pressed = _rt_held && !rt_prev;   // RT  -> Absorber/Parry (pressed)

lt_prev = _lt_held;
rt_prev = _rt_held;

// 2. Movimiento (dirección) ----------------------------

speed_x = 0;
speed_y = 0;

// Teclado
var dir_x = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var dir_y = keyboard_check(ord("S")) - keyboard_check(ord("W"));

// Gamepad: Left Stick (sobrescribe teclado si hay input de stick)
if (_pad_connected)
{
    if (abs(_stick_h) > 0 || abs(_stick_v) > 0)
    {
        dir_x = _stick_h;
        dir_y = _stick_v;
    }
}

// Con esto se controla el facing
if (room != RoomK && room != RoomS && room != RoomT)
{
    if (dir_x > 0) facing = 1;
    else if (dir_x < 0) facing = -1;
}
image_xscale = facing;

if (dir_x != 0 || dir_y != 0)
{
    var distancia = point_distance(0, 0, dir_x, dir_y);
    dir_x /= distancia;
    dir_y /= distancia;
}

// 3. Dash ----------------------------

if (dash_cooldown_timer > 0) dash_cooldown_timer--;

// Dash: I (teclado) OR RB (gamepad)
var _do_dash = keyboard_check_pressed(ord("I")) || _btn_dash_pad;

if (_do_dash && dash_cooldown_timer <= 0 && dash_timer <= 0)
{
    if (dir_x == 0 && dir_y == 0)
    {
        dash_dir_x = 0;
        dash_dir_y = -1;
    }
    else
    {
        dash_dir_x = dir_x;
        dash_dir_y = dir_y;
    }
    dash_timer = dash_duration;
    dash_cooldown_timer = dash_cooldown;

    invuln_timer = max(invuln_timer, dash_duration + dash_iframe_extra);

    show_debug_message("DASH!");
}

if (dash_timer > 0)
{
    speed_x = dash_dir_x * dash_speed;
    speed_y = dash_dir_y * dash_speed;
    dash_timer--;
}
else
{
    speed_x = dir_x * move_speed;
    speed_y = dir_y * move_speed;
}

// 4. Aplicar movimiento ----------------------------

x += speed_x;
y += speed_y;

// 4.5 Limitar al player dentro de la pantalla ----------------------------

if (bbox_left < 0)
{
    x -= bbox_left;
}
if (bbox_right > room_width)
{
    x -= (bbox_right - room_width);
}
if (bbox_top < 0)
{
    y -= bbox_top;
}
if (bbox_bottom > room_height)
{
    y -= (bbox_bottom - room_height);
}

// 5. Ataque con cooldown funcional ----------------------------

if (attack_timer > 0)
{
    attack_timer--;
    canShoot = 0;
}
else
{
    canShoot = 1; 
}

// Ataque: J (teclado) OR B (gamepad, gp_face2)
var _do_attack = (keyboard_check_pressed(ord("J")) || _btn_attack_pad) && canShoot;

if (_do_attack)
{
    if (room == RoomL)
    {
		switch (weapon_RoomL)
		{
			case "Slash":
				c_weapon_slash();
				break;

			case "Hook":
				c_weapon_hook();
				break;
			case "Bomb":
			    c_weapon_bomb();
			    break;
		}
	attack_timer = attack_cooldown;
	canShoot = 0;
    }
	else if (room == RoomK or room == RoomT)
	{
		switch(weapon)
	    {
			//Armas de la RoomK
	        case "Standard":
	            c_weapon_standard(powlvl);
	            break;
			case "Spread":
			    c_weapon_spread(powlvl);
			    overdrive_shots_left--;

			    if (overdrive_shots_left <= 0)
			    {
			        if (pending_weapon != "")
			        {
			            weapon = pending_weapon;
			            pending_weapon = "";
			        }
			        else
			        {
			            weapon = "Standard";
			        }
			    }
			    break;
			case "Homing":
				c_weapon_homing(powlvl);
				break;
		
	    }
	attack_timer = attack_cooldown;
	canShoot = 0;
	}
	else if (room == RoomS || room == RoomT)
	{
		switch(weapon)
		{
			case "bucket":
				c_weapon_bucket(x, y, facing);
				break;
		}
	}
    attack_timer = attack_cooldown;
    canShoot = 0;
}

// 6. Inventario de armas RoomL ----------------------------
// Cambio arma: K (teclado) OR Right Arrow D-Pad (gamepad)

if (keyboard_check_pressed(ord("K")) || _btn_weapon_pad)
{
    total_weapons = array_length(weapon_slots);

    if (total_weapons > 1)
    {
        current_weapon_index++;

        if (current_weapon_index >= total_weapons)
        {
            current_weapon_index = 0;
        }

        weapon_RoomL = weapon_slots[current_weapon_index];

        show_debug_message(
            "Arma Room L actual: " + weapon_RoomL
        );
    }
}

// 7. Poder Final (LT gamepad) ----------------------------
// TODO: conectar con la logica de poder final cuando este implementada
if (_btn_final_pressed)
{
    show_debug_message("PODER FINAL activado (LT)");
    // Agregar aqui la llamada al poder final del jugador
}

// 8. Parry / Absorber (O teclado, RT gamepad) ----------------------------
if (parry_cooldown_timer > 0) parry_cooldown_timer--;

if (parry_timer > 0)
{
    parry_timer--;
    if (parry_timer <= 0) parry_active = false;
}

var _do_parry = keyboard_check_pressed(ord("O")) || _btn_parry_pressed;

if (_do_parry && room == RoomS && parry_cooldown_timer <= 0 && !parry_active)
{
    parry_active = true;
    parry_timer = parry_duration;
    parry_cooldown_timer = parry_cooldown;
    show_debug_message("PARRY activado!");
}

// 9. Mecanica extra (Down Arrow D-Pad gamepad) ----------------------------
// TODO: conectar con la mecanica extra cuando este implementada
if (_btn_extra_pad && room == RoomT || room == RoomK || room == RoomS || room == RoomL)
{
    show_debug_message("MECANICA EXTRA activada (D-Pad Down)");
    // Agregar aqui la llamada a la mecanica extra
}

if (!is_attacking)
{
    if (room == RoomL) sprite_index = s_player_2;
    else if (room == RoomS) sprite_index = s_player_3;
}

