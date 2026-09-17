function c_bomb_explode(_x, _y, _radius, _dmg){
	with(o_enemy_body)
	{
		if(point_distance(x, y, _x, _y) <= _radius) 
			hp -= _dmg;
	}
	with (o_enemy_boss)
    {
        if (point_distance(x, y, _x, _y) <= _radius) 
		hp -= _dmg;
    }
	if (instance_exists(o_player) && point_distance(o_player.x, o_player.y, _x, _y) <= _radius)
	{
	    with (o_player) c_player_take_damage(15);
	}
}