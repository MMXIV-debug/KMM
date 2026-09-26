if (hp <= 0)
{
    instance_destroy();
    exit;
}

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
            state = "fight";
        }
    break;

    case "fight":
        if (canShoot && instance_exists(o_player))
        {
            canShoot = false;
            alarm[0] = reloadSpeed;

            var _orb = instance_create_layer(x, y, "att", o_enemyS_orb);
            _orb.direction = point_direction(x, y, o_player.x, o_player.y);
        }
    break;
}