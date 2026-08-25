function c_weapon_standard()
{
	switch(argument0)
	{
		case 1:
			instance_create_layer(x,y-20, "att", o_standard_shoot);
			break;
		case 2:
			instance_create_layer(x,y-20, "att", o_standard_shoot_2);
			break;
		case 3:
			instance_create_layer(x,y-20, "att", o_standard_shoot_3);
			break;
	}
	canShoot = 0;
	alarm[0] = reloadSpeed;
}