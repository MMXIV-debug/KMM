// 1. Deteccion de muerte y estado del player

if (!is_dead && hp <= 0)
{
    is_dead = true;
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

// 2. Movimiento (dirección) ----------------------------

speed_x = 0;
speed_y = 0;

var dir_x = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var dir_y = keyboard_check(ord("S")) - keyboard_check(ord("W"));

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

if (keyboard_check_pressed(ord("I")) && dash_cooldown_timer <= 0 && dash_timer <= 0)
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

if (keyboard_check_pressed(ord("J")) && canShoot)
{
    if (room == RoomL)
    {
		switch (weapon_RoomL)
		{
			case "Slash":
				c_weapon_slash();
				break;

			case "Spin":
				c_weapon_spin();
				break;

			case "Boomerang":
				c_weapon_boomerang();
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
	}
    attack_timer = attack_cooldown;
    canShoot = 0;
}

// 6 Inventario de armas RoomL


if (keyboard_check_pressed(ord("K")))
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

if (invuln_timer > 0)
{
    show_debug_message("INVULNERABLE: " + string(invuln_timer));
}