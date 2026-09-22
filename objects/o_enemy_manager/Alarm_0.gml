if (alive_count < max_alive)
{
    var sx, sy, tx, ty, _side;

    if (variable_instance_exists(id, "spawn_sides") && array_length(spawn_sides) > 0)
    {
        _side = spawn_sides[irandom(array_length(spawn_sides) - 1)];
        switch (_side)
        {
            case "left":
                sx = -spawn_margin;
                sy = irandom_range(spawn_margin, room_height - spawn_margin);
                tx = irandom_range(250, 550);
                ty = sy;
                break;
            case "top":
                sy = -spawn_margin;
                sx = irandom_range(spawn_margin, room_width - spawn_margin);
                tx = sx;
                ty = irandom_range(150, 380);
                break;
            default:
                sy = irandom_range(spawn_margin, room_height - spawn_margin);
                sx = spawn_x + irandom_range(-spawn_x_jitter, spawn_x_jitter);
                tx = room_width - 520;
                ty = sy;
                break;
        }
    }
    else
    {
        sy = irandom_range(spawn_margin, room_height - spawn_margin);
        sx = spawn_x + irandom_range(-spawn_x_jitter, spawn_x_jitter);
        tx = room_width - 520;
        ty = sy;
        _side = "right";
    }

    var _type = enemy_type;
    if (array_length(spawn_types) > 0) _type = spawn_types[irandom(array_length(spawn_types) - 1)];

    var enemy = instance_create_layer(sx, sy, "Instances", _type);
    enemy.spawner_id = id;
    enemy.spawn_side = _side;
    enemy.origin_x   = sx;
    enemy.origin_y   = sy;
    enemy.target_x   = tx;
    enemy.target_y   = ty;

    alive_count++;
    enemy_alive = true;
}

alarm[0] = max(15, spawn_check_time + irandom_range(-spawn_variance, spawn_variance));