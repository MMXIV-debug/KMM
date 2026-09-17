// inicio de los stados
switch(state)
{
	case "flying":
		x += throw_speed * facing_dir;
		traveled += throw_speed;
		
		// Se pega a lo primero que toque
		var e = instance_place(x, y, o_enemy_body);
		if (e == noone && instance_exists(o_enemy_boss))
		{
			if (place_meeting(x, y, o_enemy_boss))
				e = instance_nearest(x, y, o_enemy_boss);
		}
		if (e != noone)
		{
			state = "stuck";
			target = e;
			// Guarda una posicion relativa
			off_x = x - e.x;
			off_y = y - e.y;
		}
		else if (traveled >= max_range || x < 0 || x > room_width)
		{
			state = "idle"; //La dejamos flotando todavia activable
		}
		break;
	case "stuck":
		if (!instance_exists(target))
		{
			instance_destroy(); // El target murio por ende la bomba desaparece
			exit;
		}
		x = target.x + off_x;
		y = target.y + off_y;
		break;
}