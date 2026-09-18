/// @description spawn-check
if (alive_count < max_alive)
{
    var sy = irandom_range(spawn_margin, room_height - spawn_margin);
    var sx = spawn_x + irandom_range(-spawn_x_jitter, spawn_x_jitter);

    var _type = enemy_type;
    if (array_length(spawn_types) > 0)
    {
        _type = spawn_types[irandom(array_length(spawn_types) - 1)];
    }

    var enemy = instance_create_layer(sx, sy, "Instances", _type);
    enemy.spawner_id = id;

    alive_count++;
    enemy_alive = true;
}

alarm[0] = max(15, spawn_check_time + irandom_range(-spawn_variance, spawn_variance));