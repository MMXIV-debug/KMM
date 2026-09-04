/// @description spawn-check
if (!enemy_alive)
{
    var top_limit = spawn_margin;
    var bottom_limit = room_height - spawn_margin;

    var sy = irandom_range(top_limit, bottom_limit);

    var enemy = instance_create_layer(spawn_x, sy, "Instances", enemy_type);
    enemy.spawner_id = id;

    enemy_alive = true;
}

alarm[0] = spawn_check_time;