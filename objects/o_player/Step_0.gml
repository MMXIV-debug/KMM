
speed_x = 0;
speed_y = 0;

// 2. Movimiento (dirección) ----------------------------

var dir_x = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var dir_y = keyboard_check(ord("S")) - keyboard_check(ord("W"));

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

// 5. Límites ----------------------------

var mitad_w = 65 / 2;
var mitad_h = 65 / 2;
x = clamp(x, mitad_w, room_width - mitad_w);
y = clamp(y, room_height / 2 + mitad_h, room_height - mitad_h);


// 6. Ataque con cooldown funcional ----------------------------

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
    switch(weapon)
    {
        case "Standard":
            c_weapon_standard(powlvl);
            break;
    }
    attack_timer = attack_cooldown;
    canShoot = 0;
}