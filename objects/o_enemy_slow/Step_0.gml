event_inherited();

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
            alarm[1] = fight_t;
        }

    break;


    case "fight":

        if (canShoot)
        {
            canShoot = false;
            alarm[0] = reloadSpeed;
            if (instance_exists(o_player))
            {
                var obj = instance_create_layer(x, y, "att", o_enemy_shoot_hom);
                obj.direction = point_direction(x,y,o_player.x,o_player.y);
                obj.speed = 15;
            }
        }

    break;


    case "escape":

        if (vSpeed < speedMax)
        {
            vSpeed += accel;
        }
        x -= vSpeed;
        if (x < -64)
        {
            instance_destroy();
        }

    break;
}