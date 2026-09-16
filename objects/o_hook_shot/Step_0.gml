if (state == "flying")
{
    x += travel_speed * facing_dir;
    traveled += travel_speed;

    var enemy = instance_place(x, y, o_enemy_body);
    if (enemy != noone)
    {
        enemy.hp -= dmg;
        target_enemy = enemy;
        state = "pulling";
    }
    else if (traveled >= max_range)
    {
        instance_destroy();
    }
}
else if (state == "pulling")
{
    if (!instance_exists(target_enemy))
    {
        instance_destroy();
        exit;
    }

    var dir_to_player = point_direction(target_enemy.x, target_enemy.y, o_player.x, o_player.y);
    target_enemy.x += lengthdir_x(pull_speed, dir_to_player);
    target_enemy.y += lengthdir_y(pull_speed, dir_to_player);

    if (point_distance(target_enemy.x, target_enemy.y, o_player.x, o_player.y) < 40)
    {
        instance_destroy();
    }
}