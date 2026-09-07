function c_weapon_standard()
{
	switch(argument0)
	{
		case 1:
			instance_create_layer(x+30,y, "att", o_standard_shot);
			break;
		case 2:
			instance_create_layer(x+30,y, "att", o_standard_shot_2);
			break;
		case 3:
			instance_create_layer(x+30,y, "att", o_standard_shot_3);
			break;
	}
	canShoot = 0;
	alarm[0] = reloadSpeed;
}