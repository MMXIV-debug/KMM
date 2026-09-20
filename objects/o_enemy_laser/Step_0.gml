// Inherit the parent event
event_inherited();

switch(state)
{
	case "enter":
		if (x > target_x)
        {
            x -= vSpeed;
        }
        else
        {
            x = target_x;
            state = "fight";
            alarm[1] = fight_t;
        }
		break;
    case "idle":
        idle_timer--;
         if (idle_timer <= 0)
        {
            state     = "aiming";
            aim_timer = aim_time;
            fire_direction = point_direction(x, y, o_player.x, o_player.y);
        }
        break;

    case "aiming":
        aim_timer--;
        // sigue al player mientras apunta
        if (instance_exists(o_player))
            fire_direction = point_direction(x, y, o_player.x, o_player.y);

        if (aim_timer <= 0)
        {
            state          = "firing";
            laser_duration = 120;
            tick_timer     = 0;
        }
        break;

    case "firing":
        laser_duration--;
        tick_timer--;

        if (tick_timer <= 0)
        {
            tick_timer = tick_interval;

            if (collision_line(x, y, x + lengthdir_x(beam_length, fire_direction), y + lengthdir_y(beam_length, fire_direction), o_player, false, true))
            {
                with (o_player)
                {
                    c_player_take_damage(other.dmg_per_tick);
                }
            }
        }

        if (laser_duration <= 0)
        {
            state = "cooldown";
            idle_timer = 150;
        }
        break;

    case "cooldown":
        idle_timer--;
        if (idle_timer <= 0)
        {
            state = "idle";
            idle_timer = 90;
        }
        break;
}