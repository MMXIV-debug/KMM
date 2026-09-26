if (hp <= 0)
{
    instance_destroy();
    exit;
}

switch (state)
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
        }
    break;

    case "fight":
        if (canShoot)
        {
            canShoot = false;
            alarm[0] = reloadSpeed;

            var _offset = irandom(35); // rota un poco cada ráfaga, se ve mejor
            for (var i = 0; i < bullet_count; i++)
            {
                var _dir = _offset + (360 / bullet_count) * i;
                var _b = instance_create_layer(x, y, "att", o_enemy_shoot_hom);
                _b.direction = _dir;
                _b.speed = bullet_speed;
            }

            shots_fired++;
            if (shots_fired >= max_shots)
            {
                state = "escape";
            }
        }
    break;

    case "escape":
        if (vSpeed < speedMax) vSpeed += accel;
        x -= vSpeed;
        if (x < -64) instance_destroy();
    break;
}