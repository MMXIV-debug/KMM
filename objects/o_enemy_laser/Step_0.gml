event_inherited();

switch (state)
{
    case "enter":
        var _dir = point_direction(x, y, target_x, target_y);
        x += lengthdir_x(enter_speed, _dir);
        y += lengthdir_y(enter_speed, _dir);

        if (point_distance(x, y, target_x, target_y) <= enter_speed)
        {
            x = target_x;
            y = target_y;
            state = "idle";
        }
        break;

    case "idle":
        idle_timer--;
        if (idle_timer <= 0)
        {
            state = "aiming";
            aim_timer = aim_time;
            if (instance_exists(o_player))
                fire_direction = point_direction(x, y, o_player.x, o_player.y);
        }
        break;

    case "aiming":
        aim_timer--;
        if (instance_exists(o_player))
            fire_direction = point_direction(x, y, o_player.x, o_player.y);

        if (aim_timer <= 0)
        {
            state = "firing";
            laser_duration = 120;
            tick_timer = 0;
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
            shots_fired++;
            if (shots_fired >= max_shots)
            {
                state = "leave";
            }
            else
            {
                state = "cooldown";
                idle_timer = 50;
            }
        }
        break;

    case "cooldown":
        idle_timer--;
        if (idle_timer <= 0) state = "idle";
        break;

    case "leave":
        var _dir2 = point_direction(x, y, origin_x, origin_y);
        x += lengthdir_x(leave_speed, _dir2);
        y += lengthdir_y(leave_speed, _dir2);

        if (x < -margin_offscreen || x > room_width + margin_offscreen
        ||  y < -margin_offscreen || y > room_height + margin_offscreen)
        {
            instance_destroy();
        }
        break;
}