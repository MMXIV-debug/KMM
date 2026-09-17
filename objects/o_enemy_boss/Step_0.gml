// Inherit the parent event
event_inherited();

// --------------------------------------------------------
// ENTRADA: se mueve hacia target_x
// --------------------------------------------------------
if (state == "enter")
{
    if (x > target_x)
    {
        x -= vSpeed;
    }
    else
    {
        x     = target_x;
        state = "fight";

        // Al entrar a "fight": primer disparo tras 1 segundo
        shoot_timer = 1 * room_speed;

        // Si RoomL o RoomS: crear un o_enemy_laser adherido al boss
        if (room == RoomL || room == RoomS)
        {
            if (!instance_exists(laser_inst))
            {
                laser_inst = instance_create_layer(x, y, "att", o_enemy_laser);
                // Configurar el laser para que no haga su propio movimiento
                laser_inst.state       = "idle";
                laser_inst.idle_timer  = 9999; // se controla desde aqui
            }
        }
    }
    exit;
}

// --------------------------------------------------------
// FIGHT: oscilacion vertical
// --------------------------------------------------------
if (moveUp)
{
    y -= hSpeed;
    if (y <= 96) moveUp = 0;
}
else
{
    y += hSpeed;
    if (y >= room_height - 96) moveUp = 1;
}

// Mantener laser adherido (sigue la posicion del boss)
if (instance_exists(laser_inst))
{
    laser_inst.x = x;
    laser_inst.y = y;
}

// --------------------------------------------------------
// TEMPORIZADOR DE DISPARO
// --------------------------------------------------------
if (shoot_timer > 0)
{
    shoot_timer--;
}
else if (instance_exists(o_player))
{
    // --- FASE segun sala ---

    if (room == RoomK)
    {
        var shots    = 10;   // par: abre un hueco al centro, obliga a moverse
        var spread   = 14;  // grados entre cada bala
        var base_dir = point_direction(x, y, o_player.x, o_player.y);

        for (var i = 0; i < shots; i++)
        {
            var _dir = base_dir + (i - (shots - 1) / 2) * spread;
            var obj  = instance_create_layer(x, y, "att", o_enemy_shoot_hom);
            obj.direction    = _dir;
            obj.image_angle  = _dir;
            obj.speed        = 20;  
            obj.image_xscale = 5;
            obj.image_yscale = 5;
            obj.dmg          = 25;   
        }
        shoot_timer = 2 * room_speed;
    }

    else if (room == RoomL)
    {
        // Alternancia: homing → laser → homing → laser...
        if (shoot_phase == 0)
        {
            var shots     = 5;   // cantidad de proyectiles
            var spread    = 12;  // grados entre cada uno
            var base_dir  = point_direction(x, y, o_player.x, o_player.y);

            for (var i = 0; i < shots; i++)
            {
                var _dir = base_dir + (i - (shots - 1) / 2) * spread;
                var obj  = instance_create_layer(x, y, "att", o_enemy_shoot_hom);
                obj.direction    = _dir;
                obj.image_angle  = _dir;
                obj.speed        = 20;   // era 12
                obj.image_xscale = 2.5;  // mas grande (la hitbox escala sola)
                obj.image_yscale = 2.5;
                obj.dmg          = 25;   // era 10
            }
            shoot_timer = 2 * room_speed;
        }
        else
        {
            // Activar laser si existe
            if (instance_exists(laser_inst))
            {
                laser_inst.state      = "idle";
                laser_inst.idle_timer = 20; // 0.33s de preparacion
            }
            shoot_timer = 5 * room_speed; // laser dura 2s + cooldown
        }
        shoot_phase = 1 - shoot_phase; // alterna 0/1
    }

    else if (room == RoomS)
    {
        // Tres fases rotativas: homing → laser → orbe
        if (shoot_phase == 0)
        {
            var obj = instance_create_layer(x, y, "att", o_enemy_shoot_hom);
            obj.direction = point_direction(x, y, o_player.x, o_player.y);
            obj.speed     = 12;
            shoot_timer   = 2 * room_speed;
        }
        else if (shoot_phase == 1)
        {
            if (instance_exists(laser_inst))
            {
                laser_inst.state      = "idle";
                laser_inst.idle_timer = 20;
            }
            shoot_timer = 5 * room_speed;
        }
        else // shoot_phase == 2: orbe explosivo
        {
            var orb = instance_create_layer(x, y, "att", o_boss_orb);
            orb.direction = point_direction(x, y, o_player.x, o_player.y);
            shoot_timer   = 3 * room_speed;
        }
        shoot_phase++;
        if (shoot_phase > 2) shoot_phase = 0;
    }
}

// --------------------------------------------------------
// INVOCACION DE MINIONS (cada 8 segundos en fight)
// --------------------------------------------------------
summon_timer++;
if (summon_timer >= summon_cd)
{
    summon_timer = 0;

    if (room == RoomK)
    {
        instance_create_layer(room_width + 64, irandom_range(96, room_height - 96), "Instances", o_enemy_fast);
        instance_create_layer(room_width + 64, irandom_range(96, room_height - 96), "Instances", o_enemy_fast);
    }
    else if (room == RoomL)
    {
        instance_create_layer(room_width + 64, irandom_range(96, room_height - 96), "Instances", o_enemyL_fast);
        instance_create_layer(room_width + 64, irandom_range(96, room_height - 96), "Instances", o_enemyL_fast);
    }
	/*else if (room == RoomS)
	{
		instance_create_layer(room_width + 64, irandom_range(96, room_height - 96), "Instances", o_enemyS_fast);
        instance_create_layer(room_width + 64, irandom_range(96, room_height - 96), "Instances", o_enemyS_fast);
	}*/
}

// Consecuencia de la muerte del o_player

if (instance_exists(o_player) && o_player.deaths > last_deaths)
{
    hp = min(hp + heal_on_kill * (o_player.deaths - last_deaths), hpMax);
    last_deaths = o_player.deaths;
}
