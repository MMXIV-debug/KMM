// Inherit the parent event
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
        }
		break;


    case "fight":
		if(moveUp)
		{
			y -= hSpeed;
			if (y <= 96)
				moveUp = 0;
		}
		else
		{
			y += hSpeed;
			if (y > room_height - 96)
				moveUp = 1;
		}
		
		if(canShoot)
		{
			switch(weapon)
			{
				case "homing":
					canShoot = false; 
					alarm[0] = reloadSpeed;
					shootDir = point_direction(x, y, o_player.x, o_player.y);
					obj = instance_create_layer(x, y, "att", o_enemy_shoot_hom);
					obj.direction = shootDir;
					obj = instance_create_layer(x, y, "att", o_enemy_shoot_hom);
					obj.direction = shootDir +15;
					obj = instance_create_layer(x, y, "att", o_enemy_shoot_hom);
					obj.direction = shootDir -15;
					weapon = "multi";
					break;

					case "multi":
						canShoot = 0;
						alarm[0] = reloadSpeed;
						instance_create_layer(x,y,"att", o_enemy_shoot_hom);
						instance_create_layer(x ,y + 50,"att", o_enemy_shoot_hom);
						instance_create_layer(x ,y - 50,"att", o_enemy_shoot_hom);
						weapon = "homing";
					break;
				}
			}
		break;
}
 